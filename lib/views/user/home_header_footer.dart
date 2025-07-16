import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  final double Function(double) relWidth;
  final double Function(double) relHeight;
  final String selectedBarangay;
  final VoidCallback? onNotificationTap;

  const HomeHeader({
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
                // Notification button
                GestureDetector(
                  onTap: onNotificationTap ?? () {},
                  child: Container(
                    width: relWidth(30),
                    height: relWidth(30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(relWidth(15)),
                    ),
                    child: Image.asset(
                      'assets/images/notification.png',
                      width: relWidth(24),
                      height: relWidth(24),
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

class HomeFooter extends StatelessWidget {
  final double Function(double) relWidth;
  final double Function(double) relHeight;
  final VoidCallback? onStoreTap;
  final VoidCallback? onAnnouncementTap;

  const HomeFooter({
    super.key,
    required this.relWidth,
    required this.relHeight,
    this.onStoreTap,
    this.onAnnouncementTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: relWidth(412),
      height: relHeight(98),
      color: const Color(0xFFFF5B29),
      child: Stack(
        children: [
          // Store button (leftmost)
          Positioned(
            left: relWidth(11),
            top: relHeight(11),
            child: GestureDetector(
              onTap: onStoreTap ?? () {},
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
                    'assets/images/store.png',
                    width: relWidth(60),
                    height: relWidth(60),
                  ),
                ),
              ),
            ),
          ),
          // White vertical line
          Positioned(
            left: relWidth(103),
            top: relHeight(24),
            child: Container(
              width: 1,
              height: relHeight(50),
              color: Colors.white,
            ),
          ),
          // Announcements icon (Mid-Left)
          Positioned(
            left: relWidth(127),
            top: relHeight(19),
            child: GestureDetector(
              onTap: onAnnouncementTap ?? () {},
              child: Container(
                width: relWidth(60),
                height: relWidth(60),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Image.asset(
                  'assets/images/megaphone_unselected.png',
                  width: relWidth(60),
                  height: relWidth(60),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          // White vertical line
          Positioned(
            left: relWidth(211),
            top: relHeight(24),
            child: Container(
              width: 1,
              height: relHeight(50),
              color: Colors.white,
            ),
          ),
          // Sell icon (Mid-Right)
          Positioned(
            left: relWidth(239),
            top: relHeight(19),
            child: GestureDetector(
              onTap: onAnnouncementTap ?? () {},
              child: Container(
                width: relWidth(60),
                height: relWidth(60),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Image.asset(
                  'assets/images/sell_unselected.png',
                  width: relWidth(60),
                  height: relWidth(60),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          // White vertical line
          Positioned(
            left: relWidth(319),
            top: relHeight(24),
            child: Container(
              width: 1,
              height: relHeight(50),
              color: Colors.white,
            ),
          ),
          // Profile icon (Rightmost)
          Positioned(
            left: relWidth(336),
            top: relHeight(19),
            child: GestureDetector(
              onTap: onAnnouncementTap ?? () {},
              child: Container(
                width: relWidth(60),
                height: relWidth(60),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Image.asset(
                  'assets/images/user_unselected.png',
                  width: relWidth(60),
                  height: relWidth(60),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}