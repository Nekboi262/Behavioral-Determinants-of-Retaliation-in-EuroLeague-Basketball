# Behavioral Determinants of Retaliation in EuroLeague Basketball

## Overview

This project investigates retaliatory behavior in professional basketball using player-level EuroLeague data from the 2016–17 to 2024–25 seasons.

The analysis examines whether players commit more fouls after being fouled and whether this relationship is influenced by behavioral and cultural characteristics, particularly **patience** and **negative reciprocity**.

The project was developed as part of my MSc dissertation in **Business Economics with Analytics** at the Athens University of Economics and Business (AUEB).

## Research Questions

The analysis focuses on three main questions:

- Do players commit more fouls when they receive more fouls?
- Does negative reciprocity strengthen this retaliatory response?
- Does patience reduce the tendency to retaliate?

The analysis also investigates whether EuroLeague experience influences retaliatory behavior.

## Data

The project combines two main sources of data:

### EuroLeague Data

Player-level basketball statistics covering the EuroLeague seasons from **2016–17 to 2024–25**, including variables such as:

- Fouls committed
- Fouls received
- Minutes played
- Steals
- Turnovers
- Field goals
- Free throws
- Player age
- Player height
- EuroLeague experience

### Behavioral and Cultural Data

Country-level behavioral measures were merged with player data using nationality.

The main behavioral variables used in the analysis are:

- **Patience** — willingness to delay immediate rewards in favor of future benefits.
- **Negative Reciprocity** — willingness to respond negatively to perceived unfair or hostile behavior.
- **Risk-Taking** — willingness to take risks.

> Raw datasets are not included in this repository. See `data/README.md` for additional information.

## Methodology

The empirical analysis was conducted in **R**.

The project uses:

- Data cleaning and transformation
- Dataset merging
- Ordinary Least Squares (OLS) regression
- Heteroskedasticity-robust standard errors
- Interaction effects
- Marginal-effect analysis
- Predictive visualizations

Nine regression specifications were estimated to investigate different behavioral mechanisms.

A central specification examines:

```text
Fouls Committed ~ Fouls Received × Patience
```

while other models examine interactions involving negative reciprocity and player experience.

## Key Findings

The analysis provides evidence of a relationship between being fouled and subsequent fouling behavior.

### Retaliatory Behavior

Players who receive more fouls tend to commit more fouls themselves, consistent with a retaliatory response.

### Negative Reciprocity

Negative reciprocity strengthens the relationship between fouls received and fouls committed in some specifications, suggesting that behavioral norms may influence how players respond to physical provocation.

### Patience

Patience emerges as the more consistent moderator of retaliatory behavior.

Players associated with higher levels of patience show a weaker increase in fouling behavior after receiving fouls.

### Experience

Veteran players display a weaker retaliatory response than less experienced players.

However, the three-way interaction between fouls received, patience, and experience is not statistically significant, suggesting that experience primarily reduces baseline reactivity rather than fundamentally changing the moderating effect of patience.

## Visualizations

The analysis includes interaction and prediction plots illustrating the main behavioral mechanisms.

Key visualizations include:

- Fouls Received × Negative Reciprocity
- Fouls Received × Patience
- Retaliation by EuroLeague Experience
- Player-level predicted vs. actual retaliation profiles

Selected figures are available in the `figures/` directory.

## Repository Structure

```text
euroleague-retaliation-analysis/
│
├── README.md
├── .gitignore
│
├── R/
│   ├── 00_packages.R
│   ├── 01_data_preparation.R
│   ├── 02_regression_models.R
│   └── 03_visualizations.R
│
├── data/
│   └── README.md
│
├── figures/
│
└── results/
```

### R Scripts

**`00_packages.R`**  
Loads the R packages required for the analysis.

**`01_data_preparation.R`**  
Cleans and merges the EuroLeague and behavioral datasets and constructs variables used in the analysis.

**`02_regression_models.R`**  
Contains the nine OLS regression specifications and robust inference.

**`03_visualizations.R`**  
Produces the interaction and prediction plots used to interpret the regression results.

## Tools & Technologies

- **R**
- **dplyr** — data manipulation
- **ggplot2** — data visualization
- **euroleaguer** — EuroLeague data
- **haven** — Stata data import
- **countrycode** — country-code standardization
- **sandwich** — robust covariance estimation
- **lmtest** — robust statistical inference
- **effects** — marginal-effect estimation
- **modelsummary** — regression output

## How to Run

Run the scripts in the following order:

```r
source("R/00_packages.R")
source("R/01_data_preparation.R")
source("R/02_regression_models.R")
source("R/03_visualizations.R")
```

The required datasets should first be placed in the `data/` directory.

## Author

**Nektarios Papoutsis**

MSc Business Economics with Analytics  
Athens University of Economics and Business
