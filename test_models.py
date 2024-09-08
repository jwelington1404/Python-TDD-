git add tests/test_models.py
git commit -m "Adiciona testes para modelos"
git push origin main

def test_read_product(db_session, product_factory):
    # Cria um produto de teste
    product = product_factory.create(name="Product A", category="Category 1", available=True)
    db_session.add(product)
    db_session.commit()

    # Executa a leitura do produto pelo ID
    found_product = Product.find_by_id(product.id)
    assert found_product is not None
    assert found_product.name == "Product A"
    assert found_product.category == "Category 1"
    assert found_product.available is True

pytest tests/test_models.py

git add tests/test_models.py
git commit -m "Adiciona teste de READ para modelos"
git push origin main

