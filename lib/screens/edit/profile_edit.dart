import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfileEdit extends StatefulWidget {
  const ProfileEdit({
    Key? key,
    required this.data,
  }) : super(key: key);

  final Map<String, dynamic> data;
  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController facebookIdController = TextEditingController();
  final _storage = const FlutterSecureStorage();

  Future<Map<String, String?>> readSecureData() async {
    final email = await _storage.read(key: 'email');
    final line_id = await _storage.read(key: 'line_id');
    return {
      'email': email,
      'line_id': line_id,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Edit'),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, String?>>(
        future: readSecureData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            final email = data['email'] ?? '';
            final fb_id = data['line_id'] ?? '';
            emailController.text = email;
            facebookIdController.text = fb_id;
            return RefreshIndicator(
              onRefresh: _refreshData,
              child: ListView(
                children: [
                  SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextField(
                              controller: emailController,
                              decoration: InputDecoration(
                                labelText: 'Email',
                              ),
                              enabled: false,
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: facebookIdController,
                              maxLength: 15,
                              decoration: InputDecoration(
                                labelText: 'Line ID ',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save),
        onPressed: () {
          widget.data['fn'] = 'edit_user';
          widget.data['body'] = {"line_id": facebookIdController.text};
          Navigator.pushNamed(context, '/api').then((_) =>
              Navigator.pushNamedAndRemoveUntil(
                  context, '/home', (route) => false));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  Future<void> writeSecureData(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<void> _refreshData() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      print('refreshed');
    });
  }
}
