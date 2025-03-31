import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../models/crypto.dart';
import '../services/crypto_service.dart';
import '../services/websocket_prices_service.dart';

/// Definición de eventos para el BLoC de criptomonedas
abstract class CryptoEvent {}

/// Evento que se dispara al cargar la lista inicial de criptomonedas
class LoadCryptos extends CryptoEvent {}

/// Evento que se dispara al recibir nuevos precios vía WebSocket
class PricesUpdated extends CryptoEvent {
  final Map<String, double> prices;

  /// Constructor para inicializar el evento con los precios actualizados
  PricesUpdated({required this.prices});
}

/// Definición de estados que puede emitir el BLoC de criptomonedas
abstract class CryptoState {}

/// Estado que representa que las criptomonedas están en proceso de carga
class CryptoLoading extends CryptoState {}

/// Estado que indica que la carga de criptomonedas se ha completado
class CryptoLoaded extends CryptoState {
  final List<Crypto> cryptos;
  final Map<String, Color> priceColors;

  /// Constructor para inicializar el estado con la lista de criptomonedas y colores
  CryptoLoaded({required this.cryptos, required this.priceColors});
}

/// Estado que representa un error durante la carga o actualización de criptomonedas
class CryptoError extends CryptoState {
  final String message;

  /// Constructor que permite especificar el mensaje de error
  CryptoError({required this.message});
}

/// BLoC que gestiona la carga y actualización de criptomonedas en tiempo real
class CryptoBloc extends Bloc<CryptoEvent, CryptoState> {
  final CryptoService
  _cryptoService; // Servicio para obtener datos de criptomonedas
  final WebSocketPricesService
  _pricesService; // Servicio para recibir precios en tiempo real

  /// Mapa que almacena los precios previos de cada criptomoneda para detectar cambios
  final Map<String, double> _previousPrices = {};

  /// Suscripción al stream de precios provenientes del WebSocket
  late StreamSubscription<Map<String, double>> _pricesSubscription;

  /// Constructor que inicializa los servicios y define los eventos manejados
  CryptoBloc({
    required CryptoService cryptoService,
    required WebSocketPricesService pricesService,
  }) : _cryptoService = cryptoService,
       _pricesService = pricesService,
       super(CryptoLoading()) {
    // Registrar el evento para cargar las criptomonedas
    on<LoadCryptos>(_onLoadCryptos);

    // Registrar el evento para actualizar los precios
    on<PricesUpdated>(_onPricesUpdated);

    // Disparar el evento inicial de carga de criptomonedas al crear el BLoC
    add(LoadCryptos());
  }

  /// Método que maneja el evento de carga inicial de criptomonedas
  Future<void> _onLoadCryptos(
    LoadCryptos event,
    Emitter<CryptoState> emit,
  ) async {
    try {
      // Obtener la lista de criptomonedas desde el servicio
      final cryptos = await _cryptoService.fetchCryptos();

      // Ordenar la lista en orden descendente según el precio
      cryptos.sort((a, b) => b.price.compareTo(a.price));

      // Inicializar el mapa de precios previos con los valores actuales
      for (var crypto in cryptos) {
        _previousPrices[crypto.id] = crypto.price;
      }

      // Suscribirse al stream de precios del WebSocket
      _pricesSubscription = _pricesService.pricesStream.listen((prices) {
        // Disparar un evento con los precios actualizados
        add(PricesUpdated(prices: prices));
      });

      // Emitir el estado cargado con la lista de criptomonedas y colores predeterminados
      emit(
        CryptoLoaded(
          cryptos: cryptos,
          priceColors: {for (var e in cryptos) e.id: Colors.black},
        ),
      );
    } catch (e) {
      // Emitir un estado de error si la carga falla
      emit(CryptoError(message: e.toString()));
    }
  }

  /// Método que maneja el evento de actualización de precios en tiempo real
  void _onPricesUpdated(PricesUpdated event, Emitter<CryptoState> emit) {
    final currentState = state;

    // Verificar que el estado actual sea el de criptomonedas cargadas
    if (currentState is CryptoLoaded) {
      // Mapa temporal para almacenar los colores actualizados
      final Map<String, Color> updatedColors = {};

      // Actualizar los precios y colores de cada criptomoneda
      final List<Crypto> updatedCryptos =
          currentState.cryptos.map((crypto) {
            final double oldPrice = _previousPrices[crypto.id] ?? crypto.price;
            final double newPrice = event.prices[crypto.id] ?? crypto.price;

            // Determinar el color basado en la variación de precio
            Color color = Colors.black;
            if (newPrice > oldPrice) {
              color = Colors.green; // Verde si el precio sube
            } else if (newPrice < oldPrice) {
              color = Colors.red; // Rojo si el precio baja
            }

            // Actualizar el color en el mapa temporal
            updatedColors[crypto.id] = color;

            // Almacenar el precio actualizado para futuras comparaciones
            _previousPrices[crypto.id] = newPrice;

            // Devolver una nueva instancia de la criptomoneda con el precio actualizado
            return Crypto(
              id: crypto.id,
              name: crypto.name,
              symbol: crypto.symbol,
              price: newPrice,
              logoUrl: crypto.logoUrl,
            );
          }).toList();

      // Ordenar las criptomonedas por precio en orden descendente
      updatedCryptos.sort((a, b) => b.price.compareTo(a.price));

      // Emitir el nuevo estado con las criptomonedas actualizadas y los colores calculados
      emit(CryptoLoaded(cryptos: updatedCryptos, priceColors: updatedColors));
    }
  }

  /// Método que se llama al cerrar el BLoC para liberar recursos
  @override
  Future<void> close() {
    _pricesSubscription.cancel(); // Cancelar la suscripción al WebSocket
    _pricesService.dispose(); // Liberar recursos del servicio
    return super.close();
  }
}
