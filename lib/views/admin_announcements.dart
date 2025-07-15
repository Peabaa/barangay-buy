import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'admin_header_footer.dart';

class AdminAnnouncements extends StatelessWidget {
  final String selectedBarangay;

  const AdminAnnouncements({super.key, this.selectedBarangay = 'Banilad'});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    double relWidth(double dp) => screenWidth * (dp / 412);
    double relHeight(double dp) => screenHeight * (dp / 915);

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xFFFF5B29), // Orange taskbar above
        statusBarIconBrightness: Brightness.dark, // White icons
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Orange SafeArea + Header
          SafeArea(
            bottom: false,
            child: Container(
              width: double.infinity,
              color: Color(0xFFFF5B29),
              child: AdminHeader(
                relWidth: relWidth,
                relHeight: relHeight,
                selectedBarangay: selectedBarangay,
                onNotificationTap: () {
                  print('Notification tapped');
                },
              ),
            ),
          ),
          // Main content
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                top: relHeight(34),
                left: relWidth(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Announcements',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: relWidth(16),
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF611A04),
                          letterSpacing: 0.32,
                          height: 1.17182,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: relWidth(50)),
                        child: GestureDetector(
                          onTap: () {
                            print('Add announcement button tapped');
                          },
                          child: Image.asset(
                            'assets/images/addanounce.png',
                            width: relWidth(24),
                            height: relWidth(24),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: relHeight(30)),
                  Builder(
                    builder: (context) {
                      final List announcements = [];
                      if (announcements.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: relWidth(321),
                                padding: EdgeInsets.fromLTRB(
                                  relWidth(10.125),
                                  relHeight(40.125),
                                  relWidth(40.125),
                                  relHeight(26.75),
                                ),
                                child: AspectRatio(
                                  aspectRatio: 1 / 1,
                                  child: Image.asset(
                                    'assets/images/noannounce.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              SizedBox(height: relHeight(10)),
                              Container(
                                width: relWidth(249),
                                height: relHeight(43),
                                alignment: Alignment.center,
                                child: Text(
                                  'No Announcements Yet.',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: relWidth(16),
                                    fontWeight: FontWeight.w500,
                                    color: Color(0x88888888),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Column(
                          children: [
                            // ...your announcement widgets...
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: AdminFooter(
        relWidth: relWidth,
        relHeight: relHeight,
        onMegaphoneTap: () {
          print('Footer button tapped');
        },
        onUserTap: () {
          print('User button tapped');
        },
      ),
    );
  }
}