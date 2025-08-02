import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
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
  bool _descExpanded = false;
  String selectedBarangay = '';
  bool isFavorite = false;
  String? userId;
  Map<String, dynamic>? productDetails;
  bool repliesExpanded = false;

  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return '';
    final DateTime dateTime = timestamp.toDate();
    final Duration difference = DateTime.now().difference(dateTime);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d, yyyy').format(dateTime);
    }
  }

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
    if (isFavorite) {
      await userRef.update({
        'favorites': FieldValue.arrayRemove([widget.productId])
      });
    } else {
      await userRef.set({
        'favorites': FieldValue.arrayUnion([widget.productId])
      }, SetOptions(merge: true));
      
      // Create favorite notification for the product owner
      await _createFavoriteNotification();
    }
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  Future<void> _createFavoriteNotification() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      // Get current user's username
      final currentUserDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      final currentUsername = currentUserDoc.data()?['username'] ?? 'Someone';

      // Get product details to find the seller
      final productDoc = await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.productId)
          .get();
      
      if (productDoc.exists) {
        final productData = productDoc.data()!;
        final sellerId = productData['sellerId'];
        final productName = productData['productName'] ?? 'your product';
        
        // Don't create notification if user is favoriting their own product
        if (sellerId != user.uid) {
          await FirebaseFirestore.instance.collection('notifications').add({
            'userId': sellerId,
            'type': 'favorite',
            'username': currentUsername,
            'productName': productName,
            'comment': '',
            'reply': '',
            'title': '',
            'timestamp': FieldValue.serverTimestamp(),
            'read': false,
          });
        }
      }
    } catch (e) {
      print('Error creating favorite notification: $e');
    }
  }

  Future<void> _createCommentNotification(String commenterUsername, String commentText) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      // Get product details to find the seller
      final productDoc = await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.productId)
          .get();
      
      if (productDoc.exists) {
        final productData = productDoc.data()!;
        final sellerId = productData['sellerId'];
        final productName = productData['productName'] ?? 'your product';
        
        // Don't create notification if user is commenting on their own product
        if (sellerId != user.uid) {
          await FirebaseFirestore.instance.collection('notifications').add({
            'userId': sellerId,
            'type': 'comment',
            'username': commenterUsername,
            'productName': productName,
            'comment': commentText,
            'reply': '',
            'title': '',
            'timestamp': FieldValue.serverTimestamp(),
            'read': false,
          });
        }
      }
    } catch (e) {
      print('Error creating comment notification: $e');
    }
  }

  Future<void> _createReplyNotification(String replierUsername, String replyText, DocumentSnapshot commentDoc) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      // Get the original commenter's ID from the comment document
      final commentData = commentDoc.data() as Map<String, dynamic>;
      final originalCommenterId = commentData['commenterId'];
      
      // Get product details
      final productDoc = await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.productId)
          .get();
      
      if (productDoc.exists && originalCommenterId != null) {
        final productData = productDoc.data()!;
        final productName = productData['productName'] ?? 'a product';
        
        // Don't create notification if user is replying to their own comment
        if (originalCommenterId != user.uid) {
          await FirebaseFirestore.instance.collection('notifications').add({
            'userId': originalCommenterId,
            'type': 'reply',
            'username': replierUsername,
            'productName': productName,
            'comment': '',
            'reply': replyText,
            'title': '',
            'timestamp': FieldValue.serverTimestamp(),
            'read': false,
          });
        }
      }
    } catch (e) {
      print('Error creating reply notification: $e');
    }
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
                  Positioned(
                    left: 0,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
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
                            padding: EdgeInsets.only(top: relHeight(7), left: relWidth(15), bottom: relHeight(7)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: relWidth(230),
                                  child: Text(
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
                                    softWrap: true,
                                  ),
                                ),
                                SizedBox(height: relHeight(10)),
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
                                SizedBox(height: relHeight(10)),
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
                    child: StatefulBuilder(
                      builder: (context, setDescState) {
                        final String descText = productDetails?['description'] ?? 'No description available';
                        final int maxLines = 3;
                        bool descExpanded = _descExpanded;
                        final textSpan = TextSpan(
                          text: descText,
                          style: TextStyle(
                            color: Color(0xFF611A04),
                            fontFamily: 'Roboto',
                            fontSize: relWidth(18),
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w400,
                            height: 1.17176,
                            letterSpacing: relWidth(0.36),
                          ),
                        );
                        final tp = TextPainter(
                          text: textSpan,
                          maxLines: maxLines,
                          textDirection: ui.TextDirection.ltr,
                        );
                        tp.layout(maxWidth: relWidth(350));
                        final bool isOverflowing = tp.didExceedMaxLines;
                        return Container(
                          width: relWidth(383),
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
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        descText,
                                        style: TextStyle(
                                          color: Color(0xFF611A04),
                                          fontFamily: 'Roboto',
                                          fontSize: relWidth(18),
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w400,
                                          height: 1.17176,
                                          letterSpacing: relWidth(0.36),
                                        ),
                                        maxLines: descExpanded ? null : maxLines,
                                        overflow: descExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                                      ),
                                      if (isOverflowing || descExpanded)
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: GestureDetector(
                                            onTap: () {
                                              setDescState(() {
                                                _descExpanded = !descExpanded;
                                              });
                                            },
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  descExpanded ? 'See less' : 'See more',
                                                  style: TextStyle(
                                                    color: Color(0xFF611A04),
                                                    fontFamily: 'Roboto',
                                                    fontSize: relWidth(14),
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                SizedBox(width: relWidth(4)),
                                                Icon(
                                                  descExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_right,
                                                  color: Color(0xFF611A04),
                                                  size: relWidth(16),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: relHeight(10)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
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
                                                       final user = FirebaseAuth.instance.currentUser;
                                                       String username = 'Unknown';
                                                       String commenterId = '';
                                                       if (user != null) {
                                                         commenterId = user.uid;
                                                         final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
                                                         username = userDoc.data()?['username'] ?? user.email ?? 'Unknown';
                                                       }
                                                       await FirebaseFirestore.instance
                                                         .collection('products')
                                                         .doc(widget.productId)
                                                         .collection('comments')
                                                         .add({
                                                           'username': username,
                                                           'comment': text,
                                                           'commenterId': commenterId,
                                                           'timestamp': FieldValue.serverTimestamp(),
                                                         });
                                                       
                                                       // Create comment notification for the product owner
                                                       await _createCommentNotification(username, text);
                                                       
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
                           SizedBox(height: relHeight(12)),
                           StreamBuilder<QuerySnapshot>(
                             stream: FirebaseFirestore.instance
                                 .collection('products')
                                 .doc(widget.productId)
                                 .collection('comments')
                                 .orderBy('timestamp', descending: false)
                                 .snapshots(),
                             builder: (context, snapshot) {
                               if (snapshot.connectionState == ConnectionState.waiting) {
                                 return Center(child: CircularProgressIndicator());
                               }
                               if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                                 return Center(
                                   child: Text(
                                     '--- No Available Comments. ---',
                                     style: TextStyle(
                                       fontFamily: 'RobotoCondensed',
                                       fontSize: relWidth(20),
                                       fontWeight: FontWeight.w500,
                                       color: const Color(0x88888888),
                                     ),
                                     textAlign: TextAlign.center,
                                   ),
                                 );
                               }
                               final comments = snapshot.data!.docs;
                               final Map<String, bool> repliesExpandedMap = {};
                               return Column(
                                 children: comments.map((doc) {
                                   final data = doc.data() as Map<String, dynamic>;
                                   final String commenter = data['username'] ?? 'Unknown';
                                   final String comment = data['comment'] ?? '';
                                   final String commentId = doc.id;
                                   final Timestamp? timestamp = data['timestamp'] as Timestamp?;
                                   return StatefulBuilder(
                                     builder: (context, setCommentState) {
                                       final showReplies = repliesExpandedMap[commentId] ?? false;
                                       final currentUser = FirebaseAuth.instance.currentUser;
                                       final isOwnComment = currentUser != null && data['commenterId'] == currentUser.uid;
                                       return Padding(
                                         padding: EdgeInsets.symmetric(vertical: relHeight(10), horizontal: relWidth(18)),
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
                                                   Row(
                                                     children: [
                                                       Expanded(
                                                         child: Column(
                                                           crossAxisAlignment: CrossAxisAlignment.start,
                                                           children: [
                                                             Text(
                                                               commenter,
                                                               style: TextStyle(
                                                                 color: Color(0xFF611A04).withOpacity(0.50),
                                                                 fontFamily: 'Roboto',
                                                                 fontSize: relWidth(20),
                                                                 fontStyle: FontStyle.italic,
                                                                 fontWeight: FontWeight.w400,
                                                                 height: 1.17182,
                                                                 letterSpacing: relWidth(0.4),
                                                               ),
                                                               overflow: TextOverflow.ellipsis,
                                                             ),
                                                             Text(
                                                               _formatTimestamp(timestamp),
                                                               style: TextStyle(
                                                                 color: Color(0xFF888888),
                                                                 fontFamily: 'Roboto',
                                                                 fontSize: relWidth(12),
                                                                 fontWeight: FontWeight.w400,
                                                               ),
                                                             ),
                                                           ],
                                                         ),
                                                       ),
                                                       if (isOwnComment)
                                                         GestureDetector(
                                                           onTap: () async {
                                                             final confirm = await showDialog<bool>(
                                                               context: context,
                                                               barrierDismissible: true,
                                                               builder: (context) => Center(
                                                                 child: Material(
                                                                   color: Colors.transparent,
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
                                                                             'Delete Comment',
                                                                             textAlign: TextAlign.center,
                                                                             style: TextStyle(
                                                                               color: const Color(0xFF611A04),
                                                                               fontFamily: 'Roboto',
                                                                               fontSize: relWidth(18),
                                                                               fontWeight: FontWeight.w700,
                                                                               fontStyle: FontStyle.normal,
                                                                               height: 1.17182,
                                                                               letterSpacing: 0.32,
                                                                               decoration: TextDecoration.none,
                                                                             ),
                                                                           ),
                                                                         ),
                                                                         Divider(
                                                                           thickness: 1,
                                                                           height: relHeight(16),
                                                                         ),
                                                                         Container(
                                                                           width: relWidth(232),
                                                                           height: relHeight(81),
                                                                           alignment: Alignment.center,
                                                                           child: Text(
                                                                             'Do you want to delete this comment?',
                                                                             textAlign: TextAlign.center,
                                                                             style: TextStyle(
                                                                               color: const Color(0xFF611A04),
                                                                               fontFamily: 'Roboto',
                                                                               fontSize: relWidth(20),
                                                                               fontWeight: FontWeight.w700,
                                                                               fontStyle: FontStyle.normal,
                                                                               height: 1.17182,
                                                                               letterSpacing: 0.4,
                                                                               decoration: TextDecoration.none,
                                                                             ),
                                                                           ),
                                                                         ),
                                                                         SizedBox(height: relHeight(15)),
                                                                         Row(
                                                                           mainAxisAlignment: MainAxisAlignment.center,
                                                                           children: [
                                                                             GestureDetector(
                                                                               onTap: () {
                                                                                 Navigator.of(context).pop(false);
                                                                               },
                                                                               child: Container(
                                                                                 width: relWidth(90),
                                                                                 height: relHeight(28),
                                                                                 decoration: BoxDecoration(
                                                                                   color: Colors.grey[300],
                                                                                   borderRadius: BorderRadius.circular(relWidth(3)),
                                                                                   border: Border.all(
                                                                                     color: const Color(0xFF611A04),
                                                                                     width: 1,
                                                                                   ),
                                                                                 ),
                                                                                 alignment: Alignment.center,
                                                                                 child: Text(
                                                                                   'Cancel',
                                                                                   style: TextStyle(
                                                                                     color: const Color(0xFF611A04),
                                                                                     fontFamily: 'Roboto',
                                                                                     fontWeight: FontWeight.w700,
                                                                                     fontSize: relWidth(16),
                                                                                     decoration: TextDecoration.none,
                                                                                   ),
                                                                                 ),
                                                                               ),
                                                                             ),
                                                                             SizedBox(width: relWidth(16)),
                                                                             GestureDetector(
                                                                               onTap: () {
                                                                                 Navigator.of(context).pop(true);
                                                                               },
                                                                               child: Container(
                                                                                 width: relWidth(90),
                                                                                 height: relHeight(28),
                                                                                 decoration: BoxDecoration(
                                                                                   color: Colors.red.withOpacity(0.8),
                                                                                   borderRadius: BorderRadius.circular(relWidth(3)),
                                                                                   border: Border.all(
                                                                                     color: Colors.red,
                                                                                     width: 1,
                                                                                   ),
                                                                                 ),
                                                                                 alignment: Alignment.center,
                                                                                 child: Text(
                                                                                   'Delete',
                                                                                   style: TextStyle(
                                                                                     color: Colors.white,
                                                                                     fontFamily: 'Roboto',
                                                                                     fontWeight: FontWeight.w700,
                                                                                     fontSize: relWidth(16),
                                                                                     decoration: TextDecoration.none,
                                                                                   ),
                                                                                 ),
                                                                               ),
                                                                             ),
                                                                           ],
                                                                         ),
                                                                       ],
                                                                     ),
                                                                   ),
                                                                 ),
                                                                ),
                                                               );
                                                             if (confirm == true) {
                                                               await FirebaseFirestore.instance
                                                                 .collection('products')
                                                                 .doc(widget.productId)
                                                                 .collection('comments')
                                                                 .doc(doc.id)
                                                                 .delete();
                                                               ScaffoldMessenger.of(context).showSnackBar(
                                                                 SnackBar(content: Text('Comment deleted successfully!')),
                                                               );
                                                             }
                                                           },
                                                           child: Padding(
                                                             padding: EdgeInsets.only(left: relWidth(8)),
                                                             child: Icon(Icons.delete, color: Colors.red, size: 20),
                                                           ),
                                                         ),
                                                     ],
                                                   ),
                                                   SizedBox(height: relHeight(4)),
                                                   Container(
                                                     width: relWidth(293),
                                                     child: Text(
                                                       comment,
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
                                                   StreamBuilder<QuerySnapshot>(
                                                     stream: doc.reference.collection('replies').orderBy('timestamp', descending: false).snapshots(),
                                                     builder: (context, replySnapshot) {
                                                       if (replySnapshot.connectionState == ConnectionState.waiting) {
                                                         return SizedBox();
                                                       }
                                                       final replies = replySnapshot.data?.docs ?? [];
                                                       final hasReplies = replies.isNotEmpty;
                                                       
                                                       return Column(
                                                         crossAxisAlignment: CrossAxisAlignment.start,
                                                         children: [
                                                           if (hasReplies) 
                                                             GestureDetector(
                                                               onTap: () {
                                                                 setCommentState(() {
                                                                   repliesExpandedMap[commentId] = !(repliesExpandedMap[commentId] ?? false);
                                                                 });
                                                               },
                                                               child: Row(
                                                                 mainAxisSize: MainAxisSize.min,
                                                                 children: [
                                                                   Container(
                                                                     width: relWidth(60),
                                                                     height: 1,
                                                                     color: Color(0xFF888888),
                                                                   ),
                                                                   SizedBox(width: relWidth(8)),
                                                                   Text(
                                                                     showReplies ? 'Hide Replies' : 'View Replies',
                                                                     style: TextStyle(
                                                                       color: Color(0xFF888888),
                                                                       fontFamily: 'Roboto',
                                                                       fontSize: relWidth(14),
                                                                       fontWeight: FontWeight.w400,
                                                                       fontStyle: FontStyle.italic,
                                                                     ),
                                                                   ),
                                                                   SizedBox(width: relWidth(4)),
                                                                   Icon(
                                                                     showReplies ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                                                     color: Color(0xFF888888),
                                                                     size: relWidth(14),
                                                                   ),
                                                                 ],
                                                               ),
                                                             ),
                                                           if (hasReplies && showReplies) ...[
                                                             ...replies.map((replyDoc) {
                                                               final replyData = replyDoc.data() as Map<String, dynamic>;
                                                               final String replyUser = replyData['username'] ?? 'Unknown';
                                                               final String replyText = replyData['reply'] ?? '';
                                                               final String replyId = replyDoc.id;
                                                               final Timestamp? replyTimestamp = replyData['timestamp'] as Timestamp?;
                                                               final currentUser = FirebaseAuth.instance.currentUser;
                                                               final isOwnReply = currentUser != null && replyData['commenterId'] == currentUser.uid;
                                                               return Padding(
                                                                 padding: EdgeInsets.only(left: relWidth(42), top: relHeight(8)),
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
                                                                           Row(
                                                                             children: [
                                                                               Expanded(
                                                                                 child: Column(
                                                                                   crossAxisAlignment: CrossAxisAlignment.start,
                                                                                   children: [
                                                                                     Text(
                                                                                       replyUser,
                                                                                       style: TextStyle(
                                                                                         color: Color(0xFF611A04).withOpacity(0.50),
                                                                                         fontFamily: 'Roboto',
                                                                                         fontSize: relWidth(20),
                                                                                         fontStyle: FontStyle.italic,
                                                                                         fontWeight: FontWeight.w400,
                                                                                         height: 1.17182,
                                                                                         letterSpacing: relWidth(0.4),
                                                                                       ),
                                                                                       overflow: TextOverflow.ellipsis,
                                                                                     ),
                                                                                     Text(
                                                                                       _formatTimestamp(replyTimestamp),
                                                                                       style: TextStyle(
                                                                                         color: Color(0xFF888888),
                                                                                         fontFamily: 'Roboto',
                                                                                         fontSize: relWidth(12),
                                                                                         fontWeight: FontWeight.w400,
                                                                                       ),
                                                                                     ),
                                                                                   ],
                                                                                 ),
                                                                               ),
                                                                               if (isOwnReply)
                                                                                 GestureDetector(
                                                                                   onTap: () async {
                                                                                     final confirm = await showDialog<bool>(
                                                                                       context: context,
                                                                                       barrierDismissible: true,
                                                                                       builder: (context) => Center(
                                                                                         child: Material(
                                                                                           color: Colors.transparent,
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
                                                                                                     'Delete Reply',
                                                                                                     textAlign: TextAlign.center,
                                                                                                     style: TextStyle(
                                                                                                       color: const Color(0xFF611A04),
                                                                                                       fontFamily: 'Roboto',
                                                                                                       fontSize: relWidth(18),
                                                                                                       fontWeight: FontWeight.w700,
                                                                                                       fontStyle: FontStyle.normal,
                                                                                                       height: 1.17182,
                                                                                                       letterSpacing: 0.32,
                                                                                                       decoration: TextDecoration.none,
                                                                                                     ),
                                                                                                   ),
                                                                                                 ),
                                                                                                 Divider(
                                                                                                   thickness: 1,
                                                                                                   height: relHeight(16),
                                                                                                 ),
                                                                                                 Container(
                                                                                                   width: relWidth(232),
                                                                                                   height: relHeight(81),
                                                                                                   alignment: Alignment.center,
                                                                                                   child: Text(
                                                                                                     'Do you want to delete this reply?',
                                                                                                     textAlign: TextAlign.center,
                                                                                                     style: TextStyle(
                                                                                                       color: const Color(0xFF611A04),
                                                                                                       fontFamily: 'Roboto',
                                                                                                       fontSize: relWidth(20),
                                                                                                       fontWeight: FontWeight.w700,
                                                                                                       fontStyle: FontStyle.normal,
                                                                                                       height: 1.17182,
                                                                                                       letterSpacing: 0.4,
                                                                                                       decoration: TextDecoration.none,
                                                                                                     ),
                                                                                                   ),
                                                                                                 ),
                                                                                                 SizedBox(height: relHeight(15)),
                                                                                                 Row(
                                                                                                   mainAxisAlignment: MainAxisAlignment.center,
                                                                                                   children: [
                                                                                                     GestureDetector(
                                                                                                       onTap: () {
                                                                                                         Navigator.of(context).pop(false);
                                                                                                       },
                                                                                                       child: Container(
                                                                                                         width: relWidth(90),
                                                                                                         height: relHeight(28),
                                                                                                         decoration: BoxDecoration(
                                                                                                           color: Colors.grey[300],
                                                                                                           borderRadius: BorderRadius.circular(relWidth(3)),
                                                                                                           border: Border.all(
                                                                                                             color: const Color(0xFF611A04),
                                                                                                             width: 1,
                                                                                                           ),
                                                                                                         ),
                                                                                                         alignment: Alignment.center,
                                                                                                         child: Text(
                                                                                                           'Cancel',
                                                                                                           style: TextStyle(
                                                                                                             color: const Color(0xFF611A04),
                                                                                                             fontFamily: 'Roboto',
                                                                                                             fontWeight: FontWeight.w700,
                                                                                                             fontSize: relWidth(16),
                                                                                                             decoration: TextDecoration.none,
                                                                                                           ),
                                                                                                         ),
                                                                                                       ),
                                                                                                     ),
                                                                                                     SizedBox(width: relWidth(16)),
                                                                                                     GestureDetector(
                                                                                                       onTap: () {
                                                                                                         Navigator.of(context).pop(true);
                                                                                                       },
                                                                                                       child: Container(
                                                                                                         width: relWidth(90),
                                                                                                         height: relHeight(28),
                                                                                                         decoration: BoxDecoration(
                                                                                                           color: Colors.red.withOpacity(0.8),
                                                                                                           borderRadius: BorderRadius.circular(relWidth(3)),
                                                                                                           border: Border.all(
                                                                                                             color: Colors.red,
                                                                                                             width: 1,
                                                                                                           ),
                                                                                                         ),
                                                                                                         alignment: Alignment.center,
                                                                                                         child: Text(
                                                                                                           'Delete',
                                                                                                           style: TextStyle(
                                                                                                             color: Colors.white,
                                                                                                             fontFamily: 'Roboto',
                                                                                                             fontWeight: FontWeight.w700,
                                                                                                             fontSize: relWidth(16),
                                                                                                             decoration: TextDecoration.none,
                                                                                                           ),
                                                                                                         ),
                                                                                                       ),
                                                                                                     ),
                                                                                                   ],
                                                                                                 ),
                                                                                               ],
                                                                                             ),
                                                                                           ),
                                                                                         ),
                                                                                        ),
                                                                                       );
                                                                                     if (confirm == true) {
                                                                                       await doc.reference.collection('replies').doc(replyId).delete();
                                                                                       ScaffoldMessenger.of(context).showSnackBar(
                                                                                         SnackBar(content: Text('Reply deleted successfully!')),
                                                                                       );
                                                                                     }
                                                                                   },
                                                                                   child: Padding(
                                                                                     padding: EdgeInsets.only(left: relWidth(8)),
                                                                                     child: Icon(Icons.delete, color: Colors.red, size: 20),
                                                                                   ),
                                                                                 ),
                                                                             ],
                                                                           ),
                                                                           SizedBox(height: relHeight(4)),
                                                                           Container(
                                                                             width: relWidth(293),
                                                                             child: Text(
                                                                               replyText,
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
                                                               );
                                                             }),
                                                             SizedBox(height: relHeight(8)),
                                                           ],
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
                                                                                       final user = FirebaseAuth.instance.currentUser;
                                                                                       String username = 'Unknown';
                                                                                       String commenterId = '';
                                                                                       if (user != null) {
                                                                                         commenterId = user.uid;
                                                                                         final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
                                                                                         username = userDoc.data()?['username'] ?? user.email ?? 'Unknown';
                                                                                       }
                                                                                       await doc.reference.collection('replies').add({
                                                                                         'username': username,
                                                                                         'reply': text,
                                                                                         'commenterId': commenterId,
                                                                                         'timestamp': FieldValue.serverTimestamp(),
                                                                                       });
                                                                                       
                                                                                       // Create reply notification for the original commenter
                                                                                       await _createReplyNotification(username, text, doc);
                                                                                       
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
                                                       );
                                                     },
                                                   ),
                                                   SizedBox(height: relHeight(12)),
                                                 ],
                                               ),
                                             ),
                                           ],
                                         ),
                                       );
                                     },
                                   );
                                 }).toList(),
                               );
                             },
                           ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: relHeight(24)),
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
