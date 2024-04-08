import polars as pl
from snowflake.snowpark import Session

# Step 1: Connect to Snowflake
connection_parameters = {
    "account": "<your_account_name>",
    "user": "<your_username>",
    "password": "<your_password>",
    "role": "<your_role>",
    "warehouse": "<your_warehouse>",
    "database": "<your_database>",
    "schema": "<your_schema>"
}
session = Session.builder.configs(connection_parameters).create()

# Step 2: Prepare your Polars DataFrame
# Assuming you have a Polars DataFrame named `df`
# For example:
# df = pl.DataFrame({
#     'column1': [1, 2, 3],
#     'column2': ['a', 'b', 'c'],
#     'column3': [True, False, True]
# })

# Step 3: Load the DataFrame into the Snowflake Table
table_name = "se_eval.python_problems.sf_weather_data"
session.write_pandas(df.to_pandas(), table_name)
