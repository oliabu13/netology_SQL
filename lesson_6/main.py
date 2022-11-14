import json

import sqlalchemy as sq
from sqlalchemy.orm import sessionmaker

from models import create_tables, Publisher, Book, Shop, Stock, Sale


DSN = 'postgresql://postres:password@localhost:5432/bookstore'
engine = sq.create_engine(DSN)

create_tables(engine)

Session = sessionmaker(bind=engine)
session = Session()

with open('tests_data.json') as file:
    DATA = json.load(file)


def add_data(data, **models):
    for info in data:
        model = models[info.get('model')]
        session.add(model(id=info.get('pk'), **info.get('fields')))
        session.commit()


def get_publisher_shops(publisher):
    query = session.query(Shop)
    query = query.join(Stock)
    query = query.join(Book)
    query = query.join(Publisher)
    if publisher.isdigit():
        query = query.filter(Publisher.id == publisher).all()
    else:
        query = query.filter(Publisher.name == publisher).all()
    if query:
        for record in query:
            print(record)
    else:
        print(f'Издатель ({publisher}) нет в базе данных')


session.close()


if __name__ == '__main__':
    add_data(DATA, publisher=Publisher, shop=Shop, book=Book, stock=Stock, sale=Sale)
    get_publisher_shops(input(f'Введите имя или id издателя: '))
