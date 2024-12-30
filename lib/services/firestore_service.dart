import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Add a new supply
  Future<void> addSupply(Map<String, dynamic> supplyData) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (!userDoc.exists) {
      throw Exception('User data not found in Firestore');
    }

    final username = userDoc.data()?['username'] ?? 'Anonymous';

    // Add `ownerUsername` to supplyData
    final completeSupplyData = {
      ...supplyData,
      'ownerId': user.uid,
      'ownerUsername': username,
    };

    await FirebaseFirestore.instance.collection('supplies').add(completeSupplyData);
  }

  // Fetch all supplies, optionally filtered by a search query
  Stream<QuerySnapshot> getSupplies(String? searchQuery) {
    if (searchQuery != null && searchQuery.isNotEmpty) {
      return _firestore
          .collection('supplies')
          .where('title', isGreaterThanOrEqualTo: searchQuery)
          .where('title', isLessThanOrEqualTo: '$searchQuery\uf8ff')
          .snapshots();
    }
    return _firestore.collection('supplies').snapshots(); // Return all supplies
  }

  // Fetch supplies created by a specific user
  Stream<QuerySnapshot> getUserSupplies(String userId) {
    return _firestore
        .collection('supplies')
        .where('ownerId', isEqualTo: userId)
        .snapshots();
  }

  // Fetch details for a specific supply
  Future<Map<String, dynamic>> getSupplyDetails(String supplyId) async {
    final doc = await _firestore.collection('supplies').doc(supplyId).get();
    if (!doc.exists) {
      throw Exception('Supply not found.');
    }
    return doc.data()!;
  }

  // Fetch the current user's username
  Future<String?> getCurrentUsername() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return null;

    final doc = await _firestore.collection('users').doc(userId).get();
    return doc.data()?['username'];
  }

  Future<void> deleteSupply(String supplyId) async {
    await _firestore.collection('supplies').doc(supplyId).delete();
  }

  Future<void> updateSupply(String supplyId, Map<String, dynamic> updatedData) async {
    await _firestore.collection('supplies').doc(supplyId).update(updatedData);
  }

  // Apply to a supply
  Future<void> applyToSupply(String supplyId) async {
    final docRef = _firestore.collection('supplies').doc(supplyId);
    final doc = await docRef.get();

    if (doc.exists) {
      final data = doc.data()!;
      final applicants = List<String>.from(data['applicants'] ?? []);
      final username = await getCurrentUsername() ?? 'Anonymous';

      if (!applicants.contains(username)) {
        applicants.add(username);
        await docRef.update({'applicants': applicants});
      }
    }
  }

  // Fetch applicants for a supply
  Future<List<String>> getApplicants(String supplyId) async {
    final doc = await _firestore.collection('supplies').doc(supplyId).get();
    if (!doc.exists) {
      throw Exception('Supply not found.');
    }
    return List<String>.from(doc.data()?['applicants'] ?? []);
  }

  // Accept an applicant for a supply
  Future<void> acceptApplicant(String supplyId, String applicantUsername) async {
    final supplyRef = _firestore.collection('supplies').doc(supplyId);
    await supplyRef.update({
      'acceptedApplicant': applicantUsername,
      'status': 'closed',
    });
  }

  // Check if a user is the owner of a supply
  Future<bool> isOwner(String supplyId, String userId) async {
    final supplyDoc = await _firestore.collection('supplies').doc(supplyId).get();
    return supplyDoc.exists && supplyDoc.data()?['ownerId'] == userId;
  }
}
