import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import 'supply_detail_screen.dart';

class SupplyApplicantsScreen extends StatelessWidget {
  final String supplyId;
  final FirestoreService _firestoreService = FirestoreService();

  SupplyApplicantsScreen({required this.supplyId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Applicants')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _firestoreService.getSupplyDetails(supplyId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return Center(
              child: Text('No applicants found.'),
            );
          }

          final data = snapshot.data!;
          final applicants = List<String>.from(data['applicants'] ?? []);
          final acceptedApplicant = data['acceptedApplicant'];

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: applicants.length,
            itemBuilder: (context, index) {
              final username = applicants[index];
              final isAccepted = acceptedApplicant == username;

              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Text(
                    username,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  trailing: isAccepted
                      ? Icon(Icons.check, color: Colors.green)
                      : ElevatedButton(
                    onPressed: () async {
                      final currentUserId = FirebaseAuth.instance.currentUser?.uid;

                      final isOwner = await _firestoreService.isOwner(supplyId, currentUserId!);
                      if (!isOwner) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Only the owner can accept applications.')),
                        );
                        return;
                      }

                      await _firestoreService.acceptApplicant(supplyId, username);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('$username has been accepted')),
                      );
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SupplyDetailScreen(supplyId: supplyId),
                        ),
                      );
                    },
                    child: Text('Accept'),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
