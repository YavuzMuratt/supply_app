import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class SupplyFormScreen extends StatefulWidget {
  final String? supplyId;
  final Map<String, dynamic>? existingData;

  SupplyFormScreen({this.supplyId, this.existingData});

  @override
  _SupplyFormScreenState createState() => _SupplyFormScreenState();
}

class _SupplyFormScreenState extends State<SupplyFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _sector;
  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    if (widget.existingData != null) {
      _titleController.text = widget.existingData!['title'];
      _descriptionController.text = widget.existingData!['description'];
      _sector = widget.existingData!['sector'];
    }
  }

  void _saveSupply() async {
    if (_formKey.currentState!.validate()) {
      final data = {
        'title': _titleController.text,
        'description': _descriptionController.text,
        'sector': _sector,
        'status': widget.existingData?['status'] ?? 'open',
        'ownerId': widget.existingData?['ownerId'] ?? FirebaseAuth.instance.currentUser?.uid,
        'ownerUsername': widget.existingData?['ownerUsername'] ?? FirebaseAuth.instance.currentUser?.displayName ?? 'Anonymous',
      };

      if (widget.supplyId == null) {
        await _firestoreService.addSupply(data);
      } else {
        await _firestoreService.updateSupply(widget.supplyId!, data);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.supplyId == null ? 'Add Supply' : 'Edit Supply')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Title is required.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Description is required.';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _sector,
                onChanged: (value) {
                  setState(() {
                    _sector = value;
                  });
                },
                items: ['Construction', 'Technology', 'Textile']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                decoration: InputDecoration(labelText: 'Sector'),
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _saveSupply, child: Text('Save')),
            ],
          ),
        ),
      ),
    );
  }
}
