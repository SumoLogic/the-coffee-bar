import psycopg2
import logging as log


class Storage:
    TABLES = {
        'account': 'account',
    }

    DB_NAME = 'account'

    connection = None

    def __init__(self, connection_string: str):
        self.connection_string = connection_string

    def connect(self):
        try:
            self.connection = psycopg2.connect(self.connection_string)
        except psycopg2.DatabaseError as ex:
            self.connection = None
            log.error(ex)
        finally:
            return self.connection

    def close(self):
        try:
            if self.connection:
                self.connection.close()
        except Exception as ex:
            log.error(ex)

    def execute(self, query: str, data: tuple):
        if self.connect():
            try:
                cur = self.connection.cursor()
                cur.execute(query, vars=data)
                self.connection.commit()
                cur.close()
            except (Exception, psycopg2.DatabaseError) as ex:
                log.error(ex)
            finally:
                self.close()

    def execute_select(self, query: str) -> dict:
        result = None

        if self.connect():
            try:
                cursor = self.connection.cursor()
                cursor.execute(query)
                data = cursor.fetchall()

                col_names = []
                for desc in cursor.description:
                    col_names.append(desc[0])

                result = []
                for row in data:
                    row_data = {}
                    for n in range(0, len(col_names)):
                        row_data.update({col_names[n]: row[n]})
                    result.append(row_data)

            except (Exception, psycopg2.DatabaseError) as ex:
                log.error(ex)
            finally:
                self.close()

        return result

    def update_items(self, data: tuple):
        log.info('Update amount of items sold. Number: {} Product: {}'.format(data[0], data[1]))
        query = f'UPDATE {self.TABLES["account"]} SET items_sold = %s WHERE product = %s'
        return self.execute(query=query, data=data)

    def get_all_data(self):
        query = f'SELECT * FROM {self.TABLES["account"]}'
        return self.execute_select(query=query)

    def get_items_sold(self, product_name: str):
        log.info('Query DB for items sold of product: %s', product_name)
        query = f'SELECT product, items_sold FROM {self.TABLES["account"]} WHERE product = \'{product_name}\''
        return self.execute_select(query=query)[0]

    def get_price_of_product(self, product_name: str):
        log.info('Query DB for price of product: %s', product_name)
        query = f'SELECT product, price FROM {self.TABLES["account"]} WHERE product = \'{product_name}\''
        return self.execute_select(query=query)[0]
