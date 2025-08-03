import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryProductsModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getProductsByCategory(String category, String barangay) {
    return _firestore
        .collection('products')
        .where('barangay', isEqualTo: barangay)
        .where('category', isEqualTo: category)
        .snapshots();
  }
}