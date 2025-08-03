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
      
      // Create favorite notification for the product owner
      await _createFavoriteNotification();
    }
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  Future<void> _createFavoriteNotification() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      // Get current user's username
      final currentUserDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      final currentUsername = currentUserDoc.data()?['username'] ?? 'Someone';

      // Get product details to find the seller
      final productDoc = await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.productId)
          .get();
      
      if (productDoc.exists) {
        final productData = productDoc.data()!;
        final sellerId = productData['sellerId'];
        final productName = productData['productName'] ?? 'your product';
        
        // Don't create notification if user is favoriting their own product
        if (sellerId != user.uid) {
          await FirebaseFirestore.instance.collection('notifications').add({
            'userId': sellerId,
            'type': 'favorite',
            'username': currentUsername,
            'productName': productName,
            'comment': '',
            'reply': '',
            'title': '',
            'timestamp': FieldValue.serverTimestamp(),
            'read': false,
          });
        }
      }
    } catch (e) {
      print('Error creating favorite notification: $e');
    }
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
      child: Container(
        constraints: BoxConstraints(
          maxHeight: 160, // Limit maximum height
          maxWidth: double.infinity,
        ),
        padding: const EdgeInsets.all(4.0), // Reduced padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image container with fixed height
            Container(
              height: 60, // Reduced height
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[200],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: imageBytes != null
                    ? Image.memory(
                        imageBytes,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      )
                    : Center(child: Icon(Icons.image, size: 30, color: Colors.grey)),
              ),
            ),
            SizedBox(height: 4), // Reduced spacing
            // Product name with better constraints
            Flexible(
              child: Text(
                widget.name,
                style: TextStyle(
                  fontFamily: 'RobotoCondensed',
                  fontWeight: FontWeight.w600,
                  fontSize: 12, // Reduced font size
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: 2), // Reduced spacing
            // Price and favorite row
            Row(
              children: [
                Flexible(
                  child: Text(
                    '₱ ${widget.price}',
                    style: TextStyle(
                      fontFamily: 'RobotoCondensed',
                      fontWeight: FontWeight.bold,
                      fontSize: 13, // Reduced font size
                      color: Color(0xFFD84315),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 4),
                GestureDetector(
                  onTap: _toggleFavorite,
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.red.withOpacity(0.5),
                    size: 16, // Reduced icon size
                  ),
                ),
              ],
            ),
            SizedBox(height: 4), // Reduced spacing
                         // Category and seller row
             Row(
               children: [
                                                     // Category container with compact width
                   Container(
                     constraints: BoxConstraints(
                       minWidth: 25, // Reduced minimum width
                       maxWidth: 60, // Reduced maximum width for more space for seller name
                     ),
                     padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2), // Reduced padding
                     decoration: BoxDecoration(
                       color: getCategoryColor(widget.category),
                       borderRadius: BorderRadius.circular(8),
                       boxShadow: [
                         BoxShadow(
                           color: Colors.black.withOpacity(0.1),
                           blurRadius: 1,
                           offset: Offset(0, 1),
                         ),
                       ],
                     ),
                     child: Center(
                       child: Text(
                         widget.category,
                         style: TextStyle(
                           color: Colors.white,
                           fontSize: 7, // Smaller font size for compact display
                           fontWeight: FontWeight.w600,
                           height: 1.1, // Tighter line height
                         ),
                         overflow: TextOverflow.ellipsis,
                         maxLines: 1,
                         textAlign: TextAlign.center,
                       ),
                     ),
                   ),
                 SizedBox(width: 6), // Increased spacing
                 // Seller name with more space
                 Expanded(
                   child: FutureBuilder<DocumentSnapshot>(
                     future: FirebaseFirestore.instance.collection('products').doc(widget.productId).get(),
                     builder: (context, snapshot) {
                       if (snapshot.connectionState == ConnectionState.waiting) {
                         return SizedBox(
                           height: 12,
                           child: Center(
                             child: SizedBox(
                               width: 8,
                               height: 8,
                               child: CircularProgressIndicator(strokeWidth: 1),
                             ),
                           ),
                         );
                       }
                       if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
                         return Text(
                           'by: -',
                           style: TextStyle(fontSize: 9, color: Colors.grey[600]),
                         );
                       }
                       final data = snapshot.data!.data() as Map<String, dynamic>?;
                       final sellerName = data?['sellerName'] ?? '-';
                       return Text(
                         'by: $sellerName',
                         style: TextStyle(
                           fontSize: 9, // Slightly increased font size
                           color: Colors.grey[600],
                           fontWeight: FontWeight.w500,
                           fontStyle: FontStyle.italic,
                         ),
                         overflow: TextOverflow.ellipsis,
                         maxLines: 1,
                       );
                     },
                   ),
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
