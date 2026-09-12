# EPA U.S. Facility Emission Analytics & Predictive Dashboard

Welcome to the EPA Facility Emissions Analytics & Prediction project. This repository contains an end-to-end data analytics and engineering solution designed to process, analyze, and forecast greenhouse gas emissions across U.S. industrial facilities.

The project bridges historical recorded data (2010–2017) with Machine Learning predictions (2018–2020), offering a complete lifecycle view from raw data cleaning to executive-level visualization.

## Project Overview & Architecture

To solve the challenge of analyzing large-scale environmental datasets, I built a modular analytics pipeline divided into four main layers:

1. ETL & Data Cleaning: Built an automated Power Query pipeline to handle schema alignment, address normalization, missing values, and custom feature engineering.
2. Relational Database & SQL Modeling: Designed a Star Schema data warehouse architecture to optimize querying performance, establishing clear Fact and Dimension tables.
3. Machine Learning Integration: Incorporated predictive model results to forecast aggregate facility emission trends for 2018 through 2020.
4. Interactive Executive Dashboards: Designed a high-density, executive dashboard in Excel and Power BI featuring dynamic slicers, KPI tracking, and custom green-themed UI styling.

## Repository Structure
`text
├── Raw-data/                                # Original raw EPA datasets
├── Carbon_Emissions_Analytics_&_Sustainable_Fin.pptx  # Project presentation slides
├── Carbon_Emissions_SQL_Project.sql         # SQL schema setup & analytics queries
├── Machine learning                        # ML notebook & model script files
├── cleaned-emissions-data.xlsx             # Cleaned dataset (Post Power Query)
├── cleaning python.py                       # Python scripts for initial exploratory analysis
├── dashboarddddd.png                        # High-resolution dashboard preview
├── final-dashboard.png                      # Final executive UI screenshot
├── predicted_emissions_2018_2020.csv        # ML forecasted output dataset
└── schema.png                               # Star Schema data model diagram
