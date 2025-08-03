import 'package:flutter/material.dart';
import 'dart:io';
import 'home_header_footer.dart';
import '../../controllers/user_sell_controller.dart';

class UserSell extends StatefulWidget {
  const UserSell({super.key});

  @override
  State<UserSell> createState() => _UserSellState();
}

class _UserSellState extends State<UserSell> {
  final UserSellController _controller = UserSellController();
  
  String selectedBarangay = '';
  String? selectedCategory;
  File? _productImage;
  
  // Text controllers for form fields
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  
  // Loading state
  bool _isSubmitting = false;

  bool get _isFormComplete {
    return _controller.isFormComplete(
      productName: _productNameController.text,
      price: _priceController.text,
      category: selectedCategory,
      description: _descriptionController.text,
    );
  }

  Future<void> _pickImage() async {
    final image = await _controller.pickImage();
    if (image != null) {
      setState(() {
        _productImage = image;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchBarangay();
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _fetchBarangay() async {
    final barangay = await _controller.getCurrentUserBarangay();
    setState(() {
      selectedBarangay = barangay;
    });
  }

  Future<void> _submitProduct() async {
    setState(() {
      _isSubmitting = true;
    });

    try {
      await _controller.submitProduct(
        productName: _productNameController.text,
        price: _priceController.text,
        category: selectedCategory,
        description: _descriptionController.text,
        barangay: selectedBarangay,
        productImage: _productImage,
      );

      _controller.showSnackBar(context, 'Product listed successfully!');
      _clearForm();
    } catch (e) {
      _controller.showSnackBar(context, 'Error listing product: ${e.toString()}');
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  void _clearForm() {
    setState(() {
      _productNameController.clear();
      _priceController.clear();
      _descriptionController.clear();
      selectedCategory = null;
      _productImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double relWidth(double dp) => screenWidth * (dp / 412);
    double relHeight(double dp) => screenHeight * (dp / 915);

    _controller.setSystemUIOverlayStyle();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            SafeArea(
              bottom: false,
              child: Container(
                width: double.infinity,
                color: const Color(0xFFFF5B29),
                child: HomeHeader(
                  relWidth: relWidth,
                  relHeight: relHeight,
                  selectedBarangay: selectedBarangay,
                  onNotificationTap: () {
                    _controller.navigateToNotifications(context);
                  },
                  onSearchChanged: (query) {
                    // For immediate search feedback, could add setState here if needed
                  },
                  onSearchSubmitted: (query) {
                    _controller.navigateToSearchResults(
                      context,
                      query,
                      selectedBarangay,
                      relWidth,
                      relHeight,
                    );
                  },
                ),
              ),
            ),
            // Add Product Image Button
            Container(
              child: GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: relHeight(243),
                  decoration: BoxDecoration(
                    color: Color(0xFFE0E0E0),
                  ),
                  child: Center(
                    child: _productImage == null
                        ? Stack(
                            alignment: Alignment.center,
                            children: [
                              Image.asset(
                                'assets/images/add_image.png',
                                width: relWidth(108),
                                height: relWidth(108),
                              ),
                            ],
                          )
                        : ClipRRect(
                            child: Image.file(
                              _productImage!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: relHeight(243),
                            ),
                          ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: relHeight(12),
                left: relWidth(24),
                right: relWidth(24),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Input the following information below to list an item:',
                      style: TextStyle(
                        fontFamily: 'RobotoCondensed',
                        fontSize: relWidth(16),
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF611A04),
                      ),
                    ),
                    // Form Fields
                    SizedBox(height: relHeight(7)),
                    Container(
                      width: double.infinity,
                      height: relHeight(186),
                      decoration: BoxDecoration(
                        color: Color(0xFFF3F2F2),
                        borderRadius: BorderRadius.circular(relWidth(3)),
                        border: Border.all(
                          color: Colors.black.withOpacity(0.22),
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: relHeight(9),
                          left: relWidth(17),
                          right: relWidth(17),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product Name Field
                            Text(
                              'Product Name:',
                              style: TextStyle(
                                fontFamily: 'RobotoCondensed',
                                fontSize: relWidth(16),
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF611A04),
                              ),
                            ),
                            Container(
                              height: relHeight(28),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(relWidth(23)),
                                border: Border.all(
                                  color: const Color(0xFF611A04),
                                  width: 1,
                                ),
                              ),
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.symmetric(horizontal: relWidth(10)),
                              child: TextField(
                                controller: _productNameController,
                                style: TextStyle(
                                  fontSize: relWidth(16),
                                  fontFamily: 'RobotoCondensed',
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration.collapsed(
                                  hintText: 'Enter product name',
                                  hintStyle: TextStyle(
                                    fontFamily: 'RobotoCondensed',
                                    fontSize: relWidth(16),
                                    color: const Color(0xFFBDBDBD),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: relHeight(6)),
                            // Price of Product Field
                            Text(
                              'Price of Product:',
                              style: TextStyle(
                                fontFamily: 'RobotoCondensed',
                                fontSize: relWidth(16),
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF611A04),
                              ),
                            ),
                            Container(
                              height: relHeight(28),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(relWidth(23)),
                                border: Border.all(
                                  color: const Color(0xFF611A04),
                                  width: 1,
                                ),
                              ),
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.symmetric(horizontal: relWidth(10)),
                              child: TextField(
                                controller: _priceController,
                                style: TextStyle(
                                  fontSize: relWidth(16),
                                  fontFamily: 'RobotoCondensed',
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration.collapsed(
                                  hintText: 'Enter product price',
                                  hintStyle: TextStyle(
                                    fontFamily: 'RobotoCondensed',
                                    fontSize: relWidth(16),
                                    color: const Color(0xFFBDBDBD),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            SizedBox(height: relHeight(6)),
                            // Category Dropdown
                            Text(
                              'Category:',
                              style: TextStyle(
                                fontFamily: 'RobotoCondensed',
                                fontSize: relWidth(16),
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF611A04),
                              ),
                            ),
                            Container(
                              height: relHeight(28), 
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(relWidth(23)),
                                border: Border.all(
                                  color: const Color(0xFF611A04),
                                  width: 1,
                                ),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: relWidth(10)),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: selectedCategory,
                                  isExpanded: true,
                                  hint: Text(
                                    'Select category',
                                    style: TextStyle(
                                      fontFamily: 'RobotoCondensed',
                                      fontSize: relWidth(16),
                                      color: const Color(0xFFBDBDBD),
                                    ),
                                  ),
                                  style: TextStyle(
                                    fontFamily: 'RobotoCondensed',
                                    fontSize: relWidth(16),
                                    color: Colors.black,
                                  ),
                                  icon: Icon(
                                    Icons.keyboard_arrow_down,
                                    color: const Color(0xFF611A04),
                                  ),
                                  items: _controller.getCategories().map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedCategory = newValue!;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: relHeight(17)),
                    Container(
                      width: double.infinity,
                      height: relHeight(156),
                      decoration: BoxDecoration(
                        color: Color(0xFFF3F2F2),
                        borderRadius: BorderRadius.circular(relWidth(3)),
                        border: Border.all(
                          color: Colors.black.withOpacity(0.22),
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: relHeight(9),
                          left: relWidth(17),
                          right: relWidth(17),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Description Field
                            Text(
                              'Description:',
                              style: TextStyle(
                                fontFamily: 'RobotoCondensed',
                                fontSize: relWidth(16),
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF611A04),
                              ),
                            ),
                            SizedBox(height: relHeight(3)),
                            Container(
                              height: relHeight(107),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(relWidth(7)),
                                border: Border.all(
                                  color: const Color(0xFF611A04),
                                  width: 1,
                                ),
                              ),
                              alignment: Alignment.topLeft,
                              padding: EdgeInsets.symmetric(horizontal: relWidth(10)),
                              child: TextField(
                                controller: _descriptionController,
                                maxLines: null,
                                minLines: 4,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Enter Product Description',
                                  hintStyle: TextStyle(
                                    fontFamily: 'RobotoCondensed',
                                    fontSize: relWidth(16),
                                    color: const Color(0xFFBDBDBD),
                                  ),
                                ),
                                style: TextStyle(
                                  fontSize: relWidth(16),
                                  fontFamily: 'RobotoCondensed',
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: relHeight(6)),
                    // Submit Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: (_isSubmitting || !_isFormComplete) ? null : _submitProduct,
                          child: Opacity(
                            opacity: (_isSubmitting || !_isFormComplete) ? 0.5 : 1.0,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/tick_square.png',
                                  width: relWidth(34),
                                  height: relWidth(34),
                                ),
                                if (_isSubmitting)
                                  SizedBox(
                                    width: relWidth(20),
                                    height: relWidth(20),
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Color(0xFF611A04),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: HomeFooter(
        relWidth: relWidth,
        relHeight: relHeight,
        onStoreTap: () {
          _controller.navigateToHome(context);
        },
        onAnnouncementTap: () {
          _controller.navigateToAnnouncements(context);
        },
        onSellTap: () {
          _controller.navigateToSell(context);
        },
        onProfileTap: () {
          _controller.navigateToProfile(context);
        },
        activeTab: 'sell',
      ),
    );
  }
}