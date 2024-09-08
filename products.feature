git add features/products.feature
git commit -m "Adiciona cenários BDD para produtos"
git push origin main

Feature: Product management
  As a user
  I want to manage products
  So that I can keep track of inventory

Scenario: Reading a Product
  Given the following products
    | name        | category   | available | price |
    | Product A   | Electronics | true     | 99.99 |
    | Product B   | Clothing    | false    | 49.99 |
  When I request to read the product with ID 1
  Then the response status code should be 200
  And the response body should contain:
    | name        | category   | available | price |
    | Product A   | Electronics | true     | 99.99 |

from behave import given, when, then
from service.models import Product
from service import db
import requests

@given('the following products')
def step_impl(context):
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

@when('I request to read the product with ID {product_id}')
def step_impl(context, product_id):
    """
    Send a GET request to read a product by ID
    """
    context.response = requests.get(f"http://localhost:5000/products/{product_id}")

@then('the response status code should be 200')
def step_impl(context):
    """
    Check that the response status code is 200
    """
    assert context.response.status_code == 200

@then('the response body should contain the product details')
def step_impl(context):
    """
    Check that the response body contains the expected product details
    """
    expected_product = {
        "name": "Product A",
        "category": "Electronics",
        "available": True,
        "price": 99.99
    }
    response_data = context.response.json()
    assert response_data['name'] == expected_product['name']
    assert response_data['category'] == expected_product['category']
    assert response_data['available'] == expected_product['available']
    assert response_data['price'] == expected_product['price']

git add features/products.feature features/steps/product_steps.py
git commit -m "Adiciona cenário e passos BDD para leitura de um produto"
git push origin main
