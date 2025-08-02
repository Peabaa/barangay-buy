import 'package:flutter/material.dart';
import '../login_signup.dart';
import '../../controllers/admin_header_controller.dart';
import '../../models/admin_header_model.dart'; 

class AdminHeader extends StatefulWidget {
  final double Function(double) relWidth;
  final double Function(double) relHeight;
  final String selectedBarangay;
  final VoidCallback? onNotificationTap;
  final Function(String)? onSearchChanged;

  const AdminHeader({
    super.key,
    required this.relWidth,
    required this.relHeight,
    this.selectedBarangay = 'Banilad',
    this.onNotificationTap,
    this.onSearchChanged,
  });

  @override
  State<AdminHeader> createState() => _AdminHeaderState();
}

class _AdminHeaderState extends State<AdminHeader> {
  final TextEditingController _searchController = TextEditingController();
  late AdminHeaderModel _model;

  @override
  void initState() {
    super.initState();
    _model = AdminHeaderController.getCurrentUserState(widget.selectedBarangay);
    _searchController.addListener(() {
      setState(() {}); // Rebuild to show/hide clear button
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleSearchChanged(String query) {
    final processedQuery = AdminHeaderController.processSearchInput(query);
    _model = AdminHeaderController.updateSearchQuery(_model, processedQuery);
    widget.onSearchChanged?.call(processedQuery);
  }

  void _clearSearch() {
    _searchController.clear();
    _model = AdminHeaderController.clearSearchQuery(_model);
    widget.onSearchChanged?.call('');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.relWidth(415),
      height: widget.relHeight(98),
      color: const Color(0xFFFF5B29),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Current Barangay
          SizedBox(
            width: widget.relWidth(319),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: widget.relWidth(5)),
                  child: Container(
                    width: widget.relWidth(190),
                    height: widget.relHeight(23),
                    decoration: BoxDecoration(
                      color: Color(0xFFA22304).withOpacity(0.8),
                      borderRadius: BorderRadius.circular(widget.relWidth(23)),
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
                            width: widget.relWidth(16),
                            height: widget.relWidth(16),
                          ),
                          SizedBox(width: widget.relWidth(5)),
                          Flexible(
                            child: Text(
                              AdminHeaderController.formatBarangayText(widget.selectedBarangay),
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: widget.relWidth(13),
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
          SizedBox(height: widget.relHeight(8)),
          // Search Bar
          Container(
            width: widget.relWidth(319),
            height: widget.relHeight(35),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(widget.relWidth(17.5)),
              border: Border.all(
                color: Color(0xFF611A04),
                width: 1,
              ),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: _handleSearchChanged,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  color: Color(0xFF611A04),
                  size: widget.relWidth(20),
                ),
                suffixIcon: _searchController.text.isNotEmpty 
                  ? GestureDetector(
                      onTap: _clearSearch,
                      child: Icon(
                        Icons.clear,
                        color: Color(0xFF611A04),
                        size: widget.relWidth(18),
                      ),
                    )
                  : null,
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(
                  left: widget.relWidth(50),
                  right: widget.relWidth(12),
                  top: widget.relHeight(10),
                  bottom: widget.relHeight(10),
                ),
                isDense: true,
              ),
              style: TextStyle(
                color: Color(0xFF611A04),
                fontSize: widget.relWidth(14),
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
                                // Use controller for logout
                                try {
                                  bool logoutSuccess = await AdminHeaderController.logout();
                                  if (logoutSuccess) {
                                    if (onUserTap != null) onUserTap!();
                                    Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                        builder: (context) => LoginSignupScreen(),
                                      ),
                                      (route) => false,
                                    );
                                  } else {
                                    // Handle logout failure if needed
                                    print('Logout failed');
                                  }
                                } catch (e) {
                                  print('Error during logout: $e');
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

