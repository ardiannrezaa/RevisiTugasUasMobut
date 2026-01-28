import 'dart:convert';
import 'package:flutter/material.dart';
import '../core/api.dart';
import '../core/favorites.dart';
import '../widgets/shoe_card.dart';
import '../screens/shoe_form_screen.dart';

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  List items = [];
  bool loading = true;

  Future<void> load() async {
    setState(() => loading = true);
    try {
      final res = await Api.dio.get("/shoes/list.php");
      final parsed = res.data is String ? jsonDecode(res.data) : res.data;
      items = (parsed["success"] == true) ? parsed["data"] : [];
    } catch (_) {
      items = [];
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> deleteShoe(String id) async {
    try {
      final res = await Api.dio.post(
        "/shoes/delete.php",
        data: {"id": id},
        options: Api.formOptions(),
      );
      final parsed = res.data is String ? jsonDecode(res.data) : res.data;

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(parsed["message"].toString())),
      );
      await load();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal hapus sepatu")),
      );
    }
  }

  void confirmDelete(String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Konfirmasi"),
        content: const Text("Hapus sepatu ini?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              deleteShoe(id);
            },
            child: const Text("Hapus"),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const Center(child: CircularProgressIndicator());

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: load,
        child: items.isEmpty
            ? ListView(
          children: const [
            SizedBox(height: 120),
            Center(child: Text("Data sepatu kosong")),
          ],
        )
            : ListView.builder(
          itemCount: items.length,
          itemBuilder: (_, i) {
            final m = items[i] as Map<String, dynamic>;
            final id = m["id"].toString();

            return FutureBuilder<bool>(
              future: FavoritesService.isFav(id),
              builder: (context, snap) {
                final isFav = snap.data ?? false;
                return GestureDetector(
                  onLongPress: () => confirmDelete(id),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ShoeFormScreen(
                          mode: FormMode.edit,
                          shoeId: id,
                        ),
                      ),
                    );
                    load();
                  },
                  child: ShoeCard(
                    id: id,
                    name: m["name"].toString(),
                    brand: m["brand"].toString(),
                    price: m["price"].toString(),
                    imageUrl: m["image_url"].toString(),
                    isFav: isFav,
                    onToggleFav: () async {
                      await FavoritesService.toggle(id);
                      await FavoritesService.cacheShoe(m);
                      if (!mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(isFav ? "Dihapus dari favorit" : "Ditambah ke favorit"),
                        ),
                      );
                      setState(() {});
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ShoeFormScreen(mode: FormMode.add)),
          );
          load();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
