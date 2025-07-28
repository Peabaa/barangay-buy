import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'product_card.dart';
import 'home_header_footer.dart';

class CategoryProducts extends StatelessWidget {
  final String category;
  final String barangay;
  final double Function(double) relWidth;
  final double Function(double) relHeight;

  const CategoryProducts({
    super.key,
    required this.category,
    required this.barangay,
    required this.relWidth,
    required this.relHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Container(
              width: double.infinity,
              color: const Color(0xFFFF5B29),
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  HomeHeader(
                    relWidth: relWidth,
                    relHeight: relHeight,
                    selectedBarangay: barangay,
                    onNotificationTap: () {},
                  ),
                  Positioned(
                    left: 0,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: relHeight(22),
              left: relWidth(23),
              right: relWidth(23),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                category,
                style: TextStyle(
                  fontFamily: 'RobotoCondensed',
                  fontSize: relWidth(16),
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF611A04),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: relWidth(16), vertical: relHeight(16)),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('products')
                    .where('barangay', isEqualTo: barangay)
                    .where('category', isEqualTo: category)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        'No products found in this category.',
                        style: TextStyle(
                          fontFamily: 'RobotoCondensed',
                          fontSize: relWidth(18),
                          color: const Color(0x88888888),
                        ),
                      ),
                    );
                  }
                  final products = snapshot.data!.docs;
                  return GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    mainAxisSpacing: relHeight(20),
                    crossAxisSpacing: relWidth(10),
                    childAspectRatio: 0.95,
                    children: products.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      return ProductCard(
                        imageBase64: data['imageBase64'] ?? '',
                        name: data['productName'] ?? '',
                        price: data['price']?.toString() ?? '',
                        category: data['category'] ?? '',
                        sold: data['sold']?.toString() ?? '0',
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
