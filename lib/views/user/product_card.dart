import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'product_description.dart';

class ProductCard extends StatefulWidget {
  final String imageBase64;
  final String name;
  final String price;
  final String category;
  final String sold;
  final String productId;

  const ProductCard({
    super.key,
    required this.imageBase64,
    required this.name,
    required this.price,
    required this.category,
    required this.sold,
    required this.productId,
  });


  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isFavorite = false;
  String? userId;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  Future<void> _loadFavoriteStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    userId = user.uid;
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    final favorites = userDoc.data()?['favorites'] as List<dynamic>?;
    setState(() {
      isFavorite = favorites != null && favorites.contains(widget.productId);
    });
  }

  Future<void> _toggleFavorite() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final userDoc = await userRef.get();
    final favorites = (userDoc.data()?['favorites'] as List<dynamic>?) ?? [];
    if (isFavorite) {
      // Remove from favorites
      await userRef.update({
        'favorites': FieldValue.arrayRemove([widget.productId])
      });
    } else {
      // Add to favorites
      await userRef.set({
        'favorites': FieldValue.arrayUnion([widget.productId])
      }, SetOptions(merge: true));
    }
    setState(() {
      isFavorite = !isFavorite;
    });
  }

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
    if (widget.imageBase64.isNotEmpty) {
      try {
        imageBytes = base64Decode(widget.imageBase64);
      } catch (e) {
        imageBytes = null;
      }
    }
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductDescription(
              productId: widget.productId,
              imageBase64: widget.imageBase64,
              name: widget.name,
              price: widget.price,
              category: widget.category,
              sold: widget.sold, 
            ),
          ),
        );
      },
      child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 70,
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
            SizedBox(height: 8),
            Text(
              widget.name,
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
                Text('₱ ${widget.price}',
                  style: TextStyle(
                    fontFamily: 'RobotoCondensed',
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Color(0xFFD84315),
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: _toggleFavorite,
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.red.withOpacity(0.5),
                    size: 18,
                  ),
                ),
              ],
            ),
            SizedBox(height: 18),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: getCategoryColor(widget.category),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    widget.category,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Spacer(),
                FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance.collection('products').doc(widget.productId).get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox(
                        width: 80,
                        height: 12,
                        child: Center(
                          child: SizedBox(
                            width: 10,
                            height: 10,
                            child: CircularProgressIndicator(strokeWidth: 1.5),
                          ),
                        ),
                      );
                    }
                    if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
                      return Text(
                        'by: -',
                        style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                      );
                    }
                    final data = snapshot.data!.data() as Map<String, dynamic>?;
                    final sellerName = data?['sellerName'] ?? '-';
                    return Container(
                      constraints: BoxConstraints(maxWidth: 80),
                      child: Text(
                        'by: $sellerName',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.italic,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    )
    );
  }
}
