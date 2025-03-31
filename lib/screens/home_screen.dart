// Importa el paquete material de Flutter, que provee componentes de UI.
import 'package:flutter/material.dart';
// Importa la pantalla que muestra los precios de criptomonedas.
import 'crypto_prices_screen.dart';

// Definición del widget HomeScreen que es de tipo StatelessWidget (no tiene estado mutable).
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Método build que construye la interfaz de usuario del widget.
  @override
  Widget build(BuildContext context) {
    // DefaultTabController permite gestionar una vista con pestañas.
    return DefaultTabController(
      length:
          2, // Número de pestañas a controlar (aunque actualmente solo se utiliza una).
      child: Scaffold(
        // AppBar con título y opciones de navegación.
        appBar: AppBar(title: const Text('CoinCap API 2.0 Demo')),
        // Cuerpo de la pantalla que muestra las diferentes vistas asociadas a cada pestaña.
        // Actualmente se muestra únicamente la pantalla de precios de criptomonedas.
        body: const TabBarView(children: [CryptoPricesScreen()]),
      ),
    );
  }
}
