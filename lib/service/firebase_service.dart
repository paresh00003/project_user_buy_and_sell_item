import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/item.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addItem({
    required String name,
    required String description,
    required double price,
    required String category,
    required String imageUrl,
    required String sellerId,
  }) async {
    try {
      await _db.collection('items').add({
        'name': name,
        'description': description,
        'price': price,
        'category': category,
        'imageUrl': imageUrl,
        'sellerId': sellerId,
        'createdAt': FieldValue.serverTimestamp(),
        'isSold': false,
      });
      print('Item added successfully');
    } catch (e) {
      print('Error adding item: $e');
      throw Exception('Error adding item: $e');
    }
  }

  Future<void> updateItem(String itemId, Map<String, dynamic> data) async {
    try {
      await _db.collection('items').doc(itemId).update(data);
    } catch (e) {
      throw Exception('Failed to update item: $e');
    }
  }

  Future<void> deleteItem(String itemId) async {
    try {
      await _db.collection('items').doc(itemId).delete();
      print('Item deleted successfully');
    } catch (e) {
      print('Error deleting item: $e');
      throw Exception('Error deleting item: $e');
    }
  }

  Stream<List<Item>> getItemsBySellerStream(String sellerId) {
    return _db
        .collection('items')
        .where('sellerId', isEqualTo: sellerId)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => Item.fromFirestore(doc.data(), doc.id)).toList());
  }

  Stream<List<Item>> getItemsBySearch({
    required String searchQuery,
    required String selectedCategory,
    required String currentUserId,
  }) {
    final itemsCollection = _db.collection('items');
    Query query = itemsCollection;


    if (selectedCategory != 'All') {
      query = query.where('category', isEqualTo: selectedCategory);
    }


    query = query.where('sellerId', isNotEqualTo: currentUserId);

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Item.fromFirestore(data, doc.id);
      }).where((item) {

        final itemNameLower = item.name.toLowerCase();
        final itemDescriptionLower = item.description.toLowerCase();
        final queryLower = searchQuery.toLowerCase();
        return itemNameLower.contains(queryLower) || itemDescriptionLower.contains(queryLower);
      }).toList();
    });
  }

  Stream<List<Item>> getSoldItemsBySellerStream(String sellerId) {
    return _db
        .collection('items')
        .where('sellerId', isEqualTo: sellerId)
        .where('isSold', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Item.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
        .toList());
  }

  Future<String> getBuyerDetails(String buyerId) async {
    try {
      final doc = await _db.collection('users').doc(buyerId).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        final name = data['name'] ?? 'Name not available';
        final contact = data['contact'] ?? 'Contact not available';
        final email = data['email'] ?? 'Email not available';
        return '$name ($contact, $email)';
      } else {
        return 'Buyer details not found';
      }
    } catch (e) {
      print('Error fetching buyer details: $e');
      return 'Error fetching buyer details: $e';
    }
  }

  Future<void> updateItemWithBuyerDetails(
      String itemId, {
        String? buyerId,
        String? buyerName,
        String? buyerEmail,
        String? buyerContact,
      }) async {
    try {
      await _db.collection('items').doc(itemId).update({
        'isSold': true,
        'buyerId': buyerId,
        'buyerName': buyerName,
        'buyerEmail': buyerEmail,
        'buyerContact': buyerContact,
      });
    } catch (e) {
      print('Error updating item: $e');
    }
  }

  Future<String> getLoggedInUserId() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      throw Exception('No user is currently logged in.');
    }
  }
}
