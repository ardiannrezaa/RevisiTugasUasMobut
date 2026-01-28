import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../core/api.dart';

enum ArticleMode { add, edit }

class ArticleFormScreen extends StatefulWidget {
  final ArticleMode mode;
  final String? articleId;

  const ArticleFormScreen({super.key, required this.mode, this.articleId});

  @override
  State<ArticleFormScreen> createState() => _ArticleFormScreenState();
}

class _ArticleFormScreenState extends State<ArticleFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final titleC = TextEditingController();
  final contentC = TextEditingController();
  bool loading = false;

  Future<void> loadDetail() async {
    if (widget.mode != ArticleMode.edit) return;
    setState(() => loading = true);
    try {
      final res = await Api.dio.get("/articles/detail.php", queryParameters: {"id": widget.articleId});
      final parsed = res.data is String ? jsonDecode(res.data) : res.data;
      if (parsed["success"] == true) {
        final d = parsed["data"];
        titleC.text = d["title"].toString();
        contentC.text = d["content"].toString();
      }
    } catch (_) {} finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => loading = true);

    try {
      final path = widget.mode == ArticleMode.add ? "/articles/create.php" : "/articles/update.php";
      final data = {
        if (widget.mode == ArticleMode.edit) "id": widget.articleId,
        "title": titleC.text.trim(),
        "content": contentC.text.trim(),
      };

      final res = await Api.dio.post(
        path,
        data: data,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      final parsed = res.data is String ? jsonDecode(res.data) : res.data;

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(parsed["message"].toString())),
      );

      if (parsed["success"] == true) Navigator.pop(context);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal simpan artikel")),
      );
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    loadDetail();
  }

  @override
  void dispose() {
    titleC.dispose();
    contentC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.mode == ArticleMode.add ? "Tambah Artikel" : "Edit Artikel";
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: titleC,
                decoration: const InputDecoration(labelText: "Judul", border: OutlineInputBorder()),
                validator: (v) => (v == null || v.trim().isEmpty) ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: contentC,
                minLines: 6,
                maxLines: null,
                decoration: const InputDecoration(labelText: "Isi Artikel", border: OutlineInputBorder()),
                validator: (v) => (v == null || v.trim().isEmpty) ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: loading ? null : submit,
                  child: Text(loading ? "Menyimpan..." : "Simpan"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
