from urllib.parse import urlparse, parse_qs

url = "https://www.exito.com/celular-apple-mpuf3bea-128-gb-medianoche-3103350-3332846/p"
parsed_url = urlparse(url)
query_params = parse_qs(parsed_url.query)
product_number = query_params.get('id', [])[0] if query_params.get('id') else None

if product_number:
    print(product_number)
else:
    print("No se encontró un número de producto en la URL.")