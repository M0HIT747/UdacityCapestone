# Udacity Data Engineer Nanodegree - Capstone Project

## Project summary - 
    In this project we are building a data warehouse which will integrate the data from 3 datasets, the immigration dataset, global temperature dataset and the us demography dataset. By the final modelled data we can aim find out the visa related information of a person, by which airline he came and if he departed on a particular date or not and how was the wheather on his visit day. Also we can find out which state is most favoured by the immigrants for visiting and what was the population of that state by sex, foreign born and veteran, also in which month or year was the rate of immigration highest.
    
    Steps involved in the process- 
    Step 1:- Scope the Project and Gather Data
    Step 2:- Explore and Assess the Data
    Step 3:- Define the Data Model
    Step 4:- Run ETL to Model the Data
    Step 5:- Future design consideration
    
### Step 1:- Scope the project and gather data**
#### Scope - 
        This project will integrate the immigration data, global temperature data and US demographic data to setup a data warehouse with fact and dimensions tables. We will use AWS redshift as data warehouse and we will model our data according to star schema.
        
#### Datasets involved - 
    1. I94 immigration dataset - This data comes from the US National Tourism and Trade Office. The National Travel and Tourism Office (NTTO) works cooperatively with the U.S. Department of Homeland Security (DHS)/U.S. Customs and Border Protection (CBP) to release I-94 Visitor Arrivals Program data, providing a comprehensive count of all visitors (overseas all travel modes plus Mexico air and sea) entering the United States. The dataset can be found on the following link - https://www.trade.gov/travel-and-tourism-research
    Dataset Format - SAS7BDAT
    Number of records - 3096313

    2. Global temperature dataset - The following dataset is availiable on Kaggle and is repackaged from a compilation put together by the Berkeley Earth, which is affiliated with Lawrence Berkeley National Laboratory. The Berkeley Earth Surface Temperature Study combines 1.6 billion temperature reports from 16 pre-existing archives.
    Link to dataset - https://www.kaggle.com/datasets/berkeleyearth/climate-change-earth-surface-temperature-data
    Data format - CSV
    Number of records - 645675

    3. U.S. City Demographic Data - This dataset contains information about the demographics of all US cities and census-designated places with a population greater or equal to 65,000. 
    This data comes from the US Census Bureau's 2015 American Community Survey.
    Link to dataset - https://public.opendatasoft.com/explore/dataset/us-cities-demographics/export/
    Data format - CSV
    Number of records - 2891

    4. Label dataset - At last we have a file "I94_SAS_Labels_Descriptions.SAS" which contains the state code, country code and city code.

#### Tools used - 
1. Python - Python is a high-level, general-purpose programming language. 
2. AWS S3 - Amazon Simple Storage Service (Amazon S3) is an object storage service offering industry-leading scalability, data availability, security, and performance. We have used this to store the dataset in  parquet files.
3. AWS redshift - Amazon Redshift is a data warehouse product which forms part of the larger cloud-computing platform Amazon Web Services. It is built on top of technology from the massive parallel processing data warehouse company ParAccel, to handle large scale data sets and database migrations. We will use this to store the tables.
4. AWS EMR - Amazon Elastic Map Reduce is a web service that you can use to process large amounts of data efficiently. Amazon EMR uses Hadoop processing combined with several AWS products to do such tasks as web indexing, data mining, log file analysis, machine learning, scientific simulation, and data warehousing.

### Step 2:- Explore and Assess the Data
During EDA we found the following issues - 
1. I94 immigration dataset - 
    1. The arrival date and departure date format should be corrected
    2. Drop records which have airline and i94addr as null
    3. The residence country and citizen country are double, convert it to string 

2. U.S. City Demographic Data -
    1. Tranform city, state in dimension table to upper case to match city_code and state_code table

3. Label dataset - 
    1. The key value pairs of city, state and country with their code will have to be extracted.
    
4. Temperature dataset - 
    Steps to be perfromed - 
    1. Filter out country by USA
    2. Convert timestamp to date
    3. Replace state full names with state codes

