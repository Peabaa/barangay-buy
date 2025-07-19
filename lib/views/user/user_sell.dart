import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'home.dart';
import 'user_announcements.dart';
import 'user_profile.dart';
import 'home_header_footer.dart';

class UserSell extends StatefulWidget {
  const UserSell({super.key});

  @override
  State<UserSell> createState() => _UserSellState();
}

class _UserSellState extends State<UserSell> {
  String selectedBarangay = '';
  String? selectedCategory;
  File? _productImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _productImage = File(pickedFile.path);
      });
    }
  }

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
            // Add Product Image Button
            Container(
              child: GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: relHeight(243),
                  decoration: BoxDecoration(
                    color: Color(0xFFE0E0E0),
                  ),
                  child: Center(
                    child: _productImage == null
                        ? Stack(
                            alignment: Alignment.center,
                            children: [
                              Image.asset(
                                'assets/images/add_image.png',
                                width: relWidth(108),
                                height: relWidth(108),
                              ),
                            ],
                          )
                        : ClipRRect(
                            child: Image.file(
                              _productImage!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: relHeight(243),
                            ),
                          ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: relHeight(12),
                left: relWidth(24),
                right: relWidth(24),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Input the following information below to list an item:',
                      style: TextStyle(
                        fontFamily: 'RobotoCondensed',
                        fontSize: relWidth(16),
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF611A04),
                      ),
                    ),
                    // Form Fields
                    SizedBox(height: relHeight(7)),
                    Container(
                      width: double.infinity,
                      height: relHeight(186),
                      decoration: BoxDecoration(
                        color: Color(0xFFF3F2F2),
                        borderRadius: BorderRadius.circular(relWidth(3)),
                        border: Border.all(
                          color: Colors.black.withOpacity(0.22),
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: relHeight(9),
                          left: relWidth(17),
                          right: relWidth(17),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product Name Field
                            Text(
                              'Product Name:',
                              style: TextStyle(
                                fontFamily: 'RobotoCondensed',
                                fontSize: relWidth(16),
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF611A04),
                              ),
                            ),
                            Container(
                              height: relHeight(28),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(relWidth(23)),
                                border: Border.all(
                                  color: const Color(0xFF611A04),
                                  width: 1,
                                ),
                              ),
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.symmetric(horizontal: relWidth(10)),
                              child: TextField(
                                style: TextStyle(
                                  fontSize: relWidth(16),
                                  fontFamily: 'RobotoCondensed',
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration.collapsed(
                                  hintText: 'Enter product name',
                                  hintStyle: TextStyle(
                                    fontFamily: 'RobotoCondensed',
                                    fontSize: relWidth(16),
                                    color: const Color(0xFFBDBDBD),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: relHeight(6)),
                            // Price of Product Field
                            Text(
                              'Price of Product:',
                              style: TextStyle(
                                fontFamily: 'RobotoCondensed',
                                fontSize: relWidth(16),
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF611A04),
                              ),
                            ),
                            Container(
                              height: relHeight(28),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(relWidth(23)),
                                border: Border.all(
                                  color: const Color(0xFF611A04),
                                  width: 1,
                                ),
                              ),
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.symmetric(horizontal: relWidth(10)),
                              child: TextField(
                                style: TextStyle(
                                  fontSize: relWidth(16),
                                  fontFamily: 'RobotoCondensed',
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration.collapsed(
                                  hintText: 'Enter product price',
                                  hintStyle: TextStyle(
                                    fontFamily: 'RobotoCondensed',
                                    fontSize: relWidth(16),
                                    color: const Color(0xFFBDBDBD),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            SizedBox(height: relHeight(6)),
                            // Category Dropdown
                            Text(
                              'Category:',
                              style: TextStyle(
                                fontFamily: 'RobotoCondensed',
                                fontSize: relWidth(16),
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF611A04),
                              ),
                            ),
                            Container(
                              height: relHeight(28), // Same height as other input fields
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(relWidth(23)),
                                border: Border.all(
                                  color: const Color(0xFF611A04),
                                  width: 1,
                                ),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: relWidth(10)),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: selectedCategory,
                                  isExpanded: true,
                                  hint: Text(
                                    'Select category',
                                    style: TextStyle(
                                      fontFamily: 'RobotoCondensed',
                                      fontSize: relWidth(16),
                                      color: const Color(0xFFBDBDBD),
                                    ),
                                  ),
                                  style: TextStyle(
                                    fontFamily: 'RobotoCondensed',
                                    fontSize: relWidth(16),
                                    color: Colors.black,
                                  ),
                                  icon: Icon(
                                    Icons.keyboard_arrow_down,
                                    color: const Color(0xFF611A04),
                                  ),
                                  items: [
                                    'Fashion',
                                    'Electronics',
                                    'Home Living',
                                    'Health & Beauty',
                                    'Groceries',
                                    'Entertainment',
                                  ].map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedCategory = newValue!;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: relHeight(17)),
                    Container(
                      width: double.infinity,
                      height: relHeight(156),
                      decoration: BoxDecoration(
                        color: Color(0xFFF3F2F2),
                        borderRadius: BorderRadius.circular(relWidth(3)),
                        border: Border.all(
                          color: Colors.black.withOpacity(0.22),
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: relHeight(9),
                          left: relWidth(17),
                          right: relWidth(17),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Description Field
                            Text(
                              'Description:',
                              style: TextStyle(
                                fontFamily: 'RobotoCondensed',
                                fontSize: relWidth(16),
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF611A04),
                              ),
                            ),
                            SizedBox(height: relHeight(3)),
                            Container(
                              height: relHeight(107),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(relWidth(7)),
                                border: Border.all(
                                  color: const Color(0xFF611A04),
                                  width: 1,
                                ),
                              ),
                              alignment: Alignment.topLeft,
                              padding: EdgeInsets.symmetric(horizontal: relWidth(10)),
                              child: TextField(
                                maxLines: null,
                                minLines: 4,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Enter Product Description',
                                  hintStyle: TextStyle(
                                    fontFamily: 'RobotoCondensed',
                                    fontSize: relWidth(16),
                                    color: const Color(0xFFBDBDBD),
                                  ),
                                ),
                                style: TextStyle(
                                  fontSize: relWidth(16),
                                  fontFamily: 'RobotoCondensed',
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: relHeight(6)),
                    // Submit Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            print('Submit button tapped');
                          },
                          child: Image.asset(
                            'assets/images/tick_square.png',
                            width: relWidth(34),
                            height: relWidth(34),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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
        activeTab: 'sell',
      ),
    );
  }
}