import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'product_card.dart';
import 'home_header_footer.dart';
import '../../controllers/home_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController _controller = HomeController();
  String selectedBarangay = '';
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchBarangay();
  }

  Future<void> _fetchBarangay() async {
    final barangay = await _controller.getCurrentUserBarangay();
    if (mounted) {
      setState(() {
        selectedBarangay = barangay;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double relWidth(double dp) => screenWidth * (dp / 412);
    double relHeight(double dp) => screenHeight * (dp / 915);

    _controller.setSystemUIOverlayStyle();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Container(
              width: double.infinity,
              color: const Color(0xFFFF5B29),
              child: HomeHeader(
                relWidth: relWidth,
                relHeight: relHeight,
                selectedBarangay: selectedBarangay,
                onNotificationTap: () {
                  _controller.handleNotificationTap();
                },
                onSearchChanged: (query) {
                  _controller.handleSearchChanged(query, (newQuery) {
                    setState(() {
                      searchQuery = newQuery;
                    });
                  });
                },
                onSearchSubmitted: (query) {
                  _controller.handleSearchSubmitted(context, query, selectedBarangay, relWidth, relHeight);
                },
              ),
            ),
          ),
          // Scrollable Home Screen Content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: relHeight(22),
                      left: relWidth(23),
                      right: relWidth(23),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Browse Categories',
                        style: TextStyle(
                          fontFamily: 'RobotoCondensed',
                          fontSize: relWidth(16),
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF611A04),
                        ),
                      ),
                    ),
                  ),
                  // Categories
                  Padding(
                    padding: EdgeInsets.only(
                      left: relWidth(23),
                      right: relWidth(23),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: GridView.count(
                        crossAxisCount: 3,
                        shrinkWrap: true,
                        mainAxisSpacing: relHeight(20),
                        crossAxisSpacing: relWidth(3),
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          // Category names
                          ..._controller.getCategories().asMap().entries.map((entry) {
                            final i = entry.key;
                            final categoryName = entry.value;
                            return GestureDetector(
                              onTap: () {
                                _controller.navigateToCategory(context, categoryName, selectedBarangay, relWidth, relHeight);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(relWidth(12)),
                                  color: Colors.white,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(relWidth(8)),
                                  child: Image.asset(
                                    'assets/images/category${i + 1}.png',
                                    fit: BoxFit.contain,
                                    width: relWidth(106),
                                    height: relWidth(106),
                                  ),
                                ),
                              ),
                            );
                          }),
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
                        'Popular Items',
                        style: TextStyle(
                          fontFamily: 'RobotoCondensed',
                          fontSize: relWidth(16),
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF611A04),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: relWidth(23),
                      right: relWidth(23),
                    ),
                    // Product Listings
                    child: SizedBox(
                      width: double.infinity,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: _controller.getProductsByBarangay(selectedBarangay),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                            return Center(
                              child: Text(
                                '--- No Items Yet. ---',
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
                          return GridView.count(
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            mainAxisSpacing: relHeight(20),
                            crossAxisSpacing: relWidth(10),
                            physics: NeverScrollableScrollPhysics(),
                            children: products.map((doc) {
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
            ),
          ),
        ],
      ),
      bottomNavigationBar: HomeFooter(
        relWidth: relWidth,
        relHeight: relHeight,
        onStoreTap: () => _controller.navigateToHome(context),
        onAnnouncementTap: () => _controller.navigateToAnnouncements(context),
        onSellTap: () => _controller.navigateToSell(context),
        onProfileTap: () => _controller.navigateToProfile(context),
        activeTab: 'store',
      ),
    );
  }
}