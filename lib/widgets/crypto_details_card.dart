// Importa los paquetes necesarios.
import 'package:flutter/material.dart';
// Importa el modelo de criptomoneda.
import '../models/crypto.dart';

// Define un widget sin estado para mostrar detalles de una criptomoneda.
class CryptoDetailsCard extends StatelessWidget {
  // Atributo que representa la criptomoneda a mostrar.
  final Crypto crypto;
  // Callback que se ejecuta al presionar la tarjeta.
  final VoidCallback onTap;

  // Constructor de la tarjeta, con parámetros obligatorios para la criptomoneda y el callback.
  const CryptoDetailsCard({
    super.key,           // Clave para identificar el widget de manera única.
    required this.crypto, // Criptomoneda a mostrar en la tarjeta.
    required this.onTap,  // Acción que se ejecuta al hacer clic en la tarjeta.
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Detecta el gesto de tocar la tarjeta y ejecuta el callback 'onTap'.
      onTap: onTap,
      child: Card(
        // Establece el color de fondo de la tarjeta.
        color: const Color(0xFF303030),
        // Define la forma de la tarjeta con bordes redondeados.
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0), // Radio de redondeo.
        ),
        // Establece una elevación para dar efecto de sombra.
        elevation: 4,
        child: Column(
          // Centra los elementos verticalmente en la columna.
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Muestra el logotipo de la criptomoneda desde una URL.
            Image.network(
              crypto.logoUrl, // URL de la imagen de la criptomoneda.
              height: 50,     // Altura de la imagen.
              width: 50,      // Ancho de la imagen.
              // Muestra un ícono de error si la imagen no se puede cargar.
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.error, color: Colors.red);
              },
            ),
            // Espaciado entre la imagen y el nombre.
            const SizedBox(height: 8),
            // Muestra el nombre de la criptomoneda en texto.
            Text(
              crypto.name, // Nombre de la criptomoneda.
              style: const TextStyle(color: Colors.white), // Color de texto blanco.
            ),
          ],
        ),
      ),
    );
  }
}
