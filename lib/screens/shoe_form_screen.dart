import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../core/api.dart';

enum FormMode { add, edit }

class ShoeFormScreen extends StatefulWidget {
  final FormMode mode;
  final String? shoeId;

  const ShoeFormScreen({super.key, required this.mode, this.shoeId});

  @override
  State<ShoeFormScreen> createState() => _ShoeFormScreenState();
}

class _ShoeFormScreenState extends State<ShoeFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameC = TextEditingController();
  final brandC = TextEditingController();
  final priceC = TextEditingController();
  final imageC = TextEditingController();
  bool loading = false;

  Future<void> loadDetail() async {
    if (widget.mode != FormMode.edit) return;
    setState(() => loading = true);
    try {
      final res = await Api.dio.get("/shoes/detail.php", queryParameters: {"id": widget.shoeId});
      final parsed = res.data is String ? jsonDecode(res.data) : res.data;
      if (parsed["success"] == true) {
        final d = parsed["data"];
        nameC.text = d["name"].toString();
        brandC.text = d["brand"].toString();
        priceC.text = d["price"].toString();
        imageC.text = d["image_url"].toString();
      }
    } catch (_) {
      // ignore
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => loading = true);

    try {
      final path = widget.mode == FormMode.add ? "/shoes/create.php" : "/shoes/update.php";
      final data = {
        if (widget.mode == FormMode.edit) "id": widget.shoeId,
        "name": nameC.text.trim(),
        "brand": brandC.text.trim(),
        "price": priceC.text.trim(),
        "image_url": imageC.text.trim(),
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

      if (parsed["success"] == true) {
        Navigator.pop(context);
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal simpan sepatu")),
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
    nameC.dispose();
    brandC.dispose();
    priceC.dispose();
    imageC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.mode == FormMode.add ? "Tambah Sepatu" : "Edit Sepatu";

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
                controller: nameC,
                decoration: const InputDecoration(labelText: "Nama Sepatu", border: OutlineInputBorder()),
                validator: (v) => (v == null || v.trim().isEmpty) ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: brandC,
                decoration: const InputDecoration(labelText: "Brand", border: OutlineInputBorder()),
                validator: (v) => (v == null || v.trim().isEmpty) ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: priceC,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Harga", border: OutlineInputBorder()),
                validator: (v) => (v == null || v.trim().isEmpty) ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: imageC,
                decoration: const InputDecoration(labelText: "Image URL", border: OutlineInputBorder()),
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
