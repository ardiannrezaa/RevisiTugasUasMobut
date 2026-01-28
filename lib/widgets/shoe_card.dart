import 'package:flutter/material.dart';

class ShoeCard extends StatelessWidget {
  final String id, name, brand, price, imageUrl;
  final bool isFav;
  final VoidCallback onToggleFav;

  const ShoeCard({
    super.key,
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    required this.imageUrl,
    required this.isFav,
    required this.onToggleFav,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    Image.asset("assets/shoe_local.jpg", width: 80, height: 80),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text("Brand: $brand"),
                Text("Harga: Rp $price"),
              ]),
            ),
            IconButton(
              onPressed: onToggleFav,
              icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
            )
          ],
        ),
      ),
    );
  }
}
