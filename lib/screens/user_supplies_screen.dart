import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';
import '../widgets/supply_card.dart';
import 'supply_detail_screen.dart';

class UserSuppliesScreen extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();
  final String userId; // User's ID

  UserSuppliesScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Supplies')),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestoreService.getUserSupplies(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No supplies posted yet.'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final data = doc.data() as Map<String, dynamic>;

              return SupplyCard(
                title: data['title'] ?? 'Untitled',
                description: data['description'] ?? 'No description provided',
                sector: data['sector'] ?? 'Unknown',
                ownerId: data['ownerUsername'] ?? 'Unknown',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SupplyDetailScreen(supplyId: doc.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
