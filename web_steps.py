git add features/steps/web_steps.py
git commit -m "Adiciona definições de passos BDD"
git push origin main

from behave import when
from selenium.webdriver.common.by import By

@when('I click the "{button_name}" button')
def step_impl(context, button_name):
    """
    Click a button identified by its name or ID on the webpage.
    """
    # Busca o botão pelo nome do botão ou ID
    button = context.browser.find_element(By.XPATH, f"//button[text()='{button_name}'] | //button[@id='{button_name}_button']")
    button.click()

from behave import then
from selenium.webdriver.common.by import By

@then('I should see "{text}" on the page')
def step_impl(context, text):
    """
    Verify that the specified text is present on the page.
    """
    # Verifica se o texto está presente na página
    body_text = context.browser.find_element(By.TAG_NAME, 'body').text
    assert text in body_text, f'Expected text "{text}" not found on the page.'


from behave import then
from selenium.webdriver.common.by import By

@then('I should not see "{text}" on the page')
def step_impl(context, text):
    """
    Verify that the specified text is not present on the page.
    """
    # Verifica se o texto não está presente na página
    body_text = context.browser.find_element(By.TAG_NAME, 'body').text
    assert text not in body_text, f'Unexpected text "{text}" found on the page.'

from behave import then
from selenium.webdriver.common.by import By

@then('I should see the message "{message}"')
def step_impl(context, message):
    """
    Verify that the specified message is present on the page.
    """
    # Verifica se a mensagem está presente na página
    page_message = context.browser.find_element(By.ID, 'message').text
    assert message in page_message, f'Expected message "{message}" not found, got "{page_message}".'
