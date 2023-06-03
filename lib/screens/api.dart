import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class Api extends StatelessWidget {
  const Api({
    super.key,
    required this.data,
  });
  final Map<String, dynamic> data;

  Future<void> sendApi(BuildContext context) async {
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');

    final url = Uri.parse('http://13.250.14.61:8765/v1/' + data['fn']);
    final headers = {
      'content-type': 'application/json',
      'token': token.toString(),
    };
    final body = jsonEncode(data['body']);
    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['err'] != null) {
        data['err'] = jsonResponse['err'];
      }
      print('response= $jsonResponse');

      try {
        if (jsonResponse['token'] != null) {
          await storage.write(key: 'token', value: jsonResponse['token']);
        }

        if (jsonResponse['line_id'] != null) {
          await storage.write(key: 'line_id', value: jsonResponse['line_id']);
        }

        if (jsonResponse['email'] != null) {
          await storage.write(key: 'email', value: jsonResponse['email']);
        }
        if (jsonResponse['password'] != null) {
          await storage.write(key: 'password', value: jsonResponse['password']);
        }

        if (jsonResponse['items'] != null) {
          data['items'] = jsonResponse['items'];
        }

        if (jsonResponse['type'] != null) {
          data['type'] = jsonResponse['type'];
        }

        if (jsonResponse['favorite'] != null) {
          data['favorite'] = jsonResponse['favorite'];
        }

        if (jsonResponse['contact'] != null) {
          data['contact'] = jsonResponse['contact'];
        }

        print(data);
        await Future.delayed(const Duration(seconds: 1));
        Navigator.pop(context);
      } catch (e) {
        print('token error' + e.toString());
      }
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  Widget build(BuildContext context) {
    sendApi(context);
    return const Scaffold(
//      backgroundColor: Colors.transparent,
      body: Center(
        child: CircularProgressIndicator(
//          backgroundColor: Colors.transparent,
            ),
      ),
    );
  }
}






/*
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('AlertDialog Title'),
          content: const Text('AlertDialog description'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      */