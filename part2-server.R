# Sensitivity - anystate

library(msm)
library(arrow)
library(dplyr)
library(ggplot2)



# =========================
# 1. 读取数据
# =========================
df_states <- read_parquet("File/Part Data/part2-sensitivity-anystate.parquet")
# 查看结构
str(df_states)
head(df_states)



# =========================
# 2. 数据整理
# =========================
df_states <- df_states %>%
  arrange(`身份证号`, time) %>%
  mutate(
    state = as.integer(state),
    time_years = as.numeric(time_years),
    payment = as.factor(payment),
    gender = as.factor(gender)
  )

# 支付方式
df_states$payment <- relevel(df_states$payment, ref = "SP")
# 年龄
df_states$age10 <- df_states$age / 10
# 性别
df_states$gender <- factor(df_states$gender, levels = c(0, 1))

# =========================
# 4. 定义初始 Q 矩阵
# =========================
Q_init <- rbind(
  c(0, 0.10, 0.10, 0.05, 0),
  c(0, 0,    0,    0,    0.10),
  c(0, 0,    0,    0,    0.10),
  c(0, 0,    0,    0,    0.10),
  c(0, 0,    0,    0,    0)
)

rownames(Q_init) <- colnames(Q_init) <- c("State1", "State2", "State3", "State4", "State5")


msm_full <- msm(
  state ~ time_years,
  subject = `身份证号`,
  data = df_states,
  qmatrix = Q_init,
  covariates = ~ payment + age10 + gender,
  gen.inits = FALSE,
  control = list(fnscale = 4000, maxit = 3000, trace = 1, reltol = 1e-10)
)


saveRDS(msm_full, 
        'File/Result/Model/sensitivity_anystate.RDS')


## pmatrix

# =========================
# 0-6年各状态转移概率（msm_full）
# 固定 age 和 gender，仅比较不同 payment
# =========================

time_points <- seq(0, 6, by = 0.05)
payment_types <- levels(df_states$payment)

# 这里建议明确指定一个代表性年龄和性别
ref_age <- mean(df_states$age, na.rm = TRUE) / 10
ref_gender <- levels(df_states$gender)[1]   # 例如 "0.0" 或 "1.0"

res_list <- list()
k <- 1

for (pay_type in payment_types) {
  cat("处理支付方式:", pay_type, "\n")
  
  for (t in time_points) {
    p_result <- pmatrix.msm(
      msm_full,
      t = t,
      covariates = list(
        payment = pay_type,
        age10 = ref_age,
        gender = ref_gender
      ),
      ci = "normal",
      B = 200
    )
    
    est <- p_result$estimates
    low <- p_result$L
    upp <- p_result$U
    
    res_list[[k]] <- data.frame(
      t = t,
      type = pay_type,
      age = ref_age,
      gender = ref_gender,
      
      r12  = est[1, 2],
      r12l = low[1, 2],
      r12u = upp[1, 2],
      
      r13  = est[1, 3],
      r13l = low[1, 3],
      r13u = upp[1, 3],
      
      r14  = est[1, 4],
      r14l = low[1, 4],
      r14u = upp[1, 4],
      
      r25  = est[2, 5],
      r25l = low[2, 5],
      r25u = upp[2, 5],
      
      r35  = est[3, 5],
      r35l = low[3, 5],
      r35u = upp[3, 5],
      
      r45  = est[4, 5],
      r45l = low[4, 5],
      r45u = upp[4, 5]
    )
    
    k <- k + 1
  }
}

cumulative_risk_full <- do.call(rbind, res_list)


# 导出
arrow::write_parquet(
  cumulative_risk_full,
  "File/Result/Sensitivity-anystate/pmatrix.parquet"
)


## ppass

# =========================
# msm_full: 用 ppass.msm() 计算累计到达概率（带CI）
# =========================

library(msm)
library(dplyr)
library(arrow)

time_points <- seq(0, 6, by = 0.1)
payment_types <- levels(df_states$payment)

# 固定协变量
ref_age <- mean(df_states$age, na.rm = TRUE) / 10
ref_gender <- levels(df_states$gender)[1]

res_list <- list()
k <- 1

for (pay_type in payment_types) {
  cat("处理支付方式:", pay_type, "\n")
  
  for (t in time_points) {
    p_result <- ppass.msm(
      msm_full,
      tot = t,
      covariates = list(
        payment = pay_type,
        age10 = ref_age,
        gender = ref_gender
      ),
      ci = "normal",
      B = 200
    )
    
    est <- p_result$estimates
    low <- p_result$L
    upp <- p_result$U
    
    res_list[[k]] <- data.frame(
      t = t,
      type = pay_type,
      age10 = ref_age,
      gender = ref_gender,
      
      # 从 state1 出发，到时间 t 为止已访问过某状态的概率
      p12  = est[1, 2],
      p12l = low[1, 2],
      p12u = upp[1, 2],
      
      p13  = est[1, 3],
      p13l = low[1, 3],
      p13u = upp[1, 3],
      
      p14  = est[1, 4],
      p14l = low[1, 4],
      p14u = upp[1, 4],
      
      p15  = est[1, 5],
      p15l = low[1, 5],
      p15u = upp[1, 5],
      
      # 从 state2/3/4 出发，到时间 t 为止已访问过 state5 的概率
      p25  = est[2, 5],
      p25l = low[2, 5],
      p25u = upp[2, 5],
      
      p35  = est[3, 5],
      p35l = low[3, 5],
      p35u = upp[3, 5],
      
      p45  = est[4, 5],
      p45l = low[4, 5],
      p45u = upp[4, 5]
    )
    
    k <- k + 1
  }
}

cumulative_pass_table <- bind_rows(res_list)

head(cumulative_pass_table)



# 导出
arrow::write_parquet(
  cumulative_pass_table,
  "File/Result/Part2/Sensitivity-anystate/ppass.parquet"
)