### Step 3 - Define data model
The data model and data dictionary is present in the excel sheet, name of sheet - model.xlsx
For this project we will be using star schema, we are using the fact table and dimension tables as below -
Fact table - fact_immigration
Dimension tables -  dim_city_population, dim_state_population, country_code, state_code, city_code, visa_code, dim_temperature
The reason we chose star schema is because it is simple to design and it is easy to derieve business insight from this model.

Description of our data model - 

Fact_immigration is our fact table, it has the actual immigration records. The fact table has fields city_code, state_code, country_code and visa_code which server as a reference to the city_code, state_code, country_code and visa_code tables. For connectivity between the demography dataset we had to first group the demography dataset by state and then aggregate the parameters. Later the state_code of the fact_immigration table referenced to the state_code of the dim_state_population table. Now to retreive the city level data would not have been possible as our label dataset did not had all the cities of the demography table so we have referenced the dim_city_population table to dim_state_population by state_code. The temperature dataset dimension(dim_temperature) was at the state level so we used a composite primary key(dt,code) was used and the fact_immigration table referenced to it by arrive_date and state_code.

### Step 4 - Steps involved in ETL

Note - Make sure you have populated the credentials in the config file present in the aws folder, also make sure the tables are create on the redshift cluster by running the create_table.sql script.

1. Assume all data is stored in S3 bucket as below - 
    - s3://bucket/Data/18-83510-I94-Data-2016/i94_apr16_sub.sas7bdat
    - s3://bucket/Data/I94_SAS_Labels_Descriptions.SAS
    - s3://bucket/Data/GlobalLandTemperaturesByCity.csv
    - s3://bucket/Data/us-cities-demographics.csv
2. Read the files from the s3 bucket into the EMR cluster
3. Perform data cleaning
4. Create dataframes with required columns
5. Write tables in parquet format to destination S3 bucket
6. Read parquet data and perform data quality checks
7. Load the data to redshift cluster

### Step 5 - Future design consideration
1. A data pipeline with airflow can be setup to automatically read, process and load the data from s3 to redshift, the pipeline can be either triggerred manually or be scheduled at a specific time.

### Project Write Up
#### Clearly state the rationale for the choice of tools and technologies for the project.
    1. Python - Python is a high-level, general-purpose programming language. It has manay useful packages namely pandas, pyspark which we have used in this project to process the data.
    2. AWS S3 - Amazon Simple Storage Service (Amazon S3) is an object storage service offering industry-leading scalability, data availability, security, and performance. We have used this to store the dataset in  parquet files.
    3. AWS redshift - Amazon Redshift is a data warehouse product which forms part of the larger cloud-computing platform Amazon Web Services. It is built on top of technology from the massive parallel processing data warehouse company ParAccel, to handle large scale data sets and database migrations. We will use this to store the tables.
    4. AWS EMR - Amazon Elastic Map Reduce is a web service that you can use to process large amounts of data efficiently. Amazon EMR uses Hadoop processing combined with several AWS products to do such tasks as web indexing, data mining, log file analysis, machine learning, scientific simulation, and data warehousing.

#### Sample sql query result - Fetch demographic data of top 5 states which had maximum immigration
The sql query and output of the query is shown in the sqlqueryoutput.png

#### Propose how often the data should be updated and why.
    - The fact and dimension table of immigration dataset should be updated every month, temperature dataset can be updated on biweekly or monthly while the demography data should be updated once per year as it will take time to gather the data.
    

#### Write a description of how you would approach the problem differently under the following scenarios:
##### The data was increased by 100x.
    - The use of Redshift perfectly handles this situation in case of data warehousing, for processing the large amount  data the EMR cluster can be used.
##### The data populates a dashboard that must be updated on a daily basis by 7am every day.
    - The data pipeline solution like apache airflow can we used to schedule the run before 7am everyday.
##### The database needed to be accessed by 100+ people.
    - The default value for mximum number of connections handled by redshift is 500, so use of redshift handles this requirement

