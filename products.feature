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

from behave import given, when, then
from selenium import webdriver
from selenium.webdriver.common.by import By

# Configurando o WebDriver (ex: usando o Chrome)
def setup_browser():
    options = webdriver.ChromeOptions()
    options.add_argument('--headless')
    driver = webdriver.Chrome(options=options)
    return driver

@given('the following products exist')
def step_impl(context):
    """
    Assume que os produtos já estão carregados no sistema ou banco de dados.
    """
    pass  # Ou use o passo dado anteriormente para carregar produtos se necessário.

@when('I type "{product_name}" in the Name field and press the Search button')
def step_impl(context, product_name):
    context.browser = setup_browser()
    context.browser.get('http://localhost:5000')  # URL da sua aplicação
    search_box = context.browser.find_element(By.NAME, 'search')
    search_box.send_keys(product_name)
    search_button = context.browser.find_element(By.ID, 'search_button')
    search_button.click()

@then('I should see the message "{message}"')
def step_impl(context, message):
    success_message = context.browser.find_element(By.ID, 'message').text
    assert message in success_message

@then('a field should have the value "{expected_value}"')
def step_impl(context, expected_value):
    field_value = context.browser.find_element(By.ID, 'category_field').get_attribute('value')
    assert expected_value == field_value

@when('I change the category field to "{new_value}" and press the Update button')
def step_impl(context, new_value):
    category_field = context.browser.find_element(By.ID, 'category_field')
    category_field.clear()
    category_field.send_keys(new_value)
    update_button = context.browser.find_element(By.ID, 'update_button')
    update_button.click()

@when('I copy the Id field, clear the form, paste the Id field, and press the Retrieve button')
def step_impl(context):
    id_field = context.browser.find_element(By.ID, 'id_field')
    product_id = id_field.get_attribute('value')
    clear_button = context.browser.find_element(By.ID, 'clear_button')
    clear_button.click()
    id_field = context.browser.find_element(By.ID, 'id_field')
    id_field.send_keys(product_id)
    retrieve_button = context.browser.find_element(By.ID, 'retrieve_button')
    retrieve_button.click()

@then('the category field should have the value "{new_value}"')
def step_impl(context, new_value):
    category_field = context.browser.find_element(By.ID, 'category_field')
    assert new_value == category_field.get_attribute('value')

@when('I press the Clear button followed by the Search button')
def step_impl(context):
    clear_button = context.browser.find_element(By.ID, 'clear_button')
    clear_button.click()
    search_button = context.browser.find_element(By.ID, 'search_button')
    search_button.click()

@then('the changed category "{new_value}" should appear in the results')
def step_impl(context, new_value):
    results = context.browser.find_elements(By.CLASS_NAME, 'result')
    assert any(new_value in result.text for result in results)
    context.browser.quit()  # Feche o navegador após o teste

from behave import given, when, then
from selenium import webdriver
from selenium.webdriver.common.by import By

# Configurando o WebDriver (ex: usando o Chrome)
def setup_browser():
    options = webdriver.ChromeOptions()
    options.add_argument('--headless')
    driver = webdriver.Chrome(options=options)
    return driver

@given('the following products exist')
def step_impl(context):
    """
    Assume que os produtos já estão carregados no sistema ou banco de dados.
    """
    pass  # Use passos anteriores ou simule a existência dos produtos conforme necessário.

@when('I type "{product_name}" in the Name field and press the Search button')
def step_impl(context, product_name):
    context.browser = setup_browser()
    context.browser.get('http://localhost:5000')  # URL da sua aplicação
    search_box = context.browser.find_element(By.NAME, 'search')
    search_box.send_keys(product_name)
    search_button = context.browser.find_element(By.ID, 'search_button')
    search_button.click()

@then('I should see the message "{message}"')
def step_impl(context, message):
    success_message = context.browser.find_element(By.ID, 'message').text
    assert message in success_message

@then('a field should have the value "{expected_value}"')
def step_impl(context, expected_value):
    field_value = context.browser.find_element(By.ID, 'category_field').get_attribute('value')
    assert expected_value == field_value

