// Importa las bibliotecas necesarias para realizar solicitudes HTTP y manejar datos en formato JSON.
import 'dart:convert'; // Para decodificar la respuesta JSON.
import 'package:http/http.dart' as http; // Para realizar solicitudes HTTP.
// Importa el modelo que representa los detalles de una criptomoneda.
import '../models/crypto_detail.dart';

// Clase que se encarga de obtener detalles específicos de una criptomoneda desde una API.
class CryptoDetailService {
  // URL base de la API CoinCap para obtener detalles de criptomonedas.
  final String baseUrl = 'https://api.coincap.io/v2/assets';

  // Método asincrónico que obtiene los detalles de una criptomoneda específica.
  Future<CryptoDetail> fetchCryptoDetail(String assetId) async {
    // Construye la URL completa añadiendo el ID de la criptomoneda a la URL base.
    final url = Uri.parse('$baseUrl/$assetId');

    // Realiza una solicitud HTTP GET a la API.
    final response = await http.get(url);

    // Verifica si la solicitud fue exitosa (código 200).
    if (response.statusCode == 200) {
      // Decodifica la respuesta JSON en un mapa de datos.
      final data = json.decode(response.body);
      // Extrae los detalles de la criptomoneda desde la clave 'data' en el JSON y
      // crea una instancia de CryptoDetail utilizando el método fromJson.
      return CryptoDetail.fromJson(data['data']);
    } else {
      // Si la solicitud falla, lanza una excepción con el código de error.
      throw Exception('Error al obtener detalles de la criptomoneda: ${response.statusCode}');
    }
  }
}
