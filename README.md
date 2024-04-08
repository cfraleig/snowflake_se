# snowflake_se

## For the Python Exercise
- Add your snowflake creds to the local_env.env file
- Run `make build` to build the local image
- Run `make up` to run the container from the built image
- Run `make shell` to shell into the running container
- Run `python python_exercises/se_python.py` to execute the python script and load the table `weather_data`

## For SQL Exercise
The sql files are all in the `sql_exercises` directory, labled by parts 1-3, comments in the sql indicate which question 
they represent. The code can be copied into the snowflake console to run, or run using the snowflake plugin for vscode (thats what I used) 
