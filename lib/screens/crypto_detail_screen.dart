// screens/crypto_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/crypto_detail.dart';
import '../services/crypto_detail_service.dart';

class CryptoDetailScreen extends StatefulWidget {
  final String assetId;

  const CryptoDetailScreen({super.key, required this.assetId});

  @override
  State<CryptoDetailScreen> createState() => _CryptoDetailScreenState();
}

class _CryptoDetailScreenState extends State<CryptoDetailScreen> {
  late Future<CryptoDetail> _cryptoDetailFuture;

  @override
  void initState() {
    super.initState();
    _cryptoDetailFuture = CryptoDetailService().fetchCryptoDetail(widget.assetId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<CryptoDetail>(
        future: _cryptoDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: \${snapshot.error}', style: const TextStyle(color: Colors.red)),
            );
          } else if (snapshot.hasData) {
            final detail = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    detail.name,
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Image.network(
                      detail.logoUrl,
                      width: 80,
                      height: 80,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    color: Colors.grey[900],
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow('Símbolo', detail.symbol, LucideIcons.hash),
                          _buildInfoRow('Rank', detail.rank.toString(), LucideIcons.star),
                          _buildInfoRow('Suministro', detail.supply.toString(), LucideIcons.database),
                          if (detail.maxSupply != null)
                            _buildInfoRow('Suministro Máximo', detail.maxSupply.toString(), LucideIcons.layers),
                          _buildInfoRow('Market Cap', '\$${detail.marketCapUsd.toStringAsFixed(2)}', LucideIcons.dollarSign),
                          _buildInfoRow('Volumen 24h', '\$${detail.volumeUsd24Hr.toStringAsFixed(2)}', LucideIcons.pieChart),
                          _buildInfoRow('Precio', '\$${detail.priceUsd.toStringAsFixed(2)}', LucideIcons.trendingUp),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return Container();
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70),
          const SizedBox(width: 8),
          Text(
            "$label: ",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 18, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}