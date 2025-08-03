import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'product_card.dart';
import 'home_header_footer.dart';
import '../../controllers/search_results_controller.dart';

class SearchResults extends StatelessWidget {
  final String searchQuery;
  final String barangay;
  final double Function(double) relWidth;
  final double Function(double) relHeight;

  const SearchResults({
    super.key,
    required this.searchQuery,
    required this.barangay,
    required this.relWidth,
    required this.relHeight,
  });

  @override
  Widget build(BuildContext context) {
    final SearchResultsController controller = SearchResultsController();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  color: const Color(0xFFFF5B29),
                  child: HomeHeader(
                    relWidth: relWidth,
                    relHeight: relHeight,
                    selectedBarangay: barangay,
                    onNotificationTap: () {
                      controller.navigateToNotifications(context);
                    },
                    onSearchChanged: (query) {
                      controller.handleSearchChanged(query);
                    },
                  ),
                ),
                Positioned(
                  left: relWidth(10),
                  top: relHeight(10),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white, size: relWidth(28)),
                    onPressed: () {
                      controller.navigateBack(context);
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: relHeight(18),
              left: relWidth(23),
              right: relWidth(23),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Search Results',
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
              padding: EdgeInsets.symmetric(
                horizontal: relWidth(23),
                vertical: relHeight(10),
              ),
              child: StreamBuilder<QuerySnapshot>(
                stream: controller.getProductsByBarangay(barangay),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        '--- No Items Found. ---',
                        style: TextStyle(
                          fontFamily: 'RobotoCondensed',
                          fontSize: relWidth(20),
                          fontWeight: FontWeight.w500,
                          color: const Color(0x88888888),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  final products = snapshot.data!.docs;
                  final filteredProducts = controller.filterProducts(products, searchQuery);
                  
                  if (filteredProducts.isEmpty) {
                    return Center(
                      child: Text(
                        '--- No Items Found. ---',
                        style: TextStyle(
                          fontFamily: 'RobotoCondensed',
                          fontSize: relWidth(20),
                          fontWeight: FontWeight.w500,
                          color: const Color(0x88888888),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  return GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    mainAxisSpacing: relHeight(20),
                    crossAxisSpacing: relWidth(10),
                    physics: const BouncingScrollPhysics(),
                    children: filteredProducts.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      return ProductCard(
                        imageBase64: data['imageBase64'] ?? '',
                        name: data['productName'] ?? '',
                        price: data['price']?.toString() ?? '',
                        category: data['category'] ?? '',
                        sold: data['sold']?.toString() ?? '0',
                        productId: doc.id,
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
