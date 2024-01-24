import mysql.connector


class DBConnection(object):
    """
    DBConnection class to interact with a mysql db.
    """

    def __init__(self, host, database, user, password):
        self.host = host
        self.database = database
        self.user = user
        self.password = password
        self.conn = None

    def connect(self):
        """
        create db connection
        """
        try:
            conn = self.conn = mysql.connector.connect(
                user=self.user,
                password=self.password,
                host=self.host,
                # database=self.database,
                port=3306,
                auth_plugin="mysql_native_password",
            )
            print("db connection established")
            return conn
        except Exception as e:
            print(f"Error: {e}")
            raise e

    def close(self):
        """
        close db connection
        """
        if self.conn is not None:
            self.conn.close()
            print("db connection closed")
        else:
            print("no db connection to close")

    def __getResults(self, cursor):
        """
        internal method to get results from a cursor.
        """
        results = cursor.fetchall()
        return results

    def execute(self, query):
        """
        Execute a single db query.
        Closes cursor after query is executed.
        Does not close db connection.
        """
        print(f"executing query: {query}")
        try:
            cursor = self.conn.cursor()
            cursor.execute(query)
            rows = self.__getResults(cursor)
            return rows
        except Exception as e:
            print(f"Error: {e}")
            raise e
        finally:
            cursor.close()
            print("cursor closed")
