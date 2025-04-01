// Definición de la clase Crypto, que representa una criptomoneda.
class Crypto {
  // Propiedades de la clase:
  final String id; // Identificador único de la criptomoneda.
  final String name; // Nombre de la criptomoneda.
  final String symbol; // Símbolo de la criptomoneda (por ejemplo, BTC, ETH).
  final double price; // Precio actual de la criptomoneda.
  final String logoUrl; // URL del logo de la criptomoneda.

  // Constructor de la clase que recibe todos los parámetros requeridos.
  Crypto({
    required this.id,
    required this.name,
    required this.symbol,
    required this.price,
    required this.logoUrl,
  });

  // Método de fábrica que crea una instancia de Crypto a partir de un Map (JSON).
  factory Crypto.fromJson(Map<String, dynamic> json) {
    return Crypto(
      id: json['id'],
      name: json['name'],
      symbol: json['symbol'].toUpperCase(),
      // Convertir el valor a string para que tryParse funcione correctamente
      price: double.tryParse(json['priceUsd'].toString()) ?? 0,
      logoUrl:
          'https://assets.coincap.io/assets/icons/${json['symbol'].toLowerCase()}@2x.png',
    );
  }
}
