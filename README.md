# Behavioral Determinants of Retaliation in EuroLeague Basketball

## Overview

This repository contains the R code used for the MSc dissertation:

**Behavioral Determinants of Retaliation: Evidence from Fouling Behavior in European Professional Basketball**

The project investigates whether EuroLeague players commit more fouls after receiving fouls and whether this relationship is moderated by behavioral traits, particularly **patience** and **negative reciprocity**.

## Data

The analysis combines:

- EuroLeague player/game statistics
- QJE behavioral/cultural indicators for patience and negative reciprocity
- Player characteristics such as age and height

The analysis covers EuroLeague seasons from **2016-17 to 2024-25**.

Raw datasets are not included in this repository unless their redistribution is permitted. See `data/README.md` for information on expected inputs.

## Methodology

The dissertation estimates linear regression models using OLS. Robust and cluster-robust standard errors were also considered as a robustness check.

The main empirical analysis consists of Models 1–9:

1. Patience and free-throw efficiency
2. Negative reciprocity × steals and fouls committed
3. Risk-taking and fouls committed
4. Patience and fouls received
5. Fouls received × negative reciprocity and fouls committed
6. Fouls received × negative reciprocity × patience
7. Fouls received × patience
8. Fouls received × patience and negative reciprocity
9. Fouls received × patience × age

An additional experience-group specification distinguishes veteran players (6+ EuroLeague seasons) from non-veterans (≤5 seasons).

## Main Findings

The dissertation finds evidence consistent with retaliatory fouling behavior.

- Patience is positively associated with free-throw efficiency.
- Negative reciprocity strengthens the relationship between steals and fouls committed.
- Risk-taking has a relatively small and statistically insignificant relationship with fouls committed.
- Patience is negatively associated with fouls received.
- The interaction between fouls received and negative reciprocity is positive and statistically significant.
- Patience appears to be a stronger and more consistent moderator of retaliatory behavior.
- The three-way interactions provide limited evidence for a statistically significant combined moderation effect.

## Repository Structure

```text
euroleague-retaliation-analysis/
├── README.md
├── R/
│   ├── 00_packages.R
│   ├── 01_data_preparation.R
│   ├── 02_descriptive_analysis.R
│   ├── 03_regression_models.R
│   └── 04_visualizations.R
├── data/
│   └── README.md
├── figures/
├── results/
└── dissertation/
    └── dissertation.pdf
```

## Reproducibility

Run the scripts in the following order:

```text
00_packages.R
01_data_preparation.R
02_descriptive_analysis.R
03_regression_models.R
04_visualizations.R
```

## Tools

- R
- EuroLeague data via `euroleaguer`
- OLS regression
- Robust / cluster-robust standard errors
- Data cleaning and transformation
- Statistical visualization
- Marginal-effect visualization

## Author

Nektarios Papoutsis  
MSc in Business Economics with Analytics  
Athens University of Economics and Business
