# README

本仓库包含论文撰写过程中所使用的分析代码。

## 项目使用流程

### 主分析部分

1. 运行 `integrate data.ipynb`，生成 `hp_concat.parquet` 文件。

2. 运行 `create data.ipynb`，分别生成各分析部分所需的数据文件：

   - **Part 1 - Cost**
     - 生成 `File/Part Data/part1-main.parquet`
     - 该文件用于 `Part1-Cost.Rmd`，以生成第一部分分析结果
     - 结果保存在 `File/Result/Part1/main/` 文件夹中
     - 进一步整理后的结果汇总于 `File/Result/Part1/main/Part1-main.xlsx`
     - 正文图表绘制：
       - `FigurePlot.ipynb` 中的 `Part1-main` 部分
       - `Part1-Forest.Rmd`

   - **Part 2 - Multistate**
     - 生成用于第二部分分析的数据文件
     - 该文件用于 `Part2-multistate.Rmd`，以生成第二部分分析结果
     - 结果保存在对应结果文件夹中
     - 正文图表绘制：
       - `FigurePlot.ipynb` 中 `Part2-Main` 部分的 `pmatrix` 和 `totlos`

   - **Part 3 - Survival**
     - 生成 `File/Part Data/part3-main.parquet`
     - 进一步通过 `Part3-Outcomes.Rmd` 生成结果
     - 结果保存至 `File/Result/Part3/main/Part3-main.xlsx`
     - 图表绘制：
       - `KM` 生存曲线已在 `Part3-Survival` 中完成绘制
       - 正文其他图表通过 `Part3-Forest.R` 绘制

## 敏感性分析部分

敏感性分析代码的整体逻辑、文件组织方式及结果存储路径与主分析部分基本一致。具体请参考相应代码中的文件读取与保存位置说明。

## 注意事项

由于原始数据涉及敏感信息，本仓库不提供原始数据，仅提供代码及部分结果文件，供交流与学习使用。