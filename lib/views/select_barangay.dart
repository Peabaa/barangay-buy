
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home.dart';

class SelectBarangay extends StatefulWidget {
  final bool isConfirm;
  const SelectBarangay({super.key, this.isConfirm = true});

  @override
  State<SelectBarangay> createState() => _SelectBarangayState();
}

class _SelectBarangayState extends State<SelectBarangay> {
  String? selectedBarangay;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    double relWidth(double dp) => screenWidth * (dp / 412);
    double relHeight(double dp) => screenHeight * (dp / 915);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/background.png',
            fit: BoxFit.cover,
          ),
          // Back button
          Positioned(
            top: relHeight(40),
            left: relWidth(16),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Image.asset(
                'assets/images/back-square.png',
                width: relWidth(57),
                height: relWidth(57),
              ),
            ),
          ),
          // Barangay Selection Form
          Center(
            child: Container(
              width: relWidth(347),
              height: relHeight(350),
              decoration: BoxDecoration(
                color: Color(0xFFFF5B29).withOpacity(0.57),
                borderRadius: BorderRadius.circular(relWidth(23)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: Offset(relWidth(8), relHeight(4)),
                    blurRadius: relWidth(6),
                  ),
                ],
              ),
              //Welcome User
              child: Padding(
                padding: EdgeInsets.all(relWidth(60)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Welcome User!',
                      style: TextStyle(
                        fontFamily: 'RobotoCondensed',
                        fontSize: relWidth(36),
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.72,
                        height: 1.17182,
                        shadows: [
                          Shadow(offset: Offset(1, 0), color: Color(0xFFA22304)),
                          Shadow(offset: Offset(-1, 0), color: Color(0xFFA22304)),
                          Shadow(offset: Offset(0, 1), color: Color(0xFFA22304)),
                          Shadow(offset: Offset(0, -1), color: Color(0xFFA22304)),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: relHeight(13)),
                    Text(
                      'Select Your Barangay',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: relWidth(16),
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFA22304),
                        letterSpacing: 0.32,
                        height: 1.17182,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: relHeight(25)),
                    // Dropdown for barangay selection
                    Container(
                      width: relWidth(238),
                      height: relHeight(35),
                      padding: EdgeInsets.symmetric(horizontal: relWidth(16)),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8), // opacity: 0.8
                        borderRadius: BorderRadius.circular(relWidth(23)),
                        border: Border.all(
                          color: Color(0xFF611A04), // stroke: #611A04
                          width: 1, // stroke-width: 1px
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedBarangay,
                          hint: Text(
                            'Barangay',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: relWidth(16),
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF611A04),
                              letterSpacing: 0.32,
                              height: 1.17182, // line-height: 117.182%
                            ),
                          ),
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: relWidth(16),
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF611A04),
                            letterSpacing: 0.32,
                            height: 1.17182,
                          ),
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: Color(0xFF611A04),
                          ),
                          dropdownColor: Colors.white.withOpacity(0.95),
                          items: [
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
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: relWidth(16),
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF611A04),
                                  letterSpacing: 0.32,
                                  height: 1.17182,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedBarangay = newValue;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: relHeight(23)),
                    // Confirm Button
                    SizedBox(
                      width: relWidth(128),
                      child: ElevatedButton(
                        onPressed: selectedBarangay != null
                            ? () async {
                                final user = FirebaseAuth.instance.currentUser;
                                if (user != null) {
                                  try {
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(user.uid)
                                        .update({'barangay': selectedBarangay});
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Barangay saved!')),
                                    );
                                    // Navigate to HomePage
                                    Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(builder: (_) => const HomePage()),
                                      (route) => false,
                                    );
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Failed to save barangay.')),
                                    );
                                  }
                                }
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFA22304),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(relWidth(23)),
                          ),
                          padding: EdgeInsets.zero,
                        ),
                        child: Text(
                          'Confirm',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: relWidth(20),
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 0.4,
                            height: 1.17182,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}