@when('I copy the Id field, clear the form, paste the Id field, and press the Delete button')
def step_impl(context):
    id_field = context.browser.find_element(By.ID, 'id_field')
    product_id = id_field.get_attribute('value')
    clear_button = context.browser.find_element(By.ID, 'clear_button')
    clear_button.click()
    id_field = context.browser.find_element(By.ID, 'id_field')
    id_field.send_keys(product_id)
    delete_button = context.browser.find_element(By.ID, 'delete_button')
    delete_button.click()

@then('I should see the message "Product has been Deleted!"')
def step_impl(context):
    delete_message = context.browser.find_element(By.ID, 'message').text
    assert "Product has been Deleted!" in delete_message

@when('I press the Clear button followed by the Search button')
def step_impl(context):
    clear_button = context.browser.find_element(By.ID, 'clear_button')
    clear_button.click()
    search_button = context.browser.find_element(By.ID, 'search_button')
    search_button.click()

@then('the product "{product_name}" should not appear in the results')
def step_impl(context, product_name):
    results = context.browser.find_elements(By.CLASS_NAME, 'result')
    assert not any(product_name in result.text for result in results)
    context.browser.quit()  # Feche o navegador após o teste

from behave import given, when, then
from selenium import webdriver
from selenium.webdriver.common.by import By

# Configurando o WebDriver (ex: usando o Chrome)
def setup_browser():
    options = webdriver.ChromeOptions()
    options.add_argument('--headless')
    driver = webdriver.Chrome(options=options)
    return driver

@given('the following products exist')
def step_impl(context):
    """
    Assume que os produtos já estão carregados no sistema ou banco de dados.
    """
    pass  # Pode usar um setup de banco de dados para adicionar os produtos se necessário.

@when('I press the Clear button')
def step_impl(context):
    context.browser = setup_browser()
    context.browser.get('http://localhost:5000')  # URL da sua aplicação
    clear_button = context.browser.find_element(By.ID, 'clear_button')
    clear_button.click()

@when('I press the Search button')
def step_impl(context):
    search_button = context.browser.find_element(By.ID, 'search_button')
    search_button.click()

@then('I should see the message "{message}"')
def step_impl(context, message):
    success_message = context.browser.find_element(By.ID, 'message').text
    assert message in success_message

@then('all the products "{product_list}" should be in the results')
def step_impl(context, product_list):
    # Dividir a string de produtos e verificar cada um nos resultados
    expected_products = [p.strip() for p in product_list.split(',')]
    results = context.browser.find_elements(By.CLASS_NAME, 'result')
    result_texts = [result.text for result in results]

    for product in expected_products:
        assert any(product in result for result in result_texts), f"Product {product} not found in results"

    context.browser.quit()  # Fecha o navegador após o teste

from behave import given, when, then
from selenium import webdriver
from selenium.webdriver.common.by import By

# Configurando o WebDriver (ex: usando o Chrome)
def setup_browser():
    options = webdriver.ChromeOptions()
    options.add_argument('--headless')
    driver = webdriver.Chrome(options=options)
    return driver

@given('the following products exist')
def step_impl(context):
    """
    Assume que os produtos já estão carregados no sistema ou banco de dados.
    """
    pass  # Pode usar um setup de banco de dados para adicionar os produtos se necessário.

@when('I clear the page')
def step_impl(context):
    context.browser = setup_browser()
    context.browser.get('http://localhost:5000')  # URL da sua aplicação
    clear_button = context.browser.find_element(By.ID, 'clear_button')
    clear_button.click()

@when('I select the "{category}" category and press the Search button')
def step_impl(context, category):
    category_dropdown = context.browser.find_element(By.ID, 'category_dropdown')
    category_dropdown.send_keys(category)
    search_button = context.browser.find_element(By.ID, 'search_button')
    search_button.click()

@then('I should see the message "{message}"')
def step_impl(context, message):
    success_message = context.browser.find_element(By.ID, 'message').text
    assert message in success_message

@then('"{product_name}" should be in the results')
def step_impl(context, product_name):
    results = context.browser.find_elements(By.CLASS_NAME, 'result')
    result_texts = [result.text for result in results]
    assert any(product_name in result for result in result_texts), f"Product {product_name} not found in results"

@then('other products from the Background data should not be in the results')
def step_impl(context):
    # Lista de produtos que não devem aparecer
    excluded_products = ["Hat", "Shoes", "Sheets"]
    results = context.browser.find_elements(By.CLASS_NAME, 'result')
    result_texts = [result.text for result in results]

    for product in excluded_products:
        assert all(product not in result for result in result_texts), f"Product {product} found in results"

    context.browser.quit()  # Fecha o navegador após o teste

