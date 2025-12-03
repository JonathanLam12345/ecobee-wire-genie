import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../app_bar/app_navigation_bar.dart';

class FeatureRequestPage extends StatefulWidget {
  const FeatureRequestPage({super.key});

  @override
  State<FeatureRequestPage> createState() => _FeatureRequestPageState();
}

class _FeatureRequestPageState extends State<FeatureRequestPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String _category = "Feature Request";
  bool _submitting = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      final dbRef = FirebaseDatabase.instance.ref('feature_requests');
      final pushRef = dbRef.push(); // generates a unique ID
      final pushKey = pushRef.key; // e.g. -OfWNKVipeOrQ3DRsyZ1

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final keyWithTimestamp = '${timestamp}_$pushKey';

      final newReqRef = dbRef.child(keyWithTimestamp);

      await newReqRef.set({
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'category': _category,
        'status': 'open',
        'createdAt': ServerValue.timestamp,
      });

      // Reset form
      _titleController.clear();
      _descriptionController.clear();
      setState(() {
        _category = "Feature Request";
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Your request has been submitted!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf9fafc),
      appBar: const AppNavigationBar(showBackButton: false),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          // Wrap with Center to ensure the ConstrainedBox is centered
          child: Padding(
            padding: const EdgeInsets.only(top: 32.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Feature Requests',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF172538),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Let us know what you would like to add to this web app. This could be a new wiring diagram, an additional tool, or an improvement to existing functionality.",
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 10),

                  // The Form starts here, filling the rest of the constrained space
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _titleController,
                          decoration: const InputDecoration(
                            labelText: "Title",
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) =>
                          value == null || value.isEmpty ? "Required" : null,
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _descriptionController,
                          decoration: const InputDecoration(
                            labelText: "Description",
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 5,
                          validator: (value) =>
                          value == null || value.isEmpty ? "Required" : null,
                        ),
                        const SizedBox(height: 16),

                        DropdownButtonFormField<String>(
                          value: _category,
                          items: const [
                            DropdownMenuItem(
                                value: "Feature Request", child: Text("Feature Request")),
                            DropdownMenuItem(
                                value: "Bug Report", child: Text("Bug Report")),
                            DropdownMenuItem(
                                value: "Improvement", child: Text("Improvement")),
                          ],
                          onChanged: (val) {
                            setState(() {
                              _category = val!;
                            });
                          },
                          decoration: const InputDecoration(
                            labelText: "Category",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 32),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _submitting ? null : _submit,
                            child: _submitting
                                ? const CircularProgressIndicator()
                                : const Text("Submit"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}