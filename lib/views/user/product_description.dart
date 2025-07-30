import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_header_footer.dart';
import 'home.dart';
import 'user_announcements.dart';
import 'user_sell.dart';
import 'user_profile.dart';

class ProductDescription extends StatefulWidget {
  final String productId;
  final String imageBase64;
  final String name;
  final String price;
  final String category;
  final String sold;

  const ProductDescription({
    super.key,
    required this.productId,
    required this.imageBase64,
    required this.name,
    required this.price,
    required this.category,
    required this.sold,
  });

  @override
  State<ProductDescription> createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription> {
  String selectedBarangay = '';
  bool isFavorite = false;
  String? userId;
  Map<String, dynamic>? productDetails;
  bool repliesExpanded = false;

  @override
  void initState() {
    super.initState();
    _fetchBarangay();
    _loadFavoriteStatus();
    _loadProductDetails();
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

  Future<void> _loadFavoriteStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    userId = user.uid;
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    final favorites = userDoc.data()?['favorites'] as List<dynamic>?;
    setState(() {
      isFavorite = favorites != null && favorites.contains(widget.productId);
    });
  }

  Future<void> _loadProductDetails() async {
    final doc = await FirebaseFirestore.instance.collection('products').doc(widget.productId).get();
    if (doc.exists) {
      setState(() {
        productDetails = doc.data();
      });
    }
  }


  Future<void> _toggleFavorite() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final userDoc = await userRef.get();
    final favorites = (userDoc.data()?['favorites'] as List<dynamic>?) ?? [];
    if (isFavorite) {
      await userRef.update({
        'favorites': FieldValue.arrayRemove([widget.productId])
      });
    } else {
      await userRef.set({
        'favorites': FieldValue.arrayUnion([widget.productId])
      }, SetOptions(merge: true));
    }
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  Color getCategoryColor(String cat) {
    switch (cat) {
      case 'Fashion': return Color(0xFFC5007D);
      case 'Electronics': return Color(0xFF008AC5);
      case 'Home Living': return Color(0xFF00C5B5);
      case 'Health & Beauty': return Color(0xFF00C500);
      case 'Groceries': return Color(0xFFC57300);
      case 'Entertainment': return Color(0xFF9444C9);
      default: return Color(0xFF888888);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double relWidth(double dp) => screenWidth * (dp / 412);
    double relHeight(double dp) => screenHeight * (dp / 915);

    Uint8List? imageBytes;
    if (widget.imageBase64.isNotEmpty) {
      try {
        imageBytes = base64Decode(widget.imageBase64);
      } catch (e) {
        imageBytes = null;
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Container(
              width: double.infinity,
              color: const Color(0xFFFF5B29),
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  HomeHeader(
                    relWidth: relWidth,
                    relHeight: relHeight,
                    selectedBarangay: selectedBarangay,
                    onNotificationTap: () {},
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image
                  Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: relHeight(300),
                        child: imageBytes != null
                            ? Image.memory(
                                imageBytes,
                                fit: BoxFit.cover,
                                width: MediaQuery.of(context).size.width,
                                height: relHeight(300),
                              )
                            : Center(
                                child: Icon(Icons.image, size: 80, color: Colors.grey),
                              ),
                      ),
                                             // Favorite Heart Icon
                       Positioned(
                         bottom: relHeight(20),
                         right: relWidth(20),
                         child: GestureDetector(
                           onTap: _toggleFavorite,
                           child: Icon(
                             isFavorite ? Icons.favorite : Icons.favorite_border,
                             color: isFavorite ? Colors.red : Colors.white,
                             size: relWidth(32),
                           ),
                         ),
                       ),
                    ],
                  ),
                  SizedBox(height: relHeight(13)),
                  Center(
                    child: Container(
                      width: relWidth(383),
                      height: relHeight(115),
                      decoration: BoxDecoration(
                        color: Colors.grey[300], 
                        borderRadius: BorderRadius.circular(3),
                        border: Border.all(
                          color: Color.fromRGBO(0, 0, 0, 0.22),
                          width: 1,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: relHeight(7), left: relWidth(15)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.name,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: Color(0xFF611A04),
                                    fontFamily: 'Roboto',
                                    fontSize: relWidth(22),
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w600,
                                    height: 1.17182, 
                                    letterSpacing: relWidth(0.44),
                                  ),
                                ),
                                SizedBox(height: relHeight(3)),
                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/UserCircle.png',
                                      width: relWidth(32),
                                      height: relHeight(32),
                                    ),
                                    SizedBox(width: relWidth(8)),
                                    Container(
                                      width: relWidth(120),
                                      height: relHeight(26),
                                      child: Center(
                                        child: Text(
                                          productDetails?['sellerName'] ?? '',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Color(0xFF611A04),
                                            fontFamily: 'Roboto',
                                            fontSize: relWidth(20),
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w400,
                                            height: 1.17182, 
                                            letterSpacing: relWidth(0.4),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: relHeight(5)),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: relWidth(12), vertical: relHeight(6)),
                                  decoration: BoxDecoration(
                                    color: getCategoryColor(widget.category),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    widget.category,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: relWidth(14),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Price
                          Positioned(
                            top: relHeight(7),
                            right: relWidth(17),
                            child: Container(
                              width: relWidth(70),
                              height: relHeight(26),
                              child: Center(
                                child: Text(
                                  '₱${widget.price}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFF611A04),
                                    fontFamily: 'Roboto',
                                    fontSize: relWidth(20),
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w400,
                                    height: 1.17182, 
                                    letterSpacing: relWidth(0.4),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Sold count 
                          Positioned(
                            top: relHeight(33), 
                            right: relWidth(8),
                            child: Container(
                              width: relWidth(76),
                              height: relHeight(26),
                              child: Center(
                                child: Text(
                                  '${widget.sold} sold',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFF888888),
                                    fontFamily: 'Roboto',
                                    fontSize: relWidth(16),
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w500,
                                    height: 1.17182,
                                    letterSpacing: relWidth(0.32),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),          
                  SizedBox(height: relHeight(12)),
                  Center(
                    child: Container(
                      width: relWidth(383),
                      height: 1,
                      color: Color(0xFF611A04),
                    ),
                  ),
                  SizedBox(height: relHeight(12)),
                  Center(
                    child: Container(
                      width: relWidth(383),
                      height: relHeight(131),
                      decoration: BoxDecoration(
                        color: Color(0xFFF3F2F2),
                        borderRadius: BorderRadius.circular(3),
                        border: Border.all(
                          color: Color.fromRGBO(0, 0, 0, 0.22),
                          width: 1,
                        ),
                      ),
                                             child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Padding(
                             padding: EdgeInsets.only(
                               top: relHeight(7),
                               left: relWidth(19),
                             ),
                             child: Text(
                               'Description',
                               style: TextStyle(
                                 color: Color(0xFF611A04),
                                 fontFamily: 'Roboto',
                                 fontSize: relWidth(22),
                                 fontStyle: FontStyle.italic,
                                 fontWeight: FontWeight.w600,
                                 height: 1.17182,
                                 letterSpacing: relWidth(0.44),
                               ),
                             ),
                           ),
                           SizedBox(height: relHeight(3)),
                                                       Container(
                              width: relWidth(381),
                              height: 1,
                              color: Color.fromRGBO(0, 0, 0, 0.22),
                            ),
                            SizedBox(height: relHeight(10)),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: relWidth(19)),
                              child: Container(
                                width: relWidth(350),
                                child: Text(
                                  productDetails?['description'] ?? 'No description available',
                                  style: TextStyle(
                                    color: Color(0xFF611A04),
                                    fontFamily: 'Roboto',
                                    fontSize: relWidth(18),
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w400,
                                    height: 1.17176,
                                    letterSpacing: relWidth(0.36),
                                  ),
                                ),
                              ),
                            ),
                         ],
                       ),
                     ),
                   ),
                   SizedBox(height: relHeight(12)),
                   Center(
                     child: Container(
                       width: relWidth(383),
                       height: 1,
                       color: Color(0xFF611A04),
                     ),
                   ),
                   SizedBox(height: relHeight(12)),
                   Center(
                     child: Container(
                       width: relWidth(383),
                       constraints: BoxConstraints(
                         minHeight: relHeight(204),
                       ),
                       decoration: BoxDecoration(
                         color: Color(0xFFF3F2F2),
                         borderRadius: BorderRadius.circular(3),
                         border: Border.all(
                           color: Color.fromRGBO(0, 0, 0, 0.22),
                           width: 1,
                         ),
                       ),
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Padding(
                             padding: EdgeInsets.only(
                               top: relHeight(8),
                               left: relWidth(18),
                             ),
                             child: Text(
                               'Comments',
                               style: TextStyle(
                                 color: Color(0xFF611A04),
                                 fontFamily: 'Roboto',
                                 fontSize: relWidth(22),
                                 fontStyle: FontStyle.italic,
                                 fontWeight: FontWeight.w600,
                                 height: 1.17182,
                                 letterSpacing: relWidth(0.44),
                               ),
                             ),
                           ),
                          SizedBox(height: relHeight(6)),
                           Padding(
                             padding: EdgeInsets.symmetric(horizontal: relWidth(18)),
                             child: GestureDetector(
                               onTap: () {
                                 final commentController = TextEditingController();
                                 showDialog(
                                   context: context,
                                   barrierDismissible: true,
                                   builder: (context) => Center(
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
                                                 'Write Comment',
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
                                                     controller: commentController,
                                                     maxLines: null,
                                                     expands: true,
                                                     decoration: const InputDecoration(
                                                       hintText: 'Write your comment here...',
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
                                                   onPressed: () async {
                                                     final text = commentController.text.trim();
                                                     if (text.isNotEmpty) {
                                                       // TODO: Implement comment posting functionality
                                                       Navigator.of(context).pop();
                                                       ScaffoldMessenger.of(context).showSnackBar(
                                                         SnackBar(content: Text('Comment posted successfully!')),
                                                       );
                                                     }
                                                   },
                                                   style: ElevatedButton.styleFrom(
                                                     backgroundColor: const Color(0xFF611A04),
                                                     shape: RoundedRectangleBorder(
                                                       borderRadius: BorderRadius.circular(3),
                                                     ),
                                                   ),
                                                   child: Text(
                                                     'Comment',
                                                     style: TextStyle(
                                                       color: Colors.white,
                                                       fontFamily: 'Roboto',
                                                       fontSize: relWidth(14),
                                                       fontWeight: FontWeight.w600,
                                                     ),
                                                   ),
                                                 ),
                                               ),
                                               SizedBox(height: relHeight(15)),
                                             ],
                                           ),
                                         ),
                                       ),
                                     ),
                                   ),
                                 );
                               },
                               child: Container(
                                 width: relWidth(343),
                                 height: relHeight(32),
                                 decoration: BoxDecoration(
                                   color: Colors.white.withOpacity(0.8),
                                   borderRadius: BorderRadius.circular(23),
                                   border: Border.all(
                                     color: const Color(0xFF611A04),
                                     width: 1,
                                   ),
                                 ),
                                 child: Padding(
                                   padding: EdgeInsets.only(left: relWidth(15)),
                                   child: Align(
                                     alignment: Alignment.centerLeft,
                                     child: Text(
                                       'Write your comment here...',
                                       style: TextStyle(
                                         color: Color(0xFFD0D0D0),
                                         fontFamily: 'Roboto',
                                         fontSize: relWidth(16),
                                         fontStyle: FontStyle.normal,
                                         fontWeight: FontWeight.w700,
                                         height: 1.17182,
                                         letterSpacing: relWidth(0.32),
                                       ),
                                     ),
                                   ),
                                 ),
                               ),
                             ),
                           ),
                           SizedBox(height: relHeight(20)),
                                                       // First Comment
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: relWidth(18)),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: relHeight(5)),
                                    child: Image.asset(
                                      'assets/images/UserCircle.png',
                                      width: relWidth(39),
                                      height: relHeight(39),
                                    ),
                                  ),
                                 SizedBox(width: relWidth(10)),
                                 Expanded(
                                   child: Column(
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: [
                                       Container(
                                         width: relWidth(120),
                                         height: relHeight(22),
                                         child: Text(
                                           'Kanye West',
                                           style: TextStyle(
                                             color: Color(0xFF611A04).withOpacity(0.50),
                                             fontFamily: 'Roboto',
                                             fontSize: relWidth(20),
                                             fontStyle: FontStyle.italic,
                                             fontWeight: FontWeight.w400,
                                             height: 1.17182,
                                             letterSpacing: relWidth(0.4),
                                           ),
                                         ),
                                       ),
                                       SizedBox(height: relHeight(4)),
                                       Container(
                                         width: relWidth(293),
                                         child: Text(
                                           'Where do I avail this product?',
                                           style: TextStyle(
                                             color: Color(0xFF611A04),
                                             fontFamily: 'Roboto',
                                             fontSize: relWidth(15),
                                             fontStyle: FontStyle.normal,
                                             fontWeight: FontWeight.w400,
                                             height: 1.17182,
                                             letterSpacing: relWidth(0.3),
                                           ),
                                         ),
                                       ),
                                       SizedBox(height: relHeight(6)),
                                       if (!repliesExpanded) ...[
                                         Row(
                                           children: [
                                             Expanded(
                                               child: Container(
                                                 height: 1,
                                                 color: Color.fromRGBO(0, 0, 0, 0.22),
                                               ),
                                             ),
                                             SizedBox(width: relWidth(8)),
                                             GestureDetector(
                                               onTap: () {
                                                 setState(() {
                                                   repliesExpanded = !repliesExpanded;
                                                 });
                                               },
                                               child: Row(
                                                 mainAxisSize: MainAxisSize.min,
                                                 children: [
                                                   Text(
                                                     'View Replies',
                                                     style: TextStyle(
                                                       color: Color.fromRGBO(0, 0, 0, 0.22),
                                                       fontFamily: 'Roboto',
                                                       fontSize: relWidth(11),
                                                       fontStyle: FontStyle.normal,
                                                       fontWeight: FontWeight.w400,
                                                       height: 1.17182,
                                                       letterSpacing: relWidth(0.22),
                                                     ),
                                                   ),
                                                   SizedBox(width: relWidth(4)),
                                                   Icon(
                                                     Icons.keyboard_arrow_down,
                                                     color: Color.fromRGBO(0, 0, 0, 0.22),
                                                     size: relWidth(12),
                                                   ),
                                                 ],
                                               ),
                                             ),
                                           ],
                                         ),
                                       ],
                                       if (repliesExpanded) ...[
                                         SizedBox(height: relHeight(15)),
                                         // Reply 1
                                         Padding(
                                           padding: EdgeInsets.only(left: relWidth(42)),
                                           child: Row(
                                             crossAxisAlignment: CrossAxisAlignment.start,
                                             children: [
                                               Image.asset(
                                                 'assets/images/UserCircle.png',
                                                 width: relWidth(39),
                                                 height: relHeight(39),
                                               ),
                                               SizedBox(width: relWidth(10)),
                                               Expanded(
                                                 child: Column(
                                                   crossAxisAlignment: CrossAxisAlignment.start,
                                                   children: [
                                                     Container(
                                                       width: relWidth(150),
                                                       height: relHeight(22),
                                                       child: Text(
                                                         'Taylor Swift',
                                                         style: TextStyle(
                                                           color: Color(0xFF611A04).withOpacity(0.50),
                                                           fontFamily: 'Roboto',
                                                           fontSize: relWidth(20),
                                                           fontStyle: FontStyle.italic,
                                                           fontWeight: FontWeight.w400,
                                                           height: 1.17182,
                                                           letterSpacing: relWidth(0.4),
                                                         ),
                                                       ),
                                                     ),
                                                     SizedBox(height: relHeight(4)),
                                                     Container(
                                                       width: relWidth(293),
                                                       child: Text(
                                                         'Hi! Here is my number if you want to arrange a meetup! (+123456789)',
                                                         style: TextStyle(
                                                           color: Color(0xFF611A04),
                                                           fontFamily: 'Roboto',
                                                           fontSize: relWidth(15),
                                                           fontStyle: FontStyle.normal,
                                                           fontWeight: FontWeight.w400,
                                                           height: 1.17182,
                                                           letterSpacing: relWidth(0.3),
                                                         ),
                                                       ),
                                                     ),
                                                   ],
                                                 ),
                                               ),
                                             ],
                                           ),
                                         ),
                                         SizedBox(height: relHeight(15)),
                                         // Reply 2
                                         Padding(
                                           padding: EdgeInsets.only(left: relWidth(42)),
                                           child: Row(
                                             crossAxisAlignment: CrossAxisAlignment.start,
                                             children: [
                                               Image.asset(
                                                 'assets/images/UserCircle.png',
                                                 width: relWidth(39),
                                                 height: relHeight(39),
                                               ),
                                               SizedBox(width: relWidth(10)),
                                               Expanded(
                                                 child: Column(
                                                   crossAxisAlignment: CrossAxisAlignment.start,
                                                   children: [
                                                     Container(
                                                       width: relWidth(150),
                                                       height: relHeight(22),
                                                       child: Text(
                                                         'Kanye West',
                                                         style: TextStyle(
                                                           color: Color(0xFF611A04).withOpacity(0.50),
                                                           fontFamily: 'Roboto',
                                                           fontSize: relWidth(20),
                                                           fontStyle: FontStyle.italic,
                                                           fontWeight: FontWeight.w400,
                                                           height: 1.17182,
                                                           letterSpacing: relWidth(0.4),
                                                         ),
                                                       ),
                                                     ),
                                                     SizedBox(height: relHeight(4)),
                                                     Container(
                                                       width: relWidth(293),
                                                       child: Text(
                                                         'Thank you!',
                                                         style: TextStyle(
                                                           color: Color(0xFF611A04),
                                                           fontFamily: 'Roboto',
                                                           fontSize: relWidth(15),
                                                           fontStyle: FontStyle.normal,
                                                           fontWeight: FontWeight.w400,
                                                           height: 1.17182,
                                                           letterSpacing: relWidth(0.3),
                                                         ),
                                                       ),
                                                     ),
                                                   ],
                                                 ),
                                               ),
                                             ],
                                           ),
                                         ),
                                         SizedBox(height: relHeight(15)),
                                         // Hide Replies button at bottom
                                         Row(
                                           children: [
                                             Expanded(
                                               child: Container(
                                                 height: 1,
                                                 color: Color.fromRGBO(0, 0, 0, 0.22),
                                               ),
                                             ),
                                             SizedBox(width: relWidth(8)),
                                             GestureDetector(
                                               onTap: () {
                                                 setState(() {
                                                   repliesExpanded = !repliesExpanded;
                                                 });
                                               },
                                               child: Row(
                                                 mainAxisSize: MainAxisSize.min,
                                                 children: [
                                                   Text(
                                                     'Hide Replies',
                                                     style: TextStyle(
                                                       color: Color.fromRGBO(0, 0, 0, 0.22),
                                                       fontFamily: 'Roboto',
                                                       fontSize: relWidth(11),
                                                       fontStyle: FontStyle.normal,
                                                       fontWeight: FontWeight.w400,
                                                       height: 1.17182,
                                                       letterSpacing: relWidth(0.22),
                                                     ),
                                                   ),
                                                   SizedBox(width: relWidth(4)),
                                                   Icon(
                                                     Icons.keyboard_arrow_up,
                                                     color: Color.fromRGBO(0, 0, 0, 0.22),
                                                     size: relWidth(12),
                                                   ),
                                                 ],
                                               ),
                                             ),
                                           ],
                                         ),
                                       ],
                                     ],
                                   ),
                                 ),
                               ],
                             ),
                           ),
                           SizedBox(height: relHeight(20)),
                                                       // Second Comment
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: relWidth(18)),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: relHeight(5)),
                                    child: Image.asset(
                                      'assets/images/UserCircle.png',
                                      width: relWidth(39),
                                      height: relHeight(39),
                                    ),
                                  ),
                                 SizedBox(width: relWidth(10)),
                                 Expanded(
                                   child: Column(
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: [
                                       Container(
                                         width: relWidth(150),
                                         height: relHeight(22),
                                         child: Text(
                                           'Donald Trump',
                                           style: TextStyle(
                                             color: Color(0xFF611A04).withOpacity(0.50),
                                             fontFamily: 'Roboto',
                                             fontSize: relWidth(20),
                                             fontStyle: FontStyle.italic,
                                             fontWeight: FontWeight.w400,
                                             height: 1.17182,
                                             letterSpacing: relWidth(0.4),
                                           ),
                                         ),
                                       ),
                                       SizedBox(height: relHeight(4)),
                                       Container(
                                         width: relWidth(293),
                                         child: Text(
                                           'Which method of payment do you prefer?',
                                           style: TextStyle(
                                             color: Color(0xFF611A04),
                                             fontFamily: 'Roboto',
                                             fontSize: relWidth(15),
                                             fontStyle: FontStyle.normal,
                                             fontWeight: FontWeight.w400,
                                             height: 1.17182,
                                             letterSpacing: relWidth(0.3),
                                           ),
                                         ),
                                       ),
                                       SizedBox(height: relHeight(8)),
                                       Align(
                                         alignment: Alignment.centerRight,
                                         child: GestureDetector(
                                           onTap: () {
                                             final replyController = TextEditingController();
                                             showDialog(
                                               context: context,
                                               barrierDismissible: true,
                                               builder: (context) => Center(
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
                                                             'Post Reply',
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
                                                                 controller: replyController,
                                                                 maxLines: null,
                                                                 expands: true,
                                                                 decoration: const InputDecoration(
                                                                   hintText: 'Post your reply here...',
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
                                                               onPressed: () async {
                                                                 final text = replyController.text.trim();
                                                                 if (text.isNotEmpty) {
                                                                   // TODO: Implement reply posting functionality
                                                                   Navigator.of(context).pop();
                                                                   ScaffoldMessenger.of(context).showSnackBar(
                                                                     SnackBar(content: Text('Reply posted successfully!')),
                                                                   );
                                                                 }
                                                               },
                                                               style: ElevatedButton.styleFrom(
                                                                 backgroundColor: const Color(0xFF611A04),
                                                                 shape: RoundedRectangleBorder(
                                                                   borderRadius: BorderRadius.circular(3),
                                                                 ),
                                                               ),
                                                               child: Text(
                                                                 'Reply',
                                                                 style: TextStyle(
                                                                   color: Colors.white,
                                                                   fontFamily: 'Roboto',
                                                                   fontSize: relWidth(14),
                                                                   fontWeight: FontWeight.w600,
                                                                 ),
                                                               ),
                                                             ),
                                                           ),
                                                           SizedBox(height: relHeight(15)),
                                                         ],
                                                       ),
                                                     ),
                                                   ),
                                                 ),
                                               ),
                                             );
                                           },
                                           child: Row(
                                             mainAxisSize: MainAxisSize.min,
                                             children: [
                                               Text(
                                                 'Reply',
                                                 style: TextStyle(
                                                   color: Color(0xFF611A04),
                                                   fontFamily: 'Roboto',
                                                   fontSize: relWidth(14),
                                                   fontWeight: FontWeight.w400,
                                                 ),
                                               ),
                                               SizedBox(width: relWidth(4)),
                                               Icon(
                                                 Icons.keyboard_arrow_right,
                                                 color: Color(0xFF611A04),
                                                 size: relWidth(16),
                                               ),
                                             ],
                                           ),
                                         ),
                                       ),
                                     ],
                                   ),
                                 ),
                               ],
                             ),
                           ),
                         ],
                       ),
                     ),
                   ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: HomeFooter(
        relWidth: relWidth,
        relHeight: relHeight,
        onStoreTap: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomePage()),
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
        activeTab: '',
      ),
    );
  }
}
