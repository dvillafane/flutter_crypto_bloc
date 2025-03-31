import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/crypto_bloc.dart';
import '../services/crypto_service.dart';
import '../services/websocket_prices_service.dart';
import '../widgets/crypto_card.dart';

/// Pantalla principal para mostrar los precios de las criptomonedas
class CryptoPricesScreen extends StatelessWidget {
  const CryptoPricesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Crea una instancia del BLoC de criptomonedas y la proporciona al árbol de widgets
      create:
          (_) => CryptoBloc(
            cryptoService:
                CryptoService(), // Servicio para obtener datos iniciales
            pricesService:
                WebSocketPricesService(), // Servicio para recibir precios en tiempo real
          ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Precios de Criptomonedas',
          ), // Título de la pantalla
        ),
        body: BlocBuilder<CryptoBloc, CryptoState>(
          builder: (context, state) {
            // Mostrar un indicador de carga mientras se obtienen los datos
            if (state is CryptoLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            // Mostrar la lista de criptomonedas cuando los datos están cargados
            else if (state is CryptoLoaded) {
              return ListView.builder(
                padding: const EdgeInsets.all(
                  8.0,
                ), // Espaciado alrededor de la lista
                itemCount:
                    state.cryptos.length, // Número de elementos en la lista
                itemBuilder: (context, index) {
                  final crypto =
                      state
                          .cryptos[index]; // Criptomoneda actual en la iteración

                  // Retorna una tarjeta con la información de la criptomoneda
                  return CryptoCard(
                    crypto: crypto,
                    priceColor:
                        state.priceColors[crypto.id] ??
                        Colors.black, // Color del precio (sube/baja)
                  );
                },
              );
            }
            // Mostrar un mensaje de error si la carga falla
            else if (state is CryptoError) {
              return Center(
                child: Text(state.message),
              ); // Mensaje de error proporcionado por el estado
            }

            // Retornar un contenedor vacío en caso de que no se cumpla ninguna condición
            return Container();
          },
        ),
      ),
    );
  }
}
