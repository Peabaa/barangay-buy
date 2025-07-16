import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../login_signup.dart'; 

class AdminHeader extends StatelessWidget {
  final double Function(double) relWidth;
  final double Function(double) relHeight;
  final String selectedBarangay;
  final VoidCallback? onNotificationTap;

  const AdminHeader({
    super.key,
    required this.relWidth,
    required this.relHeight,
    this.selectedBarangay = 'Banilad',
    this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: relWidth(415),
      height: relHeight(98),
      color: const Color(0xFFFF5B29),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Current Barangay
          SizedBox(
            width: relWidth(319),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Current Barangay
                Padding(
                  padding: EdgeInsets.only(left: relWidth(5)),
                  child: Container(
                    width: relWidth(190),
                    height: relHeight(23),
                    decoration: BoxDecoration(
                      color: Color(0xFFA22304).withOpacity(0.8),
                      borderRadius: BorderRadius.circular(relWidth(23)),
                      border: Border.all(
                        color: Color(0xFF611A04),
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/images/location.png',
                            width: relWidth(16),
                            height: relWidth(16),
                          ),
                          SizedBox(width: relWidth(5)),
                          Flexible(
                            child: Text(
                              'Brgy $selectedBarangay, Cebu City',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: relWidth(13),
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: 0.32,
                                height: 1.17182,
                                shadows: [
                                  Shadow(offset: Offset(1, 0), color: Color(0xFF611A04)),
                                  Shadow(offset: Offset(-1, 0), color: Color(0xFF611A04)),
                                  Shadow(offset: Offset(0, 1), color: Color(0xFF611A04)),
                                  Shadow(offset: Offset(0, -1), color: Color(0xFF611A04)),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: relHeight(8)),
          // Search Bar
          Container(
            width: relWidth(319),
            height: relHeight(35),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(relWidth(17.5)),
              border: Border.all(
                color: Color(0xFF611A04),
                width: 1,
              ),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintStyle: TextStyle(
                  color: Color(0xFF611A04).withOpacity(0.6),
                  fontSize: relWidth(14),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Color(0xFF611A04),
                  size: relWidth(20),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(
                  left: relWidth(50),
                  right: relWidth(12),
                  top: relHeight(10),
                  bottom: relHeight(10),
                ),
                isDense: true,
              ),
              style: TextStyle(
                color: Color(0xFF611A04),
                fontSize: relWidth(14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AdminFooter extends StatelessWidget {
  final double Function(double) relWidth;
  final double Function(double) relHeight;
  final VoidCallback? onMegaphoneTap;
  final VoidCallback? onUserTap;

  const AdminFooter({
    super.key,
    required this.relWidth,
    required this.relHeight,
    this.onMegaphoneTap,
    this.onUserTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: relWidth(412),
      height: relHeight(98),
      color: const Color(0xFFFF5B29),
      child: Stack(
        children: [
          // Megaphone button (left)
          Positioned(
            left: relWidth(68),
            top: relHeight(11),
            child: GestureDetector(
              onTap: onMegaphoneTap ?? () {},
              child: Container(
                width: relWidth(75),
                height: relHeight(75),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 2,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/megaphone.png',
                    width: relWidth(60),
                    height: relWidth(60),
                  ),
                ),
              ),
            ),
          ),
          // White vertical line (center)
          Positioned(
            left: relWidth(206),
            top: relHeight(24),
            child: Container(
              width: 1,
              height: relHeight(50),
              color: Colors.white,
            ),
          ),
          // Logout icon (right)
          Positioned(
            left: relWidth(274),
            top: relHeight(21),
            child: Builder(
              builder: (context) => GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => Center(
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
                                ),
                              ),
                            ),
                            Container(
                              width: relWidth(312),
                              height: 0,
                              margin: EdgeInsets.only(top: relHeight(9)),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: const Color.fromRGBO(0, 0, 0, 0.22),
                                    width: 1,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: relHeight(16)),
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
                                ),
                              ),
                            ),
                            SizedBox(height: relHeight(15)),
                            GestureDetector(
                              onTap: () async {
                                Navigator.of(context).pop();
                                // Firebase Auth logout
                                try {
                                  await FirebaseAuth.instance.signOut();
                                } catch (e) {
                                  // Optionally handle error (e.g., show a snackbar)
                                }
                                // Add any other logout logic here (e.g., clear tokens, user data)
                                if (onUserTap != null) onUserTap!();
                                // Navigate to login/signup screen
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => LoginSignupScreen(),
                                  ),
                                  (route) => false,
                                );
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
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                child: Container(
                  width: relWidth(60),
                  height: relWidth(60),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Image.asset(
                    'assets/images/logout.png',
                    width: relWidth(60),
                    height: relWidth(60),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

