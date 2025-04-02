// screens/crypto_detail_list_screen.dart
import 'package:flutter/material.dart';
import '../models/crypto.dart';
import '../services/crypto_service.dart';
import '../widgets/crypto_details_card.dart';
import 'crypto_detail_screen.dart';

class CryptoDetailListScreen extends StatefulWidget {
  const CryptoDetailListScreen({super.key});

  @override
  State<CryptoDetailListScreen> createState() => _CryptoDetailListScreenState();
}

class _CryptoDetailListScreenState extends State<CryptoDetailListScreen> {
  late Future<List<Crypto>> _cryptosFuture;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _cryptosFuture = CryptoService().fetchCryptos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Buscar criptomoneda...',
                hintStyle: const TextStyle(color: Colors.white70),
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (query) {
                setState(() {
                  _searchQuery = query.toLowerCase();
                });
              },
            ),
            const SizedBox(height: 8),
            Expanded(
              child: FutureBuilder<List<Crypto>>(
                future: _cryptosFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: \${snapshot.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  } else if (snapshot.hasData) {
                    final cryptos = snapshot.data!
                        .where((crypto) => crypto.name.toLowerCase().contains(_searchQuery) || crypto.symbol.toLowerCase().contains(_searchQuery))
                        .toList();
                    return GridView.builder(
                      padding: const EdgeInsets.all(8.0),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: cryptos.length,
                      itemBuilder: (context, index) {
                        final crypto = cryptos[index];
                        return CryptoDetailsCard(
                          crypto: crypto,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CryptoDetailScreen(assetId: crypto.id),
                              ),
                            );
                          },
                        );
                      },
                    );
                  }
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