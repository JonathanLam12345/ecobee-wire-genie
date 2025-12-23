import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../app_bar/app_navigation_bar.dart';

class FeatureRequestPage extends StatefulWidget {
  const FeatureRequestPage({super.key});

  @override
  State<FeatureRequestPage> createState() => _FeatureRequestPageState();
}

class _FeatureRequestPageState extends State<FeatureRequestPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String _category = "Feature Request";
  bool _submitting = false;
  bool _showSecretList = false;

  late AnimationController _animController;
  late Animation<double> _shimmerAnimation;

  static const String secretPhrase = "grant my wish, wiregenie";

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _shimmerAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final titleText = _titleController.text.trim().toLowerCase();

    // --- Secret Mode Trigger ---
    if ((titleText == secretPhrase )||( titleText == "admin")) {
      setState(() => _showSecretList = true);
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);

    try {
      final dbRef = FirebaseDatabase.instance.ref('feature_requests');
      final pushRef = dbRef.push();
      final pushKey = pushRef.key;

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final keyWithTimestamp = '${timestamp}_$pushKey';

      await dbRef.child(keyWithTimestamp).set({
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'category': _category,
        'status': 'open',
        'createdAt': ServerValue.timestamp,
      });

      _titleController.clear();
      _descriptionController.clear();
      setState(() => _category = "Feature Request");

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

  Widget _buildFeatureRequestList() {
    final ref = FirebaseDatabase.instance.ref('feature_requests');

    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                Colors.yellow.withOpacity(_shimmerAnimation.value * 0.4),
                Colors.transparent,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
          child: child,
        );
      },
      child: StreamBuilder(
        stream: ref.orderByKey().onValue,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return const Padding(
              padding: EdgeInsets.all(20),
              child: Text("No requests found",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            );
          }

          final data = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
          final entries = data.entries.toList();
          entries.sort((a, b) => a.key.compareTo(b.key));

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final item = entries[index];
              final req = item.value as Map;

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text(req['title'] ?? ''),
                  subtitle: Text(req['description'] ?? ''),
                  trailing: Text(req['status'] ?? 'open'),
                ),
              );
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf9fafc),
      appBar: const AppNavigationBar(showBackButton: false),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
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

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    child: Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0xFFdddddd),
                    ),
                  ),

                  if (!_showSecretList) ...[
                    const Text(
                      "Let us know what you would like to add to this web app.",
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    const SizedBox(height: 10),

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
                            validator: (value) => value == null || value.isEmpty
                                ? "Required"
                                : null,
                          ),
                          const SizedBox(height: 16),

                          TextFormField(
                            controller: _descriptionController,
                            decoration: const InputDecoration(
                              labelText: "Description",
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 5,
                            validator: (value) => value == null || value.isEmpty
                                ? "Required"
                                : null,
                          ),
                          const SizedBox(height: 16),

                          DropdownButtonFormField<String>(
                            value: _category,
                            items: const [
                              DropdownMenuItem(
                                  value: "Feature Request",
                                  child: Text("Feature Request")),
                              DropdownMenuItem(
                                  value: "Bug Report",
                                  child: Text("Bug Report")),
                              DropdownMenuItem(
                                  value: "Improvement",
                                  child: Text("Improvement")),
                            ],
                            onChanged: (val) {
                              setState(() => _category = val!);
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
                  ] else ...[
                    const Text(
                      "WireGenie Secret Request List",
                      style: TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    _buildFeatureRequestList(),

                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        setState(() => _showSecretList = false);
                      },
                      child: const Text("Return to Feature Request Form"),
                    ),
                  ]
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
