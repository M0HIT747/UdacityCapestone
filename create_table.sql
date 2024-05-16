CREATE TABLE IF NOT EXISTS city_code(
    code VARCHAR PRIMARY KEY,
    city VARCHAR
);

CREATE TABLE IF NOT EXISTS country_code(
    code VARCHAR PRIMARY KEY,
    country VARCHAR
);


CREATE TABLE IF NOT EXISTS state_code(
    code VARCHAR PRIMARY KEY,
    state VARCHAR
);

CREATE TABLE IF NOT EXISTS visa_code(
    code VARCHAR PRIMARY KEY,
    type VARCHAR
);

CREATE TABLE IF NOT EXISTS dim_temperature(
    dt DATE,
    avg_temp DOUBLE PRECISION,
    avg_temp_uncertnty DOUBLE PRECISION,
    code VARCHAR,
    country VARCHAR,
    PRIMARY KEY(dt, code)
);

CREATE TABLE IF NOT EXISTS dim_state_population(
    State_Code VARCHAR PRIMARY KEY,
    male_population BIGINT,
    female_population BIGINT,
    num_vetarans BIGINT,
    foreign_born BIGINT,
    total_population BIGINT,
    AvgHouseholdSize DOUBLE PRECISION,
    Median_Age DOUBLE PRECISION
);

CREATE TABLE IF NOT EXISTS dim_city_population(
    city VARCHAR PRIMARY KEY, 
    State_Code VARCHAR REFERENCES dim_state_population(State_Code),
    male_population BIGINT,
    female_population BIGINT,
    num_vetarans BIGINT,
    foreign_born BIGINT,
    total_population BIGINT,
    AvgHouseholdSize DOUBLE PRECISION,
    Median_Age DOUBLE PRECISION
);


CREATE TABLE IF NOT EXISTS fact_immigration(
    cic_id INT PRIMARY KEY,
    year INT,
    month INT,
    city_code VARCHAR REFERENCES city_code(code),
    state_code VARCHAR REFERENCES dim_state_population(State_Code),
    arrive_date DATE,
    departure_date DATE,
    visa_code VARCHAR REFERENCES visa_code(code),
    visatype VARCHAR,
    citizen_country VARCHAR REFERENCES country_code(code),
    birth_year INT,
    gender VARCHAR,
    airline VARCHAR,
    admitnum BIGINT,
    country_immigrated_to VARCHAR,
    CONSTRAINT tempref FOREIGN KEY(arrive_date, state_code) REFERENCES dim_temperature(dt, code)
);


