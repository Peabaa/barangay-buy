import 'package:cloud_firestore/cloud_firestore.dart';

class SearchResultsModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get products stream by barangay
  Stream<QuerySnapshot> getProductsByBarangay(String barangay) {
    if (barangay.isNotEmpty) {
      return _firestore
          .collection('products')
          .where('barangay', isEqualTo: barangay)
          .snapshots();
    } else {
      return _firestore.collection('products').snapshots();
    }
  }

  // Filter products by search query
  List<QueryDocumentSnapshot> filterProductsByQuery(
    List<QueryDocumentSnapshot> products, 
    String searchQuery
  ) {
    if (searchQuery.trim().isEmpty) {
      return products;
    }

    return products.where((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final productName = (data['productName'] ?? '').toString().toLowerCase();
      final category = (data['category'] ?? '').toString().toLowerCase();
      final description = (data['description'] ?? '').toString().toLowerCase();
      final query = searchQuery.toLowerCase();
      
      return productName.contains(query) || 
             category.contains(query) || 
             description.contains(query);
    }).toList();
  }
}