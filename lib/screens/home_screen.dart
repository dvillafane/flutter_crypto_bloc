// Importa los paquetes necesarios para la interfaz de usuario en Flutter.
import 'package:flutter/material.dart';

// Importa las pantallas que se mostrarán dentro de la pestaña.
import 'package:flutter_crypto/screens/crypto_detail_list_screen.dart';
import 'crypto_prices_screen.dart';

// Define una pantalla principal como un widget sin estado (StatelessWidget).
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      // Define el número de pestañas en la interfaz (en este caso, 2).
      length: 2,
      child: Scaffold(
        // Estructura base de la pantalla con una barra de aplicación (AppBar).
        appBar: AppBar(
          backgroundColor: Colors.black, // Color de fondo de la barra de aplicación.
          title: const Text(
            'CRIPTOMONEDAS', // Título de la aplicación en la barra superior.
            style: TextStyle(
              color: Colors.white,      // Color del texto.
              fontSize: 24,             // Tamaño de la fuente.
              fontWeight: FontWeight.bold, // Estilo en negrita.
            ),
          ),
          centerTitle: true, // Centra el título en la barra de aplicación.
          
          // Barra de pestañas (TabBar) en la parte inferior del AppBar.
          bottom: const TabBar(
            indicatorColor: Colors.blueAccent, // Color del indicador de la pestaña seleccionada.
            tabs: [
              // Primera pestaña: "Precios".
              Tab(text: "Precios"),
              // Segunda pestaña: "Detalles".
              Tab(text: "Detalles"),
            ],
          ),
        ),
        
        // Cuerpo de la pantalla que muestra el contenido de cada pestaña.
        body: const TabBarView(
          // Define el contenido asociado a cada pestaña.
          children: [
            CryptoPricesScreen(),    // Pantalla que muestra los precios de las criptomonedas.
            CryptoDetailListScreen(), // Pantalla que muestra los detalles de las criptomonedas.
          ],
        ),
      ),
    );
  }
}
