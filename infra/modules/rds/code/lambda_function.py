import os
import pymysql

DB_USERNAME = os.environ["DB_USERNAME"]
DB_PASS=os.environ["DB_PASS"]
DB_PORT=os.environ["DB_PORT"]
DB_HOST=os.environ["DB_HOST"]
DB_NAME=os.environ["DB_NAME"]
def lambda_handler(event, context):

    mydb = pymysql.connect(
            host=DB_HOST,
            user=DB_USERNAME,
            password=DB_PASS
            )
    mycursor=mydb.cursor()
    use_db_query=f"USE {DB_NAME}"
    create_tables_query="CREATE TABLE Employee ( id int unsigned auto_increment not null, first_name varchar(250), last_name varchar(250), email varchar(250), username varchar(250), password varchar(250), regdate timestamp, primary key (id) )"
    with mydb.cursor() as mycursor:
        mycursor.execute(use_db_query)
        mycursor.execute(create_tables_query)