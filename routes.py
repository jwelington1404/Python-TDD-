git add service/routes.py
git commit -m "Implementa funções de rotas"
git push origin main

def test_read_product(client, product_factory):
    # Cria um produto de teste
    product = product_factory.create(name="Product A", category="Category 1", available=True)
    response = client.post("/products", json=product.to_dict())
    assert response.status_code == 201

    # Faz uma requisição para ler o produto criado
    response = client.get(f"/products/{product.id}")
    assert response.status_code == 200
    
    data = response.get_json()
    assert data["name"] == "Product A"
    assert data["category"] == "Category 1"
    assert data["available"] is True

pytest tests/test_routes.py

git add tests/test_routes.py
git commit -m "Adiciona teste de READ para rotas"
git push origin main

def test_update_product(client, product_factory):
    # Cria um produto de teste
    product = product_factory.create(name="Product A", category="Category 1", available=True)
    response = client.post("/products", json=product.to_dict())
    assert response.status_code == 201

    # Atualiza o produto criado
    update_data = {"name": "Updated Product A", "category": "Updated Category", "available": False}
    response = client.put(f"/products/{product.id}", json=update_data)
    assert response.status_code == 200

    # Verifica se os dados foram atualizados
    data = response.get_json()
    assert data["name"] == "Updated Product A"
    assert data["category"] == "Updated Category"
    assert data["available"] is False

pytest tests/test_routes.py

git add tests/test_routes.py
git commit -m "Adiciona teste de UPDATE para rotas"
git push origin main

def test_delete_product(client, product_factory):
    # Cria um produto de teste
    product = product_factory.create(name="Product A", category="Category 1", available=True)
    response = client.post("/products", json=product.to_dict())
    assert response.status_code == 201

    # Deleta o produto criado
    response = client.delete(f"/products/{product.id}")
    assert response.status_code == 204

    # Verifica se o produto foi deletado
    response = client.get(f"/products/{product.id}")
    assert response.status_code == 404

pytest tests/test_routes.py

git add tests/test_routes.py
git commit -m "Adiciona teste de DELETE para rotas"
git push origin main

def test_list_all_products(client, product_factory):
    # Cria produtos de teste
    product1 = product_factory.create(name="Product A", category="Category 1", available=True)
    product2 = product_factory.create(name="Product B", category="Category 2", available=False)
    client.post("/products", json=product1.to_dict())
    client.post("/products", json=product2.to_dict())

    # Faz uma requisição para listar todos os produtos
    response = client.get("/products")
    assert response.status_code == 200

    data = response.get_json()
    assert len(data) >= 2  # Confirma que pelo menos os dois produtos estão na lista
    assert any(p["name"] == "Product A" for p in data)
    assert any(p["name"] == "Product B" for p in data)

pytest tests/test_routes.py

git add tests/test_routes.py
git commit -m "Adiciona teste de LIST ALL para rotas"
git push origin main

def test_list_products_by_name(client, product_factory):
    # Cria produtos de teste
    product1 = product_factory.create(name="Unique Product A", category="Category 1", available=True)
    product2 = product_factory.create(name="Product B", category="Category 2", available=False)
    client.post("/products", json=product1.to_dict())
    client.post("/products", json=product2.to_dict())

    # Faz uma requisição para listar produtos pelo nome
    response = client.get("/products?name=Unique Product A")
    assert response.status_code == 200

    data = response.get_json()
    assert len(data) == 1  # Espera apenas um produto na lista
    assert data[0]["name"] == "Unique Product A"
    assert data[0]["category"] == "Category 1"
    assert data[0]["available"] is True

pytest tests/test_routes.py

git add tests/test_routes.py
git commit -m "Adiciona teste de LIST BY NAME para rotas"
git push origin main

def test_list_products_by_category(client, product_factory):
    # Cria produtos de teste
    product1 = product_factory.create(name="Product A", category="Electronics", available=True)
    product2 = product_factory.create(name="Product B", category="Clothing", available=False)
    product3 = product_factory.create(name="Product C", category="Electronics", available=True)
    client.post("/products", json=product1.to_dict())
    client.post("/products", json=product2.to_dict())
    client.post("/products", json=product3.to_dict())

    # Faz uma requisição para listar produtos pela categoria
    response = client.get("/products?category=Electronics")
    assert response.status_code == 200

    data = response.get_json()
    assert len(data) == 2  # Espera dois produtos na lista
    assert all(p["category"] == "Electronics" for p in data)
    assert any(p["name"] == "Product A" for p in data)
    assert any(p["name"] == "Product C" for p in data)

