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
