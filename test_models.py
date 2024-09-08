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

def test_update_product(db_session, product_factory):
    # Cria um produto de teste
    product = product_factory.create(name="Product A", category="Category 1", available=True)
    db_session.add(product)
    db_session.commit()

    # Atualiza o produto
    product.name = "Updated Product A"
    product.category = "Updated Category"
    db_session.commit()

    # Busca o produto atualizado
    updated_product = Product.find_by_id(product.id)
    assert updated_product is not None
    assert updated_product.name == "Updated Product A"
    assert updated_product.category == "Updated Category"

pytest tests/test_models.py

git add tests/test_models.py
git commit -m "Adiciona teste de UPDATE para modelos"
git push origin main

def test_delete_product(db_session, product_factory):
    # Cria um produto de teste
    product = product_factory.create(name="Product A", category="Category 1", available=True)
    db_session.add(product)
    db_session.commit()

    # Verifica se o produto foi adicionado
    assert Product.find_by_id(product.id) is not None

    # Deleta o produto
    db_session.delete(product)
    db_session.commit()

    # Verifica se o produto foi deletado
    deleted_product = Product.find_by_id(product.id)
    assert deleted_product is None

pytest tests/test_models.py

git add tests/test_models.py
git commit -m "Adiciona teste de DELETE para modelos"
git push origin main

def test_list_all_products(db_session, product_factory):
    # Cria múltiplos produtos de teste
    product1 = product_factory.create(name="Product A", category="Category 1", available=True)
    product2 = product_factory.create(name="Product B", category="Category 2", available=False)
    db_session.add_all([product1, product2])
    db_session.commit()

    # Lista todos os produtos
    all_products = Product.list_all()
    assert len(all_products) == 2
    assert product1 in all_products
    assert product2 in all_products

pytest tests/test_models.py

def test_find_by_name(db_session, product_factory):
    # Cria produtos de teste
    product1 = product_factory.create(name="Unique Product A", category="Category 1", available=True)
    product2 = product_factory.create(name="Another Product B", category="Category 2", available=False)
    db_session.add_all([product1, product2])
    db_session.commit()

    # Encontra o produto pelo nome
    found_product = Product.find_by_name("Unique Product A")
    assert found_product is not None
    assert found_product.name == "Unique Product A"
    assert found_product.category == "Category 1"
    assert found_product.available is True

pytest tests/test_models.py

git add tests/test_models.py
git commit -m "Adiciona teste de FIND BY NAME para modelos"
git push origin main

git add tests/test_models.py
git commit -m "Adiciona teste de LIST ALL para modelos"
git push origin main

def test_find_by_category(db_session, product_factory):
    # Cria produtos de teste
    product1 = product_factory.create(name="Product A", category="Electronics", available=True)
    product2 = product_factory.create(name="Product B", category="Clothing", available=False)
    product3 = product_factory.create(name="Product C", category="Electronics", available=True)
    db_session.add_all([product1, product2, product3])
    db_session.commit()

    # Encontra os produtos pela categoria
    found_products = Product.find_by_category("Electronics")
    assert len(found_products) == 2
    assert product1 in found_products
    assert product3 in found_products

pytest tests/test_models.py

git add tests/test_models.py
git commit -m "Adiciona teste de FIND BY CATEGORY para modelos"
git push origin main

def test_find_by_availability(db_session, product_factory):
    # Cria produtos de teste
    product1 = product_factory.create(name="Product A", category="Electronics", available=True)
    product2 = product_factory.create(name="Product B", category="Clothing", available=False)
    product3 = product_factory.create(name="Product C", category="Electronics", available=True)
    db_session.add_all([product1, product2, product3])
    db_session.commit()

    # Encontra os produtos disponíveis
    available_products = Product.find_by_availability(True)
    assert len(available_products) == 2
    assert product1 in available_products
    assert product3 in available_products

    # Encontra os produtos não disponíveis
    unavailable_products = Product.find_by_availability(False)
    assert len(unavailable_products) == 1
    assert product2 in unavailable_products

pytest tests/test_models.py

git add tests/test_models.py
git commit -m "Adiciona teste de FIND BY AVAILABILITY para modelos"
git push origin main



