### NOTE: THIS REPOSITORY DOES NOT CONTAIN THE ORIGINAL RESEARCH DATA BECAUSE OF DATA-SENSITIVITY AND PRIVACY RESTRICTIONS. A DEMONSTRATION FILE, `hpconcat_demo.parquet`, IS PROVIDED FOR TESTING AND WORKFLOW ILLUSTRATION ONLY. BEFORE RUNNING THE CODE, PLEASE MODIFY ALL INPUT AND OUTPUT PATHS ACCORDING TO YOUR LOCAL FILE STRUCTURE.

# Health-Inequality-in-Hypertension

`Health-Inequality-in-Hypertension` contains the R and Python scripts used for data integration, data cleaning, cost analysis, multistate modelling, survival analysis, sensitivity analysis, and figure generation for the associated manuscript.

- [Overview](#overview)
- [Repository Structure](#repository-structure)
- [System Requirements](#system-requirements)
- [Installation Guide](#installation-guide)
- [Python Environment Setup](#python-environment-setup)
- [Workflow](#workflow)
- [Main Analyses](#main-analyses)
- [Sensitivity Analyses](#sensitivity-analyses)
- [Reproducibility Note](#reproducibility-note)
- [Data Availability](#data-availability)
- [Citation](#citation)
- [Contact](#contact)
- [License](#license)

# Overview

This repository provides the analytical code used in a study of health inequality in hypertension. The workflow covers the complete analysis pipeline, including data integration, creation of analysis-ready datasets, cost analysis, multistate disease progression analysis, survival analysis, sensitivity analyses, and figure generation for the manuscript.

The codebase is written in **Python**, **R Markdown**, and **R**, and is organized according to the major analytical components of the study.

# Repository Structure

The main workflow is based on the following notebooks and scripts:

- `integrate data.ipynb`  
  Integrates the source data and generates the combined dataset.

- `create data.ipynb`  
  Creates analysis-specific datasets for the main analyses.

- `Part1-Cost.Rmd`  
  Performs the main cost analysis.

- `Part2-multistate.Rmd`  
  Performs the multistate disease progression analysis.

- `Part3-Outcomes.Rmd`  
  Performs the main survival analysis.

- `Part3-Survival`  
  Generates Kaplan–Meier survival curves and related survival outputs.

- `FigurePlot.ipynb`  
  Generates figures for the main analyses.

- `Part1-Forest.Rmd`  
  Generates forest plots for Part 1.

- `Part3-Forest.R`  
  Generates forest plots and additional figures for Part 3.

# System Requirements

## Hardware requirements

This repository requires only a standard computer with sufficient RAM to support in-memory data processing.

## Software requirements

The workflow includes both **Python** and **R** components.

### Required software

- Python
- Jupyter Notebook or JupyterLab
- R
- RStudio or another environment capable of running `.Rmd` and `.R` files

### Typical dependencies

The specific package requirements may vary slightly across scripts, but the workflow mainly relies on common data-science and statistical packages in Python and R.

#### Python packages commonly used

```text
pandas
numpy
tqdm
matplotlib
lifelines
