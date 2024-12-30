import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import 'supply_applicants_screen.dart';
import 'supply_form_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SupplyDetailScreen extends StatelessWidget {
  final String supplyId;
  final FirestoreService _firestoreService = FirestoreService();

  SupplyDetailScreen({required this.supplyId});

  void _applyForSupply(BuildContext context) async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    final data = await _firestoreService.getSupplyDetails(supplyId);
    if (data['ownerId'] == currentUserId) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You cannot apply to your own supply.')),
      );
      return;
    }

    try {
      await _firestoreService.applyToSupply(supplyId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Successfully applied for the supply!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to apply: $e')),
      );
    }
  }


  void _viewApplicants(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SupplyApplicantsScreen(supplyId: supplyId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser
        ?.uid; // Get current user's ID

    return Scaffold(
      appBar: AppBar(title: Text('Supply Details')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _firestoreService.getSupplyDetails(supplyId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return Center(
              child: Text(
                'Supply details could not be loaded.',
                style: Theme
                    .of(context)
                    .textTheme
                    .bodyLarge,
              ),
            );
          }

          final data = snapshot.data!;
          final isOwner = userId ==
              data['ownerId']; // Correctly compare userId with ownerId

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data['title'],
                      style: Theme
                          .of(context)
                          .textTheme
                          .headlineSmall,
                    ),
                    SizedBox(height: 8),
                    Text('Description: ${data['description']}'),
                    SizedBox(height: 8),
                    Text('Sector: ${data['sector']}'),
                    SizedBox(height: 8),
                    Text('Published by: ${data['ownerUsername']}'),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _viewApplicants(context),
                            child: Text('View Applicants'),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: isOwner
                              ? ElevatedButton(
                            onPressed: null,
                            child: Text('You cannot apply'),
                          )
                              : ElevatedButton(
                            onPressed: () => _applyForSupply(context),
                            child: Text('Apply'),
                          ),
                        ),
                      ],
                    ),
                    if (isOwner) // Check ownership before showing Edit/Delete buttons
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SupplyFormScreen(
                                      supplyId: supplyId,
                                      existingData: data,
                                    ),
                              ),
                            );
                          },
                          child: Text('Edit'),
                        ),
                      ),
                    if (isOwner)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red),
                          onPressed: () async {
                            await _firestoreService.deleteSupply(supplyId);
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(
                                  'Supply deleted successfully!')),
                            );
                          },
                          child: Text('Delete'),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
