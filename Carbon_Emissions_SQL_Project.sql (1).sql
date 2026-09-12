SELECT COUNT(*) AS total_rows
FROM apc;
SHOW COLUMNS FROM apc;
SELECT *
FROM apc
LIMIT 10;
ALTER TABLE apc
RENAME COLUMN `ï»¿year` TO year;
SHOW COLUMNS FROM apc;
SELECT DISTINCT year
FROM apc
ORDER BY year;
SELECT 
    year,
    SUM(total_direct_emissions) AS total_emissions
FROM apc
GROUP BY year
ORDER BY year;
SELECT 
    industry_sector,
    SUM(total_direct_emissions) AS total_emissions
FROM apc
GROUP BY industry_sector
ORDER BY total_emissions DESC
LIMIT 10;
SELECT 
    state,
    SUM(total_direct_emissions) AS total_emissions
FROM apc
GROUP BY state
ORDER BY total_emissions DESC
LIMIT 10;
SELECT 
    facility_name,
    state,
    industry_sector,
    SUM(total_direct_emissions) AS total_emissions
FROM apc
GROUP BY facility_name, state, industry_sector
ORDER BY total_emissions DESC
LIMIT 10;
SELECT 
    dominant_gas,
    COUNT(*) AS records,
    SUM(total_direct_emissions) AS total_emissions
FROM apc
GROUP BY dominant_gas
ORDER BY total_emissions DESC;
SELECT
    SUM(CO2_emissions) AS total_CO2,
    SUM(CH4_emissions) AS total_CH4,
    SUM(N2O_emissions) AS total_N2O
FROM apc;
WITH yearly AS (
    SELECT 
        year,
        SUM(total_direct_emissions) AS total_emissions
    FROM apc
    GROUP BY year
)
SELECT
    year,
    total_emissions,
    LAG(total_emissions) OVER (ORDER BY year) AS previous_year,
    ROUND(
        (total_emissions - LAG(total_emissions) OVER (ORDER BY year))
        / LAG(total_emissions) OVER (ORDER BY year) * 100,
        2
    ) AS growth_pct
FROM yearly
ORDER BY year;
SELECT
    emission_category,
    COUNT(*) AS records,
    SUM(total_direct_emissions) AS total_emissions
FROM apc
GROUP BY emission_category
ORDER BY total_emissions DESC;
SELECT
    AVG(total_direct_emissions) AS average_emissions
FROM apc;
SELECT
    facility_name,
    state,
    industry_sector,
    year,
    total_direct_emissions
FROM apc
ORDER BY total_direct_emissions DESC
LIMIT 10;
SELECT
    year,
    industry_sector,
    SUM(total_direct_emissions) AS total_emissions
FROM apc
GROUP BY year, industry_sector
ORDER BY year, total_emissions DESC;
SELECT
    state,
    COUNT(DISTINCT facility_name) AS facility_count,
    SUM(total_direct_emissions) AS total_emissions
FROM apc
GROUP BY state
ORDER BY total_emissions DESC
LIMIT 10;
SELECT
    industry_sector,
    SUM(CO2_emissions) AS total_CO2,
    SUM(total_direct_emissions) AS total_emissions,
    ROUND(
        SUM(CO2_emissions) / SUM(total_direct_emissions) * 100,
        2
    ) AS CO2_share_pct
FROM apc
GROUP BY industry_sector
ORDER BY CO2_share_pct DESC;
ALTER TABLE apc
ADD COLUMN emission_id INT AUTO_INCREMENT PRIMARY KEY FIRST;
WITH industry_year AS (
    SELECT
        industry_sector,
        year,
        SUM(total_direct_emissions) AS total_emissions
    FROM apc
    GROUP BY industry_sector, year
),
ranked AS (
    SELECT
        industry_sector,
        year,
        total_emissions,
        RANK() OVER (
            PARTITION BY industry_sector
            ORDER BY total_emissions DESC
        ) AS ranking
    FROM industry_year
)
SELECT
    industry_sector,
    year,
    total_emissions
FROM ranked
WHERE ranking = 1
ORDER BY total_emissions DESC;
SELECT
    industry_sector,
    SUM(total_direct_emissions) AS total_emissions,
    ROUND(
        SUM(total_direct_emissions) /
        (SELECT SUM(total_direct_emissions) FROM apc) * 100,
        2
    ) AS percentage_of_total
