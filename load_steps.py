git add features/steps/load_steps.py
git commit -m "Adiciona função de carregamento de dados BDD"
git push origin main

from behave import given
from service.models import Product
from service import db

@given('the following products')
def load_products(context):
    """
    Load the initial set of products into the database
    """
    for row in context.table:
        product = Product(
            name=row['name'],
            category=row['category'],
            available=row['available'].lower() == 'true',
            price=float(row['price'])
        )
        db.session.add(product)
    db.session.commit()

git add features/steps/load_steps.py
git commit -m "Adiciona carregamento de dados de background para produtos"
git push origin main

