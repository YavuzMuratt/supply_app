import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';
import '../widgets/supply_card.dart';
import 'supply_detail_screen.dart';
import 'supply_form_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  String? _searchQuery;
  int _currentIndex = 0; // Track the selected tab
  final String? _userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _currentIndex == 0 ? 'Supply Flow' : 'My Supplies',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        actions: _currentIndex == 0
            ? [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: _SupplySearchDelegate(_firestoreService),
              );
            },
          ),
        ]
            : null,
      ),
      body: _currentIndex == 0 ? _buildAllSupplies() : _buildUserSupplies(),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SupplyFormScreen()),
          );
        },
      )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'All Supplies',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'My Supplies',
          ),
        ],
      ),
    );
  }

  Widget _buildAllSupplies() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestoreService.getSupplies(_searchQuery),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              'No supplies found.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final doc = snapshot.data!.docs[index];
            final data = doc.data() as Map<String, dynamic>;
            return SupplyCard(
              title: data['title'],
              description: data['description'],
              sector: data['sector'],
              ownerId: data['ownerUsername'], // Use ownerUsername here
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
    );
  }

  Widget _buildUserSupplies() {
    if (_userId == null) {
      return Center(child: Text('Not logged in.'));
    }

    return StreamBuilder<QuerySnapshot>(
      stream: _firestoreService.getUserSupplies(_userId!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              'No supplies shared yet.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final doc = snapshot.data!.docs[index];
            final data = doc.data() as Map<String, dynamic>;
            return SupplyCard(
              title: data['title'],
              description: data['description'],
              sector: data['sector'],
              ownerId: data['ownerUsername'], // Use ownerUsername here
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
    );
  }
}

class _SupplySearchDelegate extends SearchDelegate {
  final FirestoreService firestoreService;

  _SupplySearchDelegate(this.firestoreService);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = ''; // Clear the search bar
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null); // Close the search bar
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestoreService.getSupplies(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              'No results found.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
        }

        final supplies = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: supplies.length,
          itemBuilder: (context, index) {
            final doc = supplies[index];
            final data = doc.data() as Map<String, dynamic>;

            return SupplyCard(
              title: data['title'],
              description: data['description'],
              sector: data['sector'],
              ownerId: data['ownerUsername'] ?? 'Unknown', // Handle missing username
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
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.trim().isEmpty) {
      return Center(
        child: Text(
          'Type to search supplies...',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }

    return buildResults(context);
  }
}

