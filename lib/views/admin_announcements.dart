import 'package:flutter/material.dart';
import 'admin_header_footer.dart'; // Import your reusable header/footer

class AdminAnnouncements extends StatelessWidget {
  final String selectedBarangay;
  
  const AdminAnnouncements({super.key, this.selectedBarangay = 'Banilad'});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    double relWidth(double dp) => screenWidth * (dp / 412);
    double relHeight(double dp) => screenHeight * (dp / 915);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size(relWidth(415), relHeight(98)), 
        child: AdminHeader(
          relWidth: relWidth,
          relHeight: relHeight,
          selectedBarangay: selectedBarangay,
          onNotificationTap: () {
            print('Notification tapped');
          },
        ),
      ),
      body: Padding(
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
                // Add Announcement button
                Padding(
                  padding: EdgeInsets.only(right: relWidth(50)), 
                  child: GestureDetector(
                    onTap: () {
                      // Handle add announcement button tap
                      print('Add announcement button tapped');
                      // You can navigate to add announcement page or show a dialog
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
                // Replace this with your actual announcements list
                final List announcements = []; // Example: []

                if (announcements.isEmpty) {
                  // Show noannounce.png if no announcements
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
                        SizedBox(height: relHeight(10)), // Space between image and text
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
                  // Show announcements list here
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