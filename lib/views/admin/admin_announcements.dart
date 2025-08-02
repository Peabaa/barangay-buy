import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'admin_header_footer.dart';
import 'posted_announcement.dart';
import '../../models/announcement_model.dart';
import '../../controllers/announcement_controller.dart';

class AdminAnnouncements extends StatefulWidget {
  final String selectedBarangay;

  const AdminAnnouncements({super.key, this.selectedBarangay = 'Banilad'});

  @override
  _AdminAnnouncementsState createState() => _AdminAnnouncementsState();
}

class _AdminAnnouncementsState extends State<AdminAnnouncements> {
  String _searchQuery = '';

  double relWidth(double width) {
    return width * MediaQuery.of(context).size.width / 375;
  }

  double relHeight(double height) {
    return height * MediaQuery.of(context).size.height / 812;
  }
  final TextEditingController _createAnnouncementController = TextEditingController();

  @override
  void dispose() {
    _createAnnouncementController.dispose();
    super.dispose();
  }

  // Handle search query changes
  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }

  // Handle create announcement
  Future<void> _createAnnouncement() async {
    final text = _createAnnouncementController.text.trim();
    if (text.isEmpty) {
      _showSnackBar('Please enter announcement text');
      return;
    }

    try {
      await AnnouncementController.createAnnouncement(
        text: text,
        barangay: widget.selectedBarangay,
      );
      
      _createAnnouncementController.clear();
      Navigator.of(context).pop();
      _showSnackBar('Announcement posted successfully!');
    } catch (e) {
      _showSnackBar('Error: ${e.toString()}');
    }
  }

  // Show snackbar helper
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF611A04),
      ),
    );
  }

  // Show create announcement dialog
  void _showCreateAnnouncementDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => _buildCreateAnnouncementDialog(),
    );
  }

  // Build create announcement dialog
  Widget _buildCreateAnnouncementDialog() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double relWidth(double dp) => screenWidth * (dp / 412);
    double relHeight(double dp) => screenHeight * (dp / 915);

    return Center(
      child: SingleChildScrollView(
        child: AlertDialog(
          backgroundColor: const Color(0xFFF3F2F2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3),
            side: const BorderSide(
              color: Color.fromRGBO(0, 0, 0, 0.22),
              width: 1,
            ),
          ),
          contentPadding: EdgeInsets.zero,
          content: Container(
            width: relWidth(312),
            padding: EdgeInsets.symmetric(horizontal: relWidth(10)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: relHeight(15)),
                Text(
                  'Create Announcement',
                  style: TextStyle(
                    color: const Color(0xFF611A04),
                    fontFamily: 'Roboto',
                    fontSize: relWidth(16),
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.32,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: relHeight(9)),
                Divider(
                  color: const Color.fromRGBO(0, 0, 0, 0.22),
                  thickness: 1,
                ),
                SizedBox(height: relHeight(15)),
                Container(
                  width: relWidth(275),
                  height: relHeight(145),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(
                      color: const Color(0xFF611A04),
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(relWidth(12)),
                    child: TextField(
                      controller: _createAnnouncementController,
                      maxLines: null,
                      expands: true,
                      decoration: const InputDecoration(
                        hintText: 'Post your announcement here...',
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: relWidth(14),
                        color: const Color(0xFF611A04),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: relHeight(15)),
                SizedBox(
                  width: relWidth(275),
                  height: relHeight(28),
                  child: ElevatedButton(
                    onPressed: _createAnnouncement,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF611A04),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3),
                      ),
                      padding: EdgeInsets.zero,
                      elevation: 0,
                    ),
                    child: Text(
                      'Post',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: relWidth(14),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: relHeight(10)),
              ],
            ),
          ),
        ),
      ),
    );
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
          // Header
          SafeArea(
            bottom: false,
            child: Container(
              width: double.infinity,
              color: const Color(0xFFFF5B29),
              child: AdminHeader(
                relWidth: relWidth,
                relHeight: relHeight,
                selectedBarangay: widget.selectedBarangay,
                onSearchChanged: _onSearchChanged,
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
                  // Announcements header row
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
                          color: const Color(0xFF611A04),
                          letterSpacing: 0.32,
                          height: 1.17182,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: relWidth(50)),
                        child: GestureDetector(
                          onTap: _showCreateAnnouncementDialog,
                          child: Image.asset(
                            'assets/images/addanounce.png',
                            width: relWidth(24),
                            height: relWidth(24),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: StreamBuilder<List<AnnouncementModel>>(
                      stream: AnnouncementController.getAnnouncementsStream(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        
                        if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        }
                        
                        final announcements = snapshot.data ?? [];
                        
                        if (announcements.isEmpty) {
                          return Align(
                            alignment: Alignment.topCenter,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: relHeight(10)),
                                Container(
                                  width: relWidth(321),
                                  padding: EdgeInsets.fromLTRB(
                                    relWidth(10.125),
                                    relHeight(40.125),
                                    relWidth(40.125),
                                    relHeight(.75),
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
                                  height: relHeight(26),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'No Announcements Yet.',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: relWidth(16),
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0x88888888),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        
                        // Filter announcements based on search query
                        final filteredAnnouncements = AnnouncementController.filterAnnouncements(announcements, _searchQuery);
                        
                        if (filteredAnnouncements.isEmpty && _searchQuery.isNotEmpty) {
                          return Align(
                            alignment: Alignment.topCenter,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: relHeight(50)),
                                Icon(
                                  Icons.search_off,
                                  size: relWidth(80),
                                  color: const Color(0x88888888),
                                ),
                                SizedBox(height: relHeight(20)),
                                Container(
                                  width: relWidth(249),
                                  height: relHeight(26),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'No announcements found',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: relWidth(16),
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0x88888888),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        
                        return ListView.builder(
                          padding: EdgeInsets.only(top: relHeight(20), right: relWidth(20)),
                          itemCount: filteredAnnouncements.length,
                          itemBuilder: (context, index) {
                            final announcement = filteredAnnouncements[index];
                            return Center(
                              child: PostedAnnouncement(
                                announcementId: announcement.id,
                                text: announcement.text,
                                username: announcement.username,
                                selectedBarangay: widget.selectedBarangay,
                                timestamp: announcement.timestamp,
                              ),
                            );
                          },
                        );
                      },
                    ),
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
      ),
    );
  }
}