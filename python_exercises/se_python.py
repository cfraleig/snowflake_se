import pandas
import os
from snowflake.snowpark import Session




def get_snowpark_session():
    connection_parameters = {
    "account": os.getenv("ACCOUNTNAME"),
    "user": os.getenv("USERNAME"),
    "password": os.getenv("PASSWORD"),
    "warehouse": os.getenv("WH__SE_EVAL__L") , # optional
    "database": os.getenv("DBNAME"),  # optional
    "schema": "python_problems",  # optional
    } 
    
    session = Session.builder.configs(connection_parameters).create()
    
    return session

def get_dataframe(filepath="data/global-summary-of-the-month-2022-04-19T17-15-42.csv"):  
    frame = pandas.read_csv(filepath)
    return frame

def write_table(dataframe,session):
    table_name = 'weather_data'
    try:
        session.write_pandas(dataframe, table_name,auto_create_table=True,overwrite=True)
    except Exception as e:
        raise Exception(f"failed to load table with error {e}")

if __name__ == "__main__":
    dataframe = get_dataframe()
    session = get_snowpark_session()
    write_table(dataframe,session)