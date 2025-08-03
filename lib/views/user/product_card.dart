import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../controllers/product_card_controller.dart';

class ProductCard extends StatefulWidget {
  final String imageBase64;
  final String name;
  final String price;
  final String category;
  final String sold;
  final String productId;

  const ProductCard({
    super.key,
    required this.imageBase64,
    required this.name,
    required this.price,
    required this.category,
    required this.sold,
    required this.productId,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  final ProductCardController _controller = ProductCardController();
  bool isFavorite = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  Future<void> _loadFavoriteStatus() async {
    final favoriteStatus = await _controller.loadFavoriteStatus(widget.productId);
    if (mounted) {
      setState(() {
        isFavorite = favoriteStatus;
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

  @override
  Widget build(BuildContext context) {
    final Uint8List? imageBytes = _controller.convertBase64ToBytes(widget.imageBase64);

    return GestureDetector(
      onTap: () {
        _controller.navigateToProductDescription(
          context,
          widget.productId,
          widget.imageBase64,
          widget.name,
          widget.price,
          widget.category,
          widget.sold,
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: Container(
          constraints: const BoxConstraints(
            maxHeight: 160,
            maxWidth: double.infinity,
          ),
          padding: const EdgeInsets.all(4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Image container with fixed height
              Container(
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[200],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: imageBytes != null
                      ? Image.memory(
                          imageBytes,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        )
                      : const Center(
                          child: Icon(Icons.image, size: 30, color: Colors.grey),
                        ),
                ),
              ),
              const SizedBox(height: 4),
              // Product name with better constraints
              Flexible(
                child: Text(
                  widget.name,
                  style: const TextStyle(
                    fontFamily: 'RobotoCondensed',
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 2),
              // Price and favorite row
              Row(
                children: [
                  Flexible(
                    child: Text(
                      '₱ ${widget.price}',
                      style: const TextStyle(
                        fontFamily: 'RobotoCondensed',
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Color(0xFFD84315),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 4),
                  if (!isLoading)
                    GestureDetector(
                      onTap: _toggleFavorite,
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.red.withOpacity(0.5),
                        size: 16,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              // Category and seller row
              Row(
                children: [
                  // Category container 
                  Container(
                    constraints: const BoxConstraints(
                      minWidth: 25,
                      maxWidth: 60,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      color: _controller.getCategoryColor(widget.category),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 1,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        widget.category,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 7,
                          fontWeight: FontWeight.w600,
                          height: 1.1,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  // Seller name 
                  Expanded(
                    child: FutureBuilder<String>(
                      future: _controller.getSellerName(widget.productId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const SizedBox(
                            height: 12,
                            child: Center(
                              child: SizedBox(
                                width: 8,
                                height: 8,
                                child: CircularProgressIndicator(strokeWidth: 1),
                              ),
                            ),
                          );
                        }
                        
                        final sellerName = snapshot.data ?? '-';
                        return Text(
                          'by: $sellerName',
                          style: TextStyle(
                            fontSize: 9,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.italic,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
