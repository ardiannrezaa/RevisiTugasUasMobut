import 'dart:convert';
import 'package:flutter/material.dart';
import '../core/api.dart';
import '../screens/article_form_screen.dart';

class ArticlePage extends StatefulWidget {
  const ArticlePage({super.key});

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  List items = [];
  bool loading = true;

  Future<void> load() async {
    setState(() => loading = true);
    try {
      final res = await Api.dio.get("/articles/list.php");
      final parsed = res.data is String ? jsonDecode(res.data) : res.data;
      items = (parsed["success"] == true) ? parsed["data"] : [];
    } catch (_) {
      items = [];
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> deleteArticle(String id) async {
    try {
      final res = await Api.dio.post(
        "/articles/delete.php",
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
        const SnackBar(content: Text("Gagal hapus artikel")),
      );
    }
  }

  void confirmDelete(String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Konfirmasi"),
        content: const Text("Hapus artikel ini?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              deleteArticle(id);
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
            Center(child: Text("Artikel kosong")),
          ],
        )
            : ListView.builder(
          itemCount: items.length,
          itemBuilder: (_, i) {
            final m = items[i] as Map<String, dynamic>;
            final id = m["id"].toString();

            return ListTile(
              title: Text(m["title"].toString()),
              subtitle: Text(
                m["content"].toString(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => confirmDelete(id),
              ),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ArticleFormScreen(mode: ArticleMode.edit, articleId: id),
                  ),
                );
                load();
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ArticleFormScreen(mode: ArticleMode.add)),
          );
          load();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
