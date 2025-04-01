import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/crypto_bloc.dart';
import '../models/crypto.dart';
import '../services/crypto_service.dart';
import '../services/websocket_prices_service.dart';
import '../widgets/crypto_card.dart';

/// Pantalla principal para mostrar los precios de las criptomonedas con buscador
class CryptoPricesScreen extends StatefulWidget {
  const CryptoPricesScreen({super.key});

  @override
  State<CryptoPricesScreen> createState() => _CryptoPricesScreenState();
}

class _CryptoPricesScreenState extends State<CryptoPricesScreen> {
  // Variable para almacenar el texto ingresado en el campo de búsqueda
  String searchQuery = "";

  // Controlador para el campo de búsqueda
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    // Liberar recursos asociados al controlador cuando el widget se elimine
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Proporciona el BLoC de criptomonedas al árbol de widgets
      create:
          (_) => CryptoBloc(
            cryptoService: CryptoService(),
            pricesService: WebSocketPricesService(),
          ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Precios de Criptomonedas'),
          actions: [
            Builder(
              builder: (context) {
                return IconButton(
                  // Botón para recargar el WebSocket cuando se presiona
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    context.read<CryptoBloc>().add(ReconnectWebSocket());
                  },
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            // Campo de búsqueda para filtrar criptomonedas
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: "Buscar criptomoneda...",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  // Actualizar el estado al cambiar el texto
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),
            ),
            // Lista filtrada de criptomonedas
            Expanded(
              child: BlocBuilder<CryptoBloc, CryptoState>(
                builder: (context, state) {
                  if (state is CryptoLoading) {
                    // Muestra un indicador de carga mientras se obtienen los datos
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is CryptoLoaded) {
                    // Filtra la lista de criptomonedas según la búsqueda
                    List<Crypto> filteredCryptos = state.cryptos;
                    if (searchQuery.isNotEmpty) {
                      filteredCryptos =
                          filteredCryptos.where((crypto) {
                            return crypto.name.toLowerCase().contains(
                              searchQuery.toLowerCase(),
                            );
                          }).toList();
                    }

                    // Construye la lista de criptomonedas filtradas
                    return ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      itemCount: filteredCryptos.length,
                      itemBuilder: (context, index) {
                        final crypto = filteredCryptos[index];
                        return CryptoCard(
                          crypto: crypto,
                          priceColor:
                              state.priceColors[crypto.id] ?? Colors.black,
                        );
                      },
                    );
                  } else if (state is CryptoError) {
                    // Muestra un mensaje de error en caso de fallo
                    return Center(child: Text(state.message));
                  }
                  // Devuelve un contenedor vacío si no hay estado
                  return Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
