import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'product_card.dart';

import 'home.dart';
import 'user_announcements.dart';
import 'user_posted_announcement.dart';
import 'user_sell.dart';
import 'home_header_footer.dart';
import '../login_signup.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  String selectedBarangay = '';
  String username = '';
  String email = '';
  final List<String> barangayList = [
    'Banilad',
    'Bulacao',
    'Day-as',
    'Ermita',
    'Guadalupe',
    'Inayawan',
    'Labangon',
    'Lahug',
    'Pari-an',
    'Pasil'
  ];

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        selectedBarangay = userDoc.data()?['barangay'] ?? '';
        username = userDoc.data()?['username'] ?? '';
        email = userDoc.data()?['email'] ?? '';
      });
    }
  }

  Future<void> _saveChanges() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'barangay': selectedBarangay,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Changes saved!')),
      );
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
                  onNotificationTap: () {},
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
                        stream: (selectedBarangay.isNotEmpty
                                ? FirebaseFirestore.instance
                                    .collection('products')
                                    .where('sellerId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                                    .where('barangay', isEqualTo: selectedBarangay)
                                    .snapshots()
                                : FirebaseFirestore.instance
                                    .collection('products')
                                    .where('sellerId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                                    .snapshots()),
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
                          return GridView.count(
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            mainAxisSpacing: relHeight(12),
                            crossAxisSpacing: relWidth(10),
                            childAspectRatio: 0.95,
                            physics: NeverScrollableScrollPhysics(),
                            children: products.map((doc) {
                              final data = doc.data() as Map<String, dynamic>;
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: relHeight(2), horizontal: relWidth(2)),
                                child: SizedBox(
                                  height: relHeight(170), // Match home.dart card height
                                  child: ProductCard(
                                    imageBase64: data['imageBase64'] ?? '',
                                    name: data['productName'] ?? '',
                                    price: data['price']?.toString() ?? '',
                                    category: data['category'] ?? '',
                                    sold: data['sold']?.toString() ?? '0',
                                  ),
                                ),
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
                  Padding(
                    padding: EdgeInsets.only(
                      top: relHeight(20),
                      left: relWidth(23),
                      right: relWidth(23),
                    ),
                    child: Center(
                      child: Text(
                        '--- No Favorite Listings Yet. ---',
                        style: TextStyle(
                          fontFamily: 'RobotoCondensed',
                          fontSize: relWidth(20),
                          fontWeight: FontWeight.w500,
                          color: const Color(0x88888888),
                        ),
                        textAlign: TextAlign.center,
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
                        showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (context) => Center(
                            child: Material(
                              color: Colors.transparent,
                              child: Container(
                                width: relWidth(312),
                                height: relHeight(230),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF3F2F2),
                                  borderRadius: BorderRadius.circular(relWidth(3)),
                                  border: Border.all(
                                    color: const Color.fromRGBO(0, 0, 0, 0.22),
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: relWidth(215),
                                      height: relHeight(25),
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.symmetric(vertical: relHeight(7)),
                                      child: Text(
                                        'Log Out',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: const Color(0xFF611A04),
                                          fontFamily: 'Roboto',
                                          fontSize: relWidth(18),
                                          fontWeight: FontWeight.w700,
                                          fontStyle: FontStyle.normal,
                                          height: 1.17182,
                                          letterSpacing: 0.32,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                    ),
                                    Divider(
                                      color: const Color.fromRGBO(0, 0, 0, 0.22),
                                      thickness: 1,
                                      height: relHeight(16),
                                    ),
                                    Container(
                                      width: relWidth(232),
                                      height: relHeight(81),
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Do you want to log out?',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: const Color(0xFF611A04),
                                          fontFamily: 'Roboto',
                                          fontSize: relWidth(20),
                                          fontWeight: FontWeight.w700,
                                          fontStyle: FontStyle.normal,
                                          height: 1.17182,
                                          letterSpacing: 0.4,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: relHeight(15)),
                                    GestureDetector(
                                      onTap: () async {
                                        Navigator.of(context).pop();
                                        try {
                                          await FirebaseAuth.instance.signOut();
                                        } catch (e) {}
                                        if (context.mounted) {
                                          Navigator.of(context).pushAndRemoveUntil(
                                            MaterialPageRoute(
                                              builder: (context) => LoginSignupScreen(),
                                            ),
                                            (route) => false,
                                          );
                                        }
                                      },
                                      child: Container(
                                        width: relWidth(133),
                                        height: relHeight(28),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF611A04).withOpacity(0.8),
                                          borderRadius: BorderRadius.circular(relWidth(3)),
                                          border: Border.all(
                                            color: const Color(0xFF611A04),
                                            width: 1,
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Log Out',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Roboto',
                                            fontWeight: FontWeight.w700,
                                            fontSize: relWidth(16),
                                            decoration: TextDecoration.none,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
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
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
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
        activeTab: 'profile',
      ),
    );
  }
}


