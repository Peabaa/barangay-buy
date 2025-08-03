import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../controllers/product_description_controller.dart';
import 'home_header_footer.dart';

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
  final ProductDescriptionController _controller = ProductDescriptionController();
  
  bool _descExpanded = false;
  String selectedBarangay = '';
  bool isFavorite = false;
  Map<String, dynamic>? productDetails;
  bool isLoading = true;
  
  // Track reply visibility for each comment
  Map<String, bool> _repliesVisibility = {};

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    final data = await _controller.initializeData(widget.productId);
    if (mounted) {
      setState(() {
        selectedBarangay = data['barangay'];
        isFavorite = data['isFavorite'];
        productDetails = data['productDetails'];
        isLoading = false;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    final newStatus = await _controller.toggleFavorite(widget.productId, isFavorite);
    if (mounted) {
      setState(() {
        isFavorite = newStatus;
      });
    }
  }

  Future<void> _editProductName() async {
    final nameController = TextEditingController(text: widget.name);
    
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => _buildEditDialog(
        dialogContext,
        'Edit Product Name',
        nameController,
        'Enter product name...',
        80,
        false,
      ),
    );
    
    if (result == true) {
      final newName = nameController.text.trim();
      if (newName.isNotEmpty && newName != widget.name) {
        try {
          await _controller.updateProductField(widget.productId, 'productName', newName);
          if (mounted) {
            setState(() {
              productDetails?['productName'] = newName;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Product name updated successfully!')),
            );
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to update product name')),
            );
          }
        }
      }
    }
    
    nameController.dispose();
  }

  Future<void> _editProductDescription() async {
    final descController = TextEditingController(text: productDetails?['description'] ?? '');
    
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => _buildEditDialog(
        dialogContext,
        'Edit Description',
        descController,
        'Enter product description...',
        160,
        true,
      ),
    );
    
    if (result == true) {
      final newDescription = descController.text.trim();
      if (newDescription.isNotEmpty) {
        try {
          await _controller.updateProductField(widget.productId, 'description', newDescription);
          if (mounted) {
            setState(() {
              productDetails?['description'] = newDescription;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Description updated successfully!')),
            );
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to update description')),
            );
          }
        }
      }
    }
    
    descController.dispose();
  }

  Widget _buildEditDialog(
    BuildContext dialogContext,
    String title,
    TextEditingController controller,
    String hintText,
    double height,
    bool multiline,
  ) {
    final screenWidth = MediaQuery.of(dialogContext).size.width;
    final screenHeight = MediaQuery.of(dialogContext).size.height;
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
                  title,
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
                const Divider(
                  color: Color.fromRGBO(0, 0, 0, 0.22),
                  thickness: 1,
                ),
                SizedBox(height: relHeight(15)),
                Container(
                  width: relWidth(275),
                  height: relHeight(height),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(
                      color: const Color(0xFF611A04),
                      width: 2,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: relWidth(15),
                      vertical: relHeight(multiline ? 12 : 8),
                    ),
                    child: TextField(
                      controller: controller,
                      maxLines: multiline ? null : 1,
                      expands: multiline,
                      decoration: InputDecoration(
                        hintText: hintText,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: relWidth(16),
                        color: const Color(0xFF611A04),
                        fontWeight: FontWeight.w500,
                      ),
                      textAlignVertical: multiline ? TextAlignVertical.top : null,
                    ),
                  ),
                ),
                SizedBox(height: relHeight(15)),
                SizedBox(
                  width: relWidth(275),
                  height: relHeight(28),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop(true);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF611A04),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    child: Text(
                      'Save',
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double relWidth(double dp) => screenWidth * (dp / 412);
    double relHeight(double dp) => screenHeight * (dp / 915);

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final Uint8List? imageBytes = _controller.convertBase64ToBytes(widget.imageBase64);

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
                      onPressed: () => _controller.navigateBack(context),
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
                  // Product Image with Favorite Heart
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
                            : const Center(
                                child: Icon(Icons.image, size: 80, color: Colors.grey),
                              ),
                      ),
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
                  
                  // Product Info Container
                  Center(
                    child: Container(
                      width: relWidth(383),
                      decoration: BoxDecoration(
                        color: Colors.grey[300], 
                        borderRadius: BorderRadius.circular(3),
                        border: Border.all(
                          color: const Color.fromRGBO(0, 0, 0, 0.22),
                          width: 1,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              top: relHeight(7),
                              left: relWidth(15),
                              bottom: relHeight(7),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Product Name with Edit Icon
                                SizedBox(
                                  width: relWidth(230),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          productDetails?['productName'] ?? widget.name,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            color: const Color(0xFF611A04),
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
                                      if (_controller.isOwner(productDetails)) ...[
                                        SizedBox(width: relWidth(8)),
                                        GestureDetector(
                                          onTap: _editProductName,
                                          child: Icon(
                                            Icons.edit,
                                            color: const Color(0xFF611A04),
                                            size: relWidth(18),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                SizedBox(height: relHeight(10)),
                                
                                // Seller Info
                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/UserCircle.png',
                                      width: relWidth(32),
                                      height: relHeight(32),
                                    ),
                                    SizedBox(
                                      width: relWidth(120),
                                      height: relHeight(26),
                                      child: Center(
                                        child: Text(
                                          productDetails?['sellerName'] ?? '',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: const Color(0xFF611A04),
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
                                
                                // Category Badge
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: relWidth(12),
                                    vertical: relHeight(6),
                                  ),
                                  decoration: BoxDecoration(
                                    color: _controller.getCategoryColor(widget.category),
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
                            right: relWidth(10),
                            child: Container(
                              constraints: BoxConstraints(
                                minWidth: relWidth(70),
                                maxWidth: relWidth(150),
                              ),
                              height: relHeight(26),
                              child: Center(
                                child: Text(
                                  '₱${widget.price}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: const Color(0xFF611A04),
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
                      color: const Color(0xFF611A04),
                    ),
                  ),
                  SizedBox(height: relHeight(12)),
                  
                  // Description Section
                  _buildDescriptionSection(relWidth, relHeight),
                  
                  SizedBox(height: relHeight(12)),
                  Center(
                    child: Container(
                      width: relWidth(383),
                      height: 1,
                      color: const Color(0xFF611A04),
                    ),
                  ),
                  SizedBox(height: relHeight(12)),
                  
                  // Comments Section
                  _buildCommentsSection(relWidth, relHeight),
                  
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
        onStoreTap: () => _controller.navigateToHome(context),
        onAnnouncementTap: () => _controller.navigateToAnnouncements(context),
        onSellTap: () => _controller.navigateToSell(context),
        onProfileTap: () => _controller.navigateToProfile(context),
        activeTab: '',
      ),
    );
  }

  Widget _buildDescriptionSection(double Function(double) relWidth, double Function(double) relHeight) {
    return Center(
      child: StatefulBuilder(
        builder: (context, setDescState) {
          final String descText = productDetails?['description'] ?? 'No description available';
          const int maxLines = 3;
          final bool descExpanded = _descExpanded;
          
          final textSpan = TextSpan(
            text: descText,
            style: TextStyle(
              color: const Color(0xFF611A04),
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
              color: const Color(0xFFF3F2F2),
              borderRadius: BorderRadius.circular(3),
              border: Border.all(
                color: const Color.fromRGBO(0, 0, 0, 0.22),
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
                    right: relWidth(19),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Description',
                        style: TextStyle(
                          color: const Color(0xFF611A04),
                          fontFamily: 'Roboto',
                          fontSize: relWidth(22),
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w600,
                          height: 1.17182,
                          letterSpacing: relWidth(0.44),
                        ),
                      ),
                      if (_controller.isOwner(productDetails))
                        GestureDetector(
                          onTap: _editProductDescription,
                          child: Icon(
                            Icons.edit,
                            color: const Color(0xFF611A04),
                            size: relWidth(18),
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: relHeight(3)),
                Container(
                  width: relWidth(381),
                  height: 1,
                  color: const Color.fromRGBO(0, 0, 0, 0.22),
                ),
                SizedBox(height: relHeight(10)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: relWidth(19)),
                  child: SizedBox(
                    width: relWidth(350),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          descText,
                          style: TextStyle(
                            color: const Color(0xFF611A04),
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
                                      color: const Color(0xFF611A04),
                                      fontFamily: 'Roboto',
                                      fontSize: relWidth(14),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(width: relWidth(4)),
                                  Icon(
                                    descExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_right,
                                    color: const Color(0xFF611A04),
                                    size: relWidth(16),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: relHeight(10)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCommentsSection(double Function(double) relWidth, double Function(double) relHeight) {
    return Center(
      child: Container(
        width: relWidth(383),
        constraints: BoxConstraints(
          minHeight: relHeight(204),
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F2F2),
          borderRadius: BorderRadius.circular(3),
          border: Border.all(
            color: const Color.fromRGBO(0, 0, 0, 0.22),
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
                  color: const Color(0xFF611A04),
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
            
            // Comment Input
            Padding(
              padding: EdgeInsets.symmetric(horizontal: relWidth(18)),
              child: GestureDetector(
                onTap: () => _showCommentDialog(relWidth, relHeight),
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
                          color: const Color(0xFFD0D0D0),
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
            
            // Comments List
            StreamBuilder<QuerySnapshot>(
              stream: _controller.getCommentsStream(widget.productId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
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
                return Column(
                  children: comments.map((doc) => _buildCommentItem(doc, relWidth, relHeight)).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentItem(DocumentSnapshot doc, double Function(double) relWidth, double Function(double) relHeight) {
    final data = doc.data() as Map<String, dynamic>;
    final String commenter = data['username'] ?? 'Unknown';
    final String comment = data['comment'] ?? '';
    final String commentId = doc.id;
    final Timestamp? timestamp = data['timestamp'] as Timestamp?;
    final String commenterId = data['commenterId'] ?? '';
    
    return StatefulBuilder(
      builder: (context, setCommentState) {
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
                    // Comment Header
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                commenter,
                                style: TextStyle(
                                  color: const Color(0xFF611A04).withOpacity(0.50),
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
                                _controller.formatTimestamp(timestamp),
                                style: TextStyle(
                                  color: const Color(0xFF888888),
                                  fontFamily: 'Roboto',
                                  fontSize: relWidth(12),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (_controller.isOwnComment(commenterId))
                          GestureDetector(
                            onTap: () => _showDeleteCommentDialog(commentId, relWidth, relHeight),
                            child: Padding(
                              padding: EdgeInsets.only(left: relWidth(8)),
                              child: const Icon(Icons.delete, color: Colors.red, size: 20),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: relHeight(4)),
                    
                    // Comment Text
                    SizedBox(
                      width: relWidth(293),
                      child: Text(
                        comment,
                        style: TextStyle(
                          color: const Color(0xFF611A04),
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
                    
                    // Replies Section
                    _buildRepliesSection(doc, commenterId, relWidth, relHeight),
                    
                    // Reply Button
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () => _showReplyDialog(commentId, commenterId, relWidth, relHeight),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Reply',
                              style: TextStyle(
                                color: const Color(0xFF611A04),
                                fontFamily: 'Roboto',
                                fontSize: relWidth(14),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(width: relWidth(4)),
                            Icon(
                              Icons.keyboard_arrow_right,
                              color: const Color(0xFF611A04),
                              size: relWidth(16),
                            ),
                          ],
                        ),
                      ),
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
  }

  Widget _buildRepliesSection(DocumentSnapshot commentDoc, String commenterId, double Function(double) relWidth, double Function(double) relHeight) {
    return StreamBuilder<QuerySnapshot>(
      stream: _controller.getRepliesStream(widget.productId, commentDoc.id),
      builder: (context, replySnapshot) {
        if (replySnapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox();
        }
        
        final replies = replySnapshot.data?.docs ?? [];
        if (replies.isEmpty) return const SizedBox();
        
        final commentId = commentDoc.id;
        final showReplies = _repliesVisibility[commentId] ?? false;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Toggle Replies Button
            GestureDetector(
              onTap: () {
                setState(() {
                  _repliesVisibility[commentId] = !showReplies;
                });
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: relWidth(60),
                    height: 1,
                    color: const Color(0xFF888888),
                  ),
                  SizedBox(width: relWidth(8)),
                  Text(
                    showReplies ? 'Hide Replies' : 'View Replies',
                    style: TextStyle(
                      color: const Color(0xFF888888),
                      fontFamily: 'Roboto',
                      fontSize: relWidth(14),
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(width: relWidth(4)),
                  Icon(
                    showReplies ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: const Color(0xFF888888),
                    size: relWidth(14),
                  ),
                ],
              ),
            ),
            
            // Replies List
            if (showReplies) ...[
              ...replies.map((replyDoc) => _buildReplyItem(
                replyDoc,
                commentDoc.id,
                relWidth,
                relHeight,
              )),
              SizedBox(height: relHeight(8)),
            ],
          ],
        );
      },
    );
  }

  Widget _buildReplyItem(DocumentSnapshot replyDoc, String commentId, double Function(double) relWidth, double Function(double) relHeight) {
    final replyData = replyDoc.data() as Map<String, dynamic>;
    final String replyUser = replyData['username'] ?? 'Unknown';
    final String replyText = replyData['reply'] ?? '';
    final String replyId = replyDoc.id;
    final Timestamp? replyTimestamp = replyData['timestamp'] as Timestamp?;
    final String replyCommenterId = replyData['commenterId'] ?? '';
    
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
                // Reply Header
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            replyUser,
                            style: TextStyle(
                              color: const Color(0xFF611A04).withOpacity(0.50),
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
                            _controller.formatTimestamp(replyTimestamp),
                            style: TextStyle(
                              color: const Color(0xFF888888),
                              fontFamily: 'Roboto',
                              fontSize: relWidth(12),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_controller.isOwnComment(replyCommenterId))
                      GestureDetector(
                        onTap: () => _showDeleteReplyDialog(commentId, replyId, relWidth, relHeight),
                        child: Padding(
                          padding: EdgeInsets.only(left: relWidth(8)),
                          child: const Icon(Icons.delete, color: Colors.red, size: 20),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: relHeight(4)),
                
                // Reply Text
                SizedBox(
                  width: relWidth(293),
                  child: Text(
                    replyText,
                    style: TextStyle(
                      color: const Color(0xFF611A04),
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
  }

  void _showCommentDialog(double Function(double) relWidth, double Function(double) relHeight) {
    final commentController = TextEditingController();
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => _buildCommentReplyDialog(
        context,
        'Write Comment',
        commentController,
        'Write your comment here...',
        'Comment',
        () async {
          final text = commentController.text.trim();
          if (text.isNotEmpty) {
            try {
              await _controller.addComment(widget.productId, text);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Comment posted successfully!')),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Failed to post comment')),
              );
            }
          }
        },
        relWidth,
        relHeight,
      ),
    );
  }

  void _showReplyDialog(String commentId, String originalCommenterId, double Function(double) relWidth, double Function(double) relHeight) {
    final replyController = TextEditingController();
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => _buildCommentReplyDialog(
        context,
        'Post Reply',
        replyController,
        'Post your reply here...',
        'Reply',
        () async {
          final text = replyController.text.trim();
          if (text.isNotEmpty) {
            try {
              await _controller.addReply(widget.productId, commentId, text, originalCommenterId);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Reply posted successfully!')),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Failed to post reply')),
              );
            }
          }
        },
        relWidth,
        relHeight,
      ),
    );
  }

  Widget _buildCommentReplyDialog(
    BuildContext context,
    String title,
    TextEditingController controller,
    String hintText,
    String buttonText,
    VoidCallback onPressed,
    double Function(double) relWidth,
    double Function(double) relHeight,
  ) {
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
                  title,
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
                const Divider(
                  color: Color.fromRGBO(0, 0, 0, 0.22),
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
                      controller: controller,
                      maxLines: null,
                      expands: true,
                      decoration: InputDecoration(
                        hintText: hintText,
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
                    onPressed: onPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF611A04),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    child: Text(
                      buttonText,
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
    );
  }

  void _showDeleteCommentDialog(String commentId, double Function(double) relWidth, double Function(double) relHeight) {
    _showDeleteDialog(
      'Delete Comment',
      'Do you want to delete this comment?',
      () async {
        try {
          await _controller.deleteComment(widget.productId, commentId);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Comment deleted successfully!')),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to delete comment')),
          );
        }
      },
      relWidth,
      relHeight,
    );
  }

  void _showDeleteReplyDialog(String commentId, String replyId, double Function(double) relWidth, double Function(double) relHeight) {
    _showDeleteDialog(
      'Delete Reply',
      'Do you want to delete this reply?',
      () async {
        try {
          await _controller.deleteReply(widget.productId, commentId, replyId);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Reply deleted successfully!')),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to delete reply')),
          );
        }
      },
      relWidth,
      relHeight,
    );
  }

  void _showDeleteDialog(
    String title,
    String message,
    VoidCallback onConfirm,
    double Function(double) relWidth,
    double Function(double) relHeight,
  ) {
    showDialog(
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
                    title,
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
                    message,
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
  }
}
