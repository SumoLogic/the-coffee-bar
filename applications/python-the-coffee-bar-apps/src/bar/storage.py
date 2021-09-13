from typing import Tuple, Optional, Any, List

import psycopg2
import logging as log
import statsd


class Storage:
    TABLES = {
        'account': 'account',
    }

    DB_NAME = 'account'

    connection = None

    def __init__(self, connection_string: str, stats: statsd.StatsClient):
        self.connection_string = connection_string
        self.stats = stats
        if self.stats:
            self.stats.gauge('current_connections', 0)

    def connect(self):
        try:
            self.connection = psycopg2.connect(self.connection_string)
            if self.stats:
                self.stats.incr('postgres_open_connection_total')
                self.stats.gauge('current_connections', 1, delta=True)
        except psycopg2.DatabaseError as ex:
            self.connection = None
            log.error(ex)
        finally:
            return self.connection

    def close(self):
        try:
            if self.connection:
                self.connection.close()
                if self.stats:
                    self.stats.decr('postgres_closed_connection_total')
                    self.stats.gauge('current_connections', -1, delta=True)
        except Exception as ex:
            log.error(ex)

    def execute(self, query: str, data: tuple) -> Tuple[bool, Optional[Any]]:
        success = False
        error = None
        if self.connect():
            try:
                cur = self.connection.cursor()
                cur.execute(query, vars=data)
                self.connection.commit()
                cur.close()
                success = True
            except (Exception, psycopg2.DatabaseError) as ex:
                error = ex
                log.error(ex)
            finally:
                self.close()

        return success, error

    def execute_select(self, query: str) -> Tuple[bool, Optional[Any], List[dict]]:
        success = False
        error = None
        result = []
        if self.connect():
            try:
                cursor = self.connection.cursor()
                cursor.execute(query)
                data = cursor.fetchall()

                col_names = []
                for desc in cursor.description:
                    col_names.append(desc[0])

                for row in data:
                    row_data = {}
                    for n in range(0, len(col_names)):
                        row_data.update({col_names[n]: row[n]})
                    result.append(row_data)
                success = True
            except (Exception, psycopg2.DatabaseError) as ex:
                error = ex
                log.error(ex)
            finally:
                self.close()

        return success, error, result

    def update_items(self, data: tuple):
        if self.stats:
            timer = self.stats.timer('update_items_query_duration')
            timer.start()
        log.info('Update amount of items sold. Number: {} Product: {}'.format(data[0], data[1]))
        query = f'UPDATE {self.TABLES["account"]} SET items_sold = %s WHERE product = %s'
        success, error = self.execute(query=query, data=data)
        if self.stats:
            timer.stop()
        return success, error

    def get_items_sold(self, product_name: str):
        if self.stats:
            timer = self.stats.timer('get_items_sold_query_duration')
            timer.start()
        log.info('Query DB for items sold of product: %s', product_name)
        query = f'SELECT product, items_sold FROM {self.TABLES["account"]} WHERE product = \'{product_name}\''
        success, error, result = self.execute_select(query=query)
        if result:
            result = result[0]
        if self.stats:
            timer.stop()
        return success, error, result

    def get_price_of_product(self, product_name: str):
        if self.stats:
            timer = self.stats.timer('get_price_of_product_query_duration')
            timer.start()
        log.info('Query DB for price of product: %s', product_name)
        query = f'SELECT product, price FROM {self.TABLES["account"]} WHERE product = \'{product_name}\''
        success, error, result = self.execute_select(query=query)
        if result:
            result = result[0]
        if self.stats:
            timer.stop()
        return success, error, result
