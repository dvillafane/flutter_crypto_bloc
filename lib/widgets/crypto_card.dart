// Importa el paquete de Flutter para crear interfaces de usuario.
import 'package:flutter/material.dart';
// Importa el modelo de datos de criptomonedas.
import '../models/crypto.dart';

// Define un widget sin estado (StatelessWidget) llamado CryptoCard.
class CryptoCard extends StatelessWidget {
  // Declaración de variables finales que se reciben como parámetros.
  final Crypto
  crypto; // Objeto de criptomoneda que contiene los datos a mostrar.
  final Color
  priceColor; // Color del precio según su variación (verde, rojo o negro).

  // Constructor de la clase CryptoCard que recibe el objeto Crypto y el color del precio.
  const CryptoCard({super.key, required this.crypto, required this.priceColor});

  @override
  Widget build(BuildContext context) {
    return Card(
      // Define el margen de la tarjeta (espaciado superior/inferior y lateral).
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: ListTile(
        // Muestra el logo de la criptomoneda como avatar circular.
        leading: CircleAvatar(
          backgroundImage: NetworkImage(
            crypto.logoUrl,
          ), // Carga la imagen desde una URL.
        ),
        // Título que muestra el nombre y símbolo de la criptomoneda.
        title: Text(
          '${crypto.name} (${crypto.symbol})',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ), // Estilo en negrita.
        ),
        // Subtítulo que muestra el precio de la criptomoneda con animación.
        subtitle: AnimatedDefaultTextStyle(
          // Duración de la animación de cambio de estilo (color).
          duration: const Duration(milliseconds: 500),
          // Estilo del texto del precio con el color variable según la variación.
          style: TextStyle(
            fontSize: 16, // Tamaño de fuente.
            fontWeight: FontWeight.bold, // Texto en negrita.
            color:
                priceColor, // Color dinámico que refleja la variación del precio.
          ),
          // Texto que muestra el precio formateado con dos decimales.
          child: Text('\$${crypto.price.toStringAsFixed(2)}'),
        ),
      ),
    );
  }
}
