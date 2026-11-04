import os
import mysql.connector

# Railway's MySQL service provides these variables; locally set MYSQLPASSWORD once with: setx MYSQLPASSWORD <your password>
def get_connection():
    return mysql.connector.connect(
        host=os.environ.get("MYSQLHOST", "localhost"),
        port=int(os.environ.get("MYSQLPORT", 3306)),
        user=os.environ.get("MYSQLUSER", "root"),
        password=os.environ["MYSQLPASSWORD"],
        database="job_board"
    )