FROM apc
GROUP BY industry_sector
ORDER BY percentage_of_total DESC;
SELECT
    COUNT(*) AS total_records,
    SUM(CASE WHEN total_direct_emissions IS NULL THEN 1 ELSE 0 END) AS null_emissions,
    SUM(CASE WHEN total_direct_emissions < 0 THEN 1 ELSE 0 END) AS negative_emissions,
    SUM(CASE WHEN total_direct_emissions = 0 THEN 1 ELSE 0 END) AS zero_emissions
FROM apc;
SELECT
    MIN(CASE WHEN year = 2010 THEN total_emissions END) AS emissions_2010,
    MAX(CASE WHEN year = 2017 THEN total_emissions END) AS emissions_2017,
    ROUND(
        (
            MAX(CASE WHEN year = 2017 THEN total_emissions END)
            -
            MIN(CASE WHEN year = 2010 THEN total_emissions END)
        )
        /
        MIN(CASE WHEN year = 2010 THEN total_emissions END) * 100,
        2
    ) AS change_percentage
FROM (
    SELECT
        year,
        SUM(total_direct_emissions) AS total_emissions
    FROM apc
    GROUP BY year
) yearly;
WITH ranked AS (
    SELECT
        year,
        facility_name,
        state,
        industry_sector,
        total_direct_emissions,
        RANK() OVER (
            PARTITION BY year
            ORDER BY total_direct_emissions DESC
        ) AS ranking
    FROM apc
)
SELECT
    year,
    facility_name,
    state,
    industry_sector,
    total_direct_emissions
FROM ranked
WHERE ranking = 1
ORDER BY year;
SELECT
    industry_sector,
    COUNT(*) AS records,
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM apc),
        2
    ) AS record_percentage
FROM apc
GROUP BY industry_sector
ORDER BY records DESC;
SELECT
    year,
    COUNT(DISTINCT facility_name) AS facilities,
    SUM(total_direct_emissions) AS total_emissions,
    ROUND(AVG(total_direct_emissions), 2) AS average_emissions
FROM apc
GROUP BY year
ORDER BY year;
CREATE OR REPLACE VIEW vw_yearly_emissions AS
SELECT
    year,
    COUNT(DISTINCT facility_name) AS facilities,
    SUM(total_direct_emissions) AS total_emissions,
    ROUND(AVG(total_direct_emissions), 2) AS average_emissions
FROM apc
GROUP BY year
ORDER BY year;
CREATE OR REPLACE VIEW vw_industry_emissions AS
SELECT
    industry_sector,
    COUNT(*) AS records,
    COUNT(DISTINCT facility_name) AS facilities,
    SUM(total_direct_emissions) AS total_emissions,
    ROUND(
        SUM(total_direct_emissions) /
        (SELECT SUM(total_direct_emissions) FROM apc) * 100,
        2
    ) AS percentage_of_total
FROM apc
GROUP BY industry_sector
ORDER BY total_emissions DESC;
CREATE OR REPLACE VIEW vw_state_emissions AS
SELECT
    state,
    COUNT(DISTINCT facility_name) AS facilities,
    SUM(total_direct_emissions) AS total_emissions
FROM apc
GROUP BY state
ORDER BY total_emissions DESC;
CREATE OR REPLACE VIEW vw_gas_emissions AS
SELECT
    SUM(CO2_emissions) AS total_CO2,
    SUM(CH4_emissions) AS total_CH4,
    SUM(N2O_emissions) AS total_N2O
FROM apc;
SELECT * FROM vw_yearly_emissions;

SELECT * FROM vw_industry_emissions LIMIT 10;

SELECT * FROM vw_state_emissions LIMIT 10;

SELECT * FROM vw_gas_emissions;
SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT facility_name) AS total_facilities,
    COUNT(DISTINCT state) AS total_states,
    COUNT(DISTINCT industry_sector) AS total_industries,
    SUM(total_direct_emissions) AS total_emissions,
    ROUND(AVG(total_direct_emissions), 2) AS average_emissions
FROM apc;
SELECT
    facility_name,
    state,
    industry_sector,
    year,
    total_direct_emissions,
    CO2_emissions,
    CH4_emissions,
    N2O_emissions,
    emission_category,
    dominant_gas
FROM apc
ORDER BY total_direct_emissions DESC
LIMIT 10;