pytest tests/test_routes.py

git add tests/test_routes.py
git commit -m "Adiciona teste de LIST BY CATEGORY para rotas"
git push origin main

def test_list_products_by_availability(client, product_factory):
    # Cria produtos de teste
    product1 = product_factory.create(name="Product A", category="Electronics", available=True)
    product2 = product_factory.create(name="Product B", category="Clothing", available=False)
    product3 = product_factory.create(name="Product C", category="Electronics", available=True)
    client.post("/products", json=product1.to_dict())
    client.post("/products", json=product2.to_dict())
    client.post("/products", json=product3.to_dict())

    # Faz uma requisição para listar produtos disponíveis
    response = client.get("/products?available=true")
    assert response.status_code == 200

    data = response.get_json()
    assert len(data) == 2  # Espera dois produtos na lista
    assert all(p["available"] is True for p in data)
    assert any(p["name"] == "Product A" for p in data)
    assert any(p["name"] == "Product C" for p in data)

    # Faz uma requisição para listar produtos não disponíveis
    response = client.get("/products?available=false")
    assert response.status_code == 200

    data = response.get_json()
    assert len(data) == 1  # Espera um produto na lista
    assert data[0]["name"] == "Product B"
    assert data[0]["available"] is False

pytest tests/test_routes.py

git add tests/test_routes.py
git commit -m "Adiciona teste de LIST BY AVAILABILITY para rotas"
git push origin main

from flask import jsonify, abort
from service.models import Product

@app.route("/products/<int:product_id>", methods=["GET"])
def read_product(product_id):
    """
    Read a product by its ID
    """
    product = Product.find_by_id(product_id)
    if not product:
        abort(404, description=f"Product with id {product_id} not found")
    return jsonify(product.to_dict()), 200

git add service/routes.py
git commit -m "Adiciona função de READ para rotas"
git push origin main

from flask import request, jsonify, abort
from service.models import Product

@app.route("/products/<int:product_id>", methods=["PUT"])
def update_product(product_id):
    """
    Update a product by its ID
    """
    product = Product.find_by_id(product_id)
    if not product:
        abort(404, description=f"Product with id {product_id} not found")

    # Obtém os dados do request e atualiza o produto
    data = request.get_json()
    product.name = data.get("name", product.name)
    product.category = data.get("category", product.category)
    product.available = data.get("available",

git add service/routes.py
git commit -m "Adiciona função de UPDATE para rotas"
git push origin main

from flask import jsonify, abort
from service.models import Product

@app.route("/products/<int:product_id>", methods=["DELETE"])
def delete_product(product_id):
    """
    Delete a product by its ID
    """
    product = Product.find_by_id(product_id)
    if not product:
        abort(404, description=f"Product with id {product_id} not found")

    # Remove o produto do banco de dados
    product.delete()

    return '', 204  # Retorna 204 No Content ao deletar com sucesso

git add service/routes.py
git commit -m "Adiciona função de DELETE para rotas"
git push origin main

from flask import request, jsonify
from service.models import Product

@app.route("/products", methods=["GET"])
def list_products():
    """
    List products with optional filters: name, category, availability
    """
    # Extrai os filtros da query string
    name = request.args.get("name")
    category = request.args.get("category")
    available = request.args.get("available")

    # Filtra os produtos com base nos parâmetros fornecidos
    query = Product.query
    if name:
        query = query.filter(Product.name == name)
    if category:
        query = query.filter(Product.category == category)
    if available is not None:
        available = available.lower() == 'true'
        query = query.filter(Product.available == available)

    # Executa a query e retorna os produtos
    products = query.all()
    return jsonify([product.to_dict() for product in products]), 200

git add service/routes.py
git commit -m "Adiciona funções de LIST ALL, LIST BY NAME, LIST BY CATEGORY e LIST BY AVAILABILITY para rotas"
git push origin main
