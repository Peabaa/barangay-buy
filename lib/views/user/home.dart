import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'product_card.dart';

import 'home_header_footer.dart';
import 'user_announcements.dart';
import 'user_sell.dart';
import 'user_profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedBarangay = '';

  @override
  void initState() {
    super.initState();
    _fetchBarangay();
  }

  Future<void> _fetchBarangay() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        selectedBarangay = userDoc.data()?['barangay'] ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double relWidth(double dp) => screenWidth * (dp / 412);
    double relHeight(double dp) => screenHeight * (dp / 915);

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xFFFF5B29),
        statusBarIconBrightness: Brightness.dark,
      ),
    );

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
                  print('Notification tapped');
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
                          for (var i = 0; i < 6; i++)
                            GestureDetector(
                              onTap: () {
                                // TODO: Handle button tap for category i
                                print('Category button $i tapped');
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(relWidth(12)),
                                  color: Colors.white,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(relWidth(8)),
                                  child: Image.asset(
                                    'assets/images/category${i + 1}.png', // Use your actual image names
                                    fit: BoxFit.contain,
                                    width: relWidth(106),
                                    height: relWidth(106),
                                  ),
                                ),
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
                        stream: selectedBarangay.isNotEmpty
                            ? FirebaseFirestore.instance
                                .collection('products')
                                .where('barangay', isEqualTo: selectedBarangay)
                                .snapshots()
                            : FirebaseFirestore.instance.collection('products').snapshots(),
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
        onStoreTap: () {
           Navigator.of(context).pushReplacement(
             MaterialPageRoute(builder: (context) => const HomePage()),
          );
        },
        onAnnouncementTap: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const UserAnnouncements(),
            ),
          );
        },
        onSellTap: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const UserSell(),
            ),
          );
        },
        onProfileTap: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const UserProfile(),
            ),
          );
        },
        activeTab: 'store',
      ),
    );
  }
}