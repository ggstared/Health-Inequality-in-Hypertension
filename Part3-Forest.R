library(readxl)
library(forestplot)

df <- read_excel("E:/vscode/Paper/Health  Inequalities in Hypertension/Revision1/File/Result/Part3/main/main.xlsx", sheet = 'Forest')

tabletext <- data.frame(df$variables, df$allcausetext, df$spetext)

df$allcauseest <- as.numeric(df$allcauseest)
df$allcauselower <- as.numeric(df$allcauselower)
df$allcauseupper <- as.numeric(df$allcauseupper)

df$speest <- as.numeric(df$speest)
df$spelower <- as.numeric(df$spelower)
df$speupper <- as.numeric(df$speupper)

mean <- cbind(df$allcauseest, df$speest)
lower <- cbind(df$allcauselower, df$spelower)
upper <- cbind(df$allcauseupper, df$speupper)

is_summary_logical <- as.logical(ifelse(df$summary == "T", "TRUE", "FALSE"))
is_summary_logical

p <-forestplot(	
  tabletext,
  mean = mean,
  lower = lower,
  upper = upper,
  legend = c('Allcause', 'spe-cause'),
  boxsize = c(0.2,0.2),
  fn.ci_norm = c(fpDrawNormalCI, fpDrawCircleCI),
  # clip = c(0, 3),
  line.margin = 0.2,
  lwd.ci = 1.5,
  zero = 1,
  col = fpColors(
    box = c("#BC3C28", "#0972B5"),
    lines = c("#BC3C28", "#0972B5"),
  ),
  xlab = 'Percent change in cost (%)',
  txt_gp = fpTxtGp(label = gpar(cex = 0.75),
                   ticks = gpar(cex = 0.8),
                   xlab = gpar(cex = 0.8),
                   title = gpar(cex = 0.8),
                   legend = gpar(cex = 1.1)),
  colgap = unit(2, "mm"),
  lineheight = unit(6.5, "mm"),
  legend.pos = "bottom",
  is.summary = is_summary_logical,
  # xticks = c(-65, -40, -15, 10, 35, 60, 75)
  # xticks = c(-40, -15, 10, 35)
  
)
p <- fp_set_zebra_style(p, "#F5F7FA", ignore_subheaders = TRUE)
p

pdf("E:/vscode/Paper/Health  Inequalities in Hypertension/Revision1/File/Figure/Part3/main/Cox.pdf", width=6, height=4)
p
dev.off()