from behave import given, when, then
from selenium import webdriver
from selenium.webdriver.common.by import By

# Configurando o WebDriver (ex: usando o Chrome)
def setup_browser():
    options = webdriver.ChromeOptions()
    options.add_argument('--headless')
    driver = webdriver.Chrome(options=options)
    return driver

@given('the following products exist')
def step_impl(context):
    """
    Assume que os produtos já estão carregados no sistema ou banco de dados.
    """
    pass  # Pode usar um setup de banco de dados para adicionar os produtos se necessário.

@when('I set the Available dropdown to "{availability}" and press the Search button')
def step_impl(context, availability):
    context.browser = setup_browser()
    context.browser.get('http://localhost:5000')  # URL da sua aplicação
    available_dropdown = context.browser.find_element(By.ID, 'available_dropdown')
    available_dropdown.send_keys(availability)
    search_button = context.browser.find_element(By.ID, 'search_button')
    search_button.click()

@then('I should see the message "{message}"')
def step_impl(context, message):
    success_message = context.browser.find_element(By.ID, 'message').text
    assert message in success_message

@then('available items from the Background data should be in the results')
def step_impl(context):
    # Lista de produtos disponíveis que devem aparecer nos resultados
    available_products = ["Hat", "Big Mac"]
    results = context.browser.find_elements(By.CLASS_NAME, 'result')
    result_texts = [result.text for result in results]

    for product in available_products:
        assert any(product in result for result in result_texts), f"Available product {product} not found in results"

@then('unavailable items from the Background data should not be in the results')
def step_impl(context):
    # Lista de produtos não disponíveis que não devem aparecer nos resultados
    unavailable_products = ["Shoes", "Sheets"]
    results = context.browser.find_elements(By.CLASS_NAME, 'result')
    result_texts = [result.text for result in results]

    for product in unavailable_products:
        assert all(product not in result for result in result_texts), f"Unavailable product {product} found in results"

    context.browser.quit()  # Fecha o navegador após o teste

from behave import given, when, then
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import Select

# Configurando o WebDriver (ex: usando o Chrome)
def setup_browser():
    options = webdriver.ChromeOptions()
    options.add_argument('--headless')
    driver = webdriver.Chrome(options=options)
    return driver

@given('the following products exist')
def step_impl(context):
    """
    Assume que os produtos já estão carregados no sistema ou banco de dados.
    """
    pass  # Pode usar um setup de banco de dados para adicionar os produtos se necessário.

@when('I set the Available dropdown to "{availability}" and press the Search button')
def step_impl(context, availability):
    context.browser = setup_browser()
    context.browser.get('http://localhost:5000')  # URL da sua aplicação
    available_dropdown = Select(context.browser.find_element(By.ID, 'available_dropdown'))
    available_dropdown.select_by_visible_text(availability)
    search_button = context.browser.find_element(By.ID, 'search_button')
    search_button.click()

@then('I should see the message "{message}"')
def step_impl(context, message):
    success_message = context.browser.find_element(By.ID, 'message').text
    assert message in success_message, f'Expected message "{message}" not found, got "{success_message}"'

@then('available items from the Background data should be in the results')
def step_impl(context):
    # Lista de produtos disponíveis que devem aparecer nos resultados
    available_products = ["Hat", "Big Mac"]
    results = context.browser.find_elements(By.CLASS_NAME, 'result')
    result_texts = [result.text for result in results]

    for product in available_products:
        assert any(product in result for result in result_texts), f"Available product {product} not found in results"

@then('unavailable items from the Background data should not be in the results')
def step_impl(context):
    # Lista de produtos não disponíveis que não devem aparecer nos resultados
    unavailable_products = ["Shoes", "Sheets"]
    results = context.browser.find_elements(By.CLASS_NAME, 'result')
    result_texts = [result.text for result in results]

    for product in unavailable_products:
        assert all(product not in result for result in result_texts), f"Unavailable product {product} found in results"

    context.browser.quit()  # Fecha o navegador após o teste

git add features/products.feature features/steps/product_steps.py
git commit -m "Adiciona cenário e passos BDD para leitura de um produto"
git push origin main

