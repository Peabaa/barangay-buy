import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'product_card.dart';
import 'home_header_footer.dart';
import '../../controllers/user_profile_controller.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final UserProfileController _controller = UserProfileController();
  String selectedBarangay = '';
  String username = '';
  String email = '';
  String _searchQuery = '';
  List<String> barangayList = [];

  @override
  void initState() {
    super.initState();
    barangayList = _controller.getBarangayList();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final userData = await _controller.getCurrentUserData();
    if (userData != null) {
      setState(() {
        selectedBarangay = userData['barangay'] ?? '';
        username = userData['username'] ?? '';
        email = userData['email'] ?? '';
      });
    }
  }

  Future<void> _saveChanges() async {
    await _controller.updateUserBarangay(selectedBarangay);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Changes saved!')),
    );
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
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
                    _controller.navigateToNotifications(context);
                  },
                  onSearchChanged: (query) {
                    setState(() {
                      _searchQuery = query.toLowerCase();
                    });
                  },
                  onSearchSubmitted: (query) {
                    _controller.navigateToSearchResults(
                      context,
                      query,
                      selectedBarangay,
                      relWidth,
                      relHeight,
                    );
                  },
                ),
              ),
            ),
            // Centered user.png
            Padding(
              padding: EdgeInsets.only(top: relHeight(10)),
              child: Center(
                child: Container(
                  width: relWidth(231),
                  height: relWidth(231),
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/images/UserProfilePage.png',
                    width: relWidth(231),
                    height: relWidth(231),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            SizedBox(height: relHeight(9)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: relWidth(24)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Username
                  Text(
                    'Username',
                    style: TextStyle(
                      color: const Color(0xFF611A04),
                      fontFamily: 'Roboto',
                      fontSize: relWidth(24),
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w500,
                      height: 1.17182,
                      letterSpacing: 0.48,
                    ),
                  ),
                  SizedBox(height: relHeight(7)),
                  Container(
                    width: relWidth(299),
                    height: relHeight(17),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      username.isNotEmpty ? username : '',
                      style: TextStyle(
                        color: const Color(0xFF611A04),
                        fontFamily: 'Roboto',
                        fontSize: relWidth(16),
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                        height: 1.17176,
                        letterSpacing: 0.32,
                      ),
                    ),
                  ),
                  SizedBox(height: relHeight(3)),
                  Container(
                    width: relWidth(363),
                    height: 0,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: const Color.fromRGBO(97, 26, 4, 0.24),
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: relHeight(16)),
                  // Email Address
                  Text(
                    'Email Address',
                    style: TextStyle(
                      color: const Color(0xFF611A04),
                      fontFamily: 'Roboto',
                      fontSize: relWidth(24),
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w500,
                      height: 1.17182,
                      letterSpacing: 0.48,
                    ),
                  ),
                  SizedBox(height: relHeight(7)),
                  Container(
                    width: relWidth(299),
                    height: relHeight(20),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      email.isNotEmpty ? email : '',
                      style: TextStyle(
                        color: const Color(0xFF611A04),
                        fontFamily: 'Roboto',
                        fontSize: relWidth(16),
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                        height: 1.17176,
                        letterSpacing: 0.32,
                      ),
                    ),
                  ),
                  SizedBox(height: relHeight(3)),
                  Container(
                    width: relWidth(363),
                    height: 0,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: const Color.fromRGBO(97, 26, 4, 0.24),
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: relHeight(16)),
                  // Barangay
                  Text(
                    'Barangay',
                    style: TextStyle(
                      color: const Color(0xFF611A04),
                      fontFamily: 'Roboto',
                      fontSize: relWidth(24),
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w500,
                      height: 1.17182,
                      letterSpacing: 0.48,
                    ),
                  ),
                  SizedBox(height: relHeight(7)),
                  Container(
                    width: relWidth(370),
                    height: relHeight(20),
                    alignment: Alignment.centerLeft,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: selectedBarangay.isNotEmpty ? selectedBarangay : null,
                        hint: Text(
                          'Select Barangay',
                          style: TextStyle(
                            color: const Color(0xFF611A04),
                            fontFamily: 'Roboto',
                            fontSize: relWidth(16),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        icon: Image.asset(
                          'assets/images/arrow-left.png',
                          width: relWidth(24),
                          height: relWidth(24),
                          color: const Color(0xFF7B3F27),
                        ),
                        dropdownColor: Colors.white,
                        style: TextStyle(
                          color: const Color(0xFF611A04),
                          fontFamily: 'Roboto',
                          fontSize: relWidth(16),
                          fontWeight: FontWeight.w400,
                        ),
                        items: barangayList.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(
                                color: const Color(0xFF611A04),
                                fontFamily: 'Roboto',
                                fontSize: relWidth(16),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedBarangay = newValue ?? '';
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: relHeight(3)),
                  Container(
                    width: relWidth(363),
                    height: 0,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: const Color.fromRGBO(97, 26, 4, 0.24),
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: relHeight(16)),
                  // Save Changes Button
                  Center(
                    child: GestureDetector(
                      onTap: _saveChanges,
                      child: Container(
                        width: relWidth(183),
                        height: relHeight(38),
                        decoration: BoxDecoration(
                          color: const Color(0xFF7B3F27),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Center(
                          child: Text(
                            'Save Changes',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Roboto',
                              fontSize: relWidth(24),
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.48,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: relHeight(20)),
                  Container(
                    width: relWidth(363),
                    height: 0,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: const Color(0xFF611A04),
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: relHeight(18)),
                  // My Listings
                  Text(
                    'My Listings',
                    style: TextStyle(
                      color: const Color(0xFF611A04),
                      fontFamily: 'Roboto',
                      fontSize: relWidth(24),
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w500,
                      height: 1.17182,
                      letterSpacing: 0.48,
                    ),
                  ),
                  Container(
                    child: SizedBox(
                      width: double.infinity,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: _controller.getUserProductsStream(selectedBarangay.isNotEmpty ? selectedBarangay : null),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                            return Center(
                              child: Text(
                                '--- No Items Added. ---',
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
                          
                          // Filter products based on search query
                          final filteredProducts = _controller.filterProducts(products, _searchQuery);
                          
                          if (filteredProducts.isEmpty && _searchQuery.isNotEmpty) {
                            return Center(
                              child: Column(
                                children: [
                                  SizedBox(height: relHeight(20)),
                                  Icon(
                                    Icons.search_off,
                                    size: relWidth(60),
                                    color: const Color(0x88888888),
                                  ),
                                  SizedBox(height: relHeight(10)),
                                  Text(
                                    'No products found for "$_searchQuery"',
                                    style: TextStyle(
                                      fontFamily: 'RobotoCondensed',
                                      fontSize: relWidth(16),
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0x88888888),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            );
                          }
                          
                          return GridView.count(
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            mainAxisSpacing: relHeight(12),
                            crossAxisSpacing: relWidth(10),
                            childAspectRatio: 1.0,
                            physics: NeverScrollableScrollPhysics(),
                            children: filteredProducts.map((doc) {
                              final data = doc.data() as Map<String, dynamic>;
                              return Stack(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: relWidth(2)),
                                    child: SizedBox(
                                      height: relHeight(180),
                                      child: ProductCard(
                                        imageBase64: data['imageBase64'] ?? '',
                                        name: data['productName'] ?? '',
                                        price: data['price']?.toString() ?? '',
                                        category: data['category'] ?? '',
                                        sold: data['sold']?.toString() ?? '0',
                                        productId: doc.id,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 6,
                                    right: 6,
                                    child: GestureDetector(
                                      onTap: () async {
                                        final confirm = await _controller.showDeleteConfirmation(
                                          context,
                                          relWidth,
                                          relHeight,
                                        );
                                        if (confirm == true) {
                                          await _controller.deleteProduct(doc.id);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Product deleted successfully!')),
                                          );
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.1),
                                              blurRadius: 2,
                                            ),
                                          ],
                                        ),
                                        padding: EdgeInsets.all(6),
                                        child: Icon(Icons.delete, color: Colors.red, size: 22),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: relHeight(15)),
                  Container(
                    width: relWidth(363),
                    height: 0,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: const Color(0xFF611A04),
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: relHeight(18)),
                  // My Favorite Listings
                  Text(
                    'Favorite Listings',
                    style: TextStyle(
                      color: const Color(0xFF611A04),
                      fontFamily: 'Roboto',
                      fontSize: relWidth(24),
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w500,
                      height: 1.17182,
                      letterSpacing: 0.48,
                    ),
                  ),
                  Container(
                    child: SizedBox(
                      width: double.infinity,
                      child: FutureBuilder<DocumentSnapshot>(
                        future: _controller.getUserFavorites(),
                        builder: (context, userSnapshot) {
                          if (userSnapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (!userSnapshot.hasData || userSnapshot.data == null) {
                            return Center(child: Text('--- No Favorite Listings Yet. ---',
                              style: TextStyle(
                                fontFamily: 'RobotoCondensed',
                                fontSize: relWidth(20),
                                fontWeight: FontWeight.w500,
                                color: const Color(0x88888888),
                              ),
                              textAlign: TextAlign.center,
                            ));
                          }
                          final favorites = (userSnapshot.data!.data() as Map<String, dynamic>?)?['favorites'] as List<dynamic>?;
                          if (favorites == null || favorites.isEmpty) {
                            return Center(child: Text('--- No Favorite Listings Yet ---',
                              style: TextStyle(
                                fontFamily: 'RobotoCondensed',
                                fontSize: relWidth(20),
                                fontWeight: FontWeight.w500,
                                color: const Color(0x88888888),
                              ),
                              textAlign: TextAlign.center,
                            ));
                          }
                          return StreamBuilder<QuerySnapshot>(
                            stream: _controller.getFavoriteProductsStream(favorites, selectedBarangay),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Center(child: CircularProgressIndicator());
                              }
                              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                                return Center(child: Text('--- No Favorite Listings Yet. ---',
                                  style: TextStyle(
                                    fontFamily: 'RobotoCondensed',
                                    fontSize: relWidth(20),
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0x88888888),
                                  ),
                                  textAlign: TextAlign.center,
                                ));
                              }
                              final favProducts = snapshot.data!.docs;
                              
                              // Filter favorite products based on search query
                              final filteredFavProducts = _controller.filterProducts(favProducts, _searchQuery);
                              
                              if (filteredFavProducts.isEmpty && _searchQuery.isNotEmpty) {
                                return Center(
                                  child: Column(
                                    children: [
                                      SizedBox(height: relHeight(20)),
                                      Icon(
                                        Icons.search_off,
                                        size: relWidth(60),
                                        color: const Color(0x88888888),
                                      ),
                                      SizedBox(height: relHeight(10)),
                                      Text(
                                        'No favorite products found for "$_searchQuery"',
                                        style: TextStyle(
                                          fontFamily: 'RobotoCondensed',
                                          fontSize: relWidth(16),
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0x88888888),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                );
                              }
                              
                              return GridView.count(
                                crossAxisCount: 2,
                                shrinkWrap: true,
                                mainAxisSpacing: relHeight(12),
                                crossAxisSpacing: relWidth(10),
                                childAspectRatio: 0.97,
                                physics: NeverScrollableScrollPhysics(),
                                children: filteredFavProducts.map((doc) {
                                  final data = doc.data() as Map<String, dynamic>;
                                  return Padding(
                                    padding: EdgeInsets.symmetric(vertical: relHeight(2), horizontal: relWidth(2)),
                                    child: SizedBox(
                                      height: relHeight(170),
                                      child: ProductCard(
                                        imageBase64: data['imageBase64'] ?? '',
                                        name: data['productName'] ?? '',
                                        price: data['price']?.toString() ?? '',
                                        category: data['category'] ?? '',
                                        sold: data['sold']?.toString() ?? '0',
                                        productId: doc.id,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: relHeight(15)),
                  Container(
                    width: relWidth(363),
                    height: 0,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: const Color(0xFF611A04),
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: relHeight(16)),
                  // Log Out Button
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        _controller.showLogoutConfirmation(
                          context,
                          relWidth,
                          relHeight,
                        );
                      },
                      child: Container(
                        width: relWidth(183),
                        height: relHeight(38),
                        decoration: BoxDecoration(
                          color: const Color(0xFF7B3F27),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Center(
                          child: Text(
                            'Log Out',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Roboto',
                              fontSize: relWidth(24),
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.48,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: relHeight(20)),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: HomeFooter(
        relWidth: relWidth,
        relHeight: relHeight,
        onStoreTap: () {
          _controller.navigateToHome(context);
        },
        onAnnouncementTap: () {
          _controller.navigateToAnnouncements(context);
        },
        onSellTap: () {
          _controller.navigateToSell(context);
        },
        onProfileTap: () {
          _controller.navigateToProfile(context);
        },
        activeTab: 'profile',
      ),
    );
  }
}


