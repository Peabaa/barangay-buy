import 'package:flutter/material.dart';
import '../../controllers/home_header_footer_controller.dart';

class HomeHeader extends StatefulWidget {
  final double Function(double) relWidth;
  final double Function(double) relHeight;
  final String selectedBarangay;
  final VoidCallback? onNotificationTap;
  final ValueChanged<String>? onSearchChanged;
  final ValueChanged<String>? onSearchSubmitted;

  const HomeHeader({
    super.key,
    required this.relWidth,
    required this.relHeight,
    this.selectedBarangay = 'Banilad',
    this.onNotificationTap,
    this.onSearchChanged,
    this.onSearchSubmitted,
  });

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  final HomeHeaderFooterController _controller = HomeHeaderFooterController();
  int _notificationCount = 0;

  @override
  void initState() {
    super.initState();
    _loadNotificationCount();
  }

  Future<void> _loadNotificationCount() async {
    final count = await _controller.getNotificationCount();
    if (mounted) {
      setState(() {
        _notificationCount = count;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
                              'Brgy ${widget.selectedBarangay}, Cebu City',
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
                // Notification button with badge
                GestureDetector(
                  onTap: widget.onNotificationTap ?? () {
                    _controller.navigateToNotifications(context);
                  },
                  child: Stack(
                    children: [
                      Container(
                        width: widget.relWidth(30),
                        height: widget.relWidth(30),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(widget.relWidth(15)),
                        ),
                        child: Image.asset(
                          'assets/images/notification.png',
                          width: widget.relWidth(24),
                          height: widget.relWidth(24),
                        ),
                      ),
                      if (_notificationCount > 0)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            constraints: BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              _notificationCount > 99 ? '99+' : _notificationCount.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: widget.relWidth(10),
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
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
              onChanged: (query) => _controller.handleSearchChanged(query, widget.onSearchChanged),
              onSubmitted: (query) => _controller.handleSearchSubmitted(query, widget.onSearchSubmitted),
              decoration: InputDecoration(
                hintStyle: TextStyle(
                  color: Color(0xFF611A04).withOpacity(0.6),
                  fontSize: widget.relWidth(14),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Color(0xFF611A04),
                  size: widget.relWidth(20),
                ),
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

class HomeFooter extends StatelessWidget {
  final double Function(double) relWidth;
  final double Function(double) relHeight;
  final VoidCallback? onStoreTap;
  final VoidCallback? onAnnouncementTap;
  final VoidCallback? onSellTap;
  final VoidCallback? onProfileTap;
  final String activeTab;

  const HomeFooter({
    super.key,
    required this.relWidth,
    required this.relHeight,
    this.onStoreTap,
    this.onAnnouncementTap,
    this.onSellTap,
    this.onProfileTap,
    required this.activeTab,
  });

  @override
  Widget build(BuildContext context) {
    final HomeHeaderFooterController controller = HomeHeaderFooterController();

    return Container(
      width: double.infinity,
      height: relHeight(98),
      color: const Color(0xFFFF5B29),
      child: Stack(
        children: [
          // Store button (leftmost)
          Positioned(
            left: relWidth(11),
            top: relHeight(11),
            child: GestureDetector(
              onTap: onStoreTap ?? () => controller.navigateToHome(context),
              child: Container(
                width: relWidth(75),
                height: relHeight(75),
                decoration: BoxDecoration(
                  color: activeTab == 'store' ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Image.asset(
                    activeTab == 'store'
                      ? 'assets/images/store.png'
                      : 'assets/images/store_unselected.png',  
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
              onTap: onAnnouncementTap ?? () => controller.navigateToAnnouncements(context),
              child: Container(
                width: relWidth(60),
                height: relWidth(60),
                decoration: BoxDecoration(
                  color: activeTab == 'announcements' ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Image.asset(
                    activeTab == 'announcements'
                      ? 'assets/images/megaphone.png' 
                      : 'assets/images/megaphone_unselected.png',
                    width: relWidth(60),
                    height: relWidth(60),
                    fit: BoxFit.contain,
                  ),
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
              onTap: onSellTap ?? () => controller.navigateToSell(context),
              child: Container(
                width: relWidth(60),
                height: relWidth(60),
                decoration: BoxDecoration(
                  color: activeTab == 'sell' ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Image.asset(
                    activeTab == 'sell'
                    ? 'assets/images/sell.png'
                    : 'assets/images/sell_unselected.png',
                    width: relWidth(60),
                    height: relWidth(60),
                    fit: BoxFit.contain,
                  ),
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
              onTap: onProfileTap ?? () => controller.navigateToProfile(context),
              child: Container(
                width: relWidth(60),
                height: relWidth(60),
                decoration: BoxDecoration(
                  color: activeTab == 'profile' ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Image.asset(
                    activeTab == 'profile'
                      ? 'assets/images/user.png'
                      : 'assets/images/user_unselected.png',
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