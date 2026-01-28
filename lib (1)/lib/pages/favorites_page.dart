import 'dart:convert';
import 'package:flutter/material.dart';
import '../core/api.dart';
import '../core/favorites.dart';
import '../widgets/shoe_card.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  bool loading = true;
  List<Map<String, dynamic>> favShoes = [];

  Future<Map<String, dynamic>?> fetchDetail(String id) async {
    // coba dari cache dulu
    final cached = await FavoritesService.getCachedShoe(id);
    if (cached != null) return cached;

    try {
      final res = await Api.dio.get("/shoes/detail.php", queryParameters: {"id": id});
      final parsed = res.data is String ? jsonDecode(res.data) : res.data;
      if (parsed["success"] == true) {
        final d = (parsed["data"] as Map).cast<String, dynamic>();
        await FavoritesService.cacheShoe(d);
        return d;
      }
    } catch (_) {}
    return null;
  }

  Future<void> load() async {
    setState(() => loading = true);
    favShoes = [];
    final ids = await FavoritesService.getIds();

    for (final id in ids) {
      final d = await fetchDetail(id);
      if (d != null) favShoes.add(d);
    }

    if (mounted) setState(() => loading = false);
  }

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const Center(child: CircularProgressIndicator());

    if (favShoes.isEmpty) {
      return ListView(
        children: const [
          SizedBox(height: 120),
          Center(child: Text("Belum ada favorit")),
        ],
      );
    }

    return RefreshIndicator(
      onRefresh: load,
      child: ListView.builder(
        itemCount: favShoes.length,
        itemBuilder: (_, i) {
          final m = favShoes[i];
          final id = m["id"].toString();
          return ShoeCard(
            id: id,
            name: m["name"].toString(),
            brand: m["brand"].toString(),
            price: m["price"].toString(),
            imageUrl: m["image_url"].toString(),
            isFav: true,
            onToggleFav: () async {
              await FavoritesService.toggle(id);
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Dihapus dari favorit")),
              );
              load();
            },
          );
        },
      ),
    );
  }
}
