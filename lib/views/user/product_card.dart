import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';

class ProductCard extends StatelessWidget {
  final String imageBase64;
  final String name;
  final String price;
  final String category;
  final String sold;

  const ProductCard({
    super.key,
    required this.imageBase64,
    required this.name,
    required this.price,
    required this.category,
    required this.sold,
  });

  Color getCategoryColor(String cat) {
    switch (cat) {
      case 'Fashion': return Color(0xFFC5007D);
      case 'Electronics': return Color(0xFF008AC5);
      case 'Home Living': return Color(0xFF00C5B5);
      case 'Health & Beauty': return Color(0xFF00C500);
      case 'Groceries': return Color(0xFFC57300);
      case 'Entertainment': return Color(0xFF9444C9);
      default: return Color(0xFF888888);
    }
  }

  @override
  Widget build(BuildContext context) {
    Uint8List? imageBytes;
    if (imageBase64.isNotEmpty) {
      try {
        imageBytes = base64Decode(imageBase64);
      } catch (e) {
        imageBytes = null;
      }
    }
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 90,
              width: double.infinity,
              child: imageBytes != null
                  ? Image.memory(
                      imageBytes,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    )
                  : Container(
                      color: Colors.grey[200],
                      child: Center(child: Icon(Icons.image, size: 40, color: Colors.grey)),
                    ),
            ),
            SizedBox(height: 6),
            Text(
              name,
              style: TextStyle(
                fontFamily: 'RobotoCondensed',
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Row(
              children: [
                Text('₱ $price',
                  style: TextStyle(
                    fontFamily: 'RobotoCondensed',
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Color(0xFFD84315),
                  ),
                ),
                Spacer(),
                Icon(Icons.favorite_border, color: Colors.red, size: 16),
              ],
            ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: getCategoryColor(category),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    category,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Spacer(),
                Text('$sold sold',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
