import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key, required this.data, required this.add});
  final Map<String, dynamic> data, add;

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _storage = const FlutterSecureStorage();
  final Map<String, dynamic> data =
      {}; // Add this line to declare the 'data' map

  @override
  void initState() {
    super.initState();
    readSecureData();
  }

  Future<void> readSecureData() async {
    final email = await _storage.read(key: 'email');
    final property = await _storage.read(key: 'property');
    final price = await _storage.read(key: 'price');
    final area = await _storage.read(key: 'area');
    final bedroom = await _storage.read(key: 'bedroom');
    final bathroom = await _storage.read(key: 'bathroom');
    final living = await _storage.read(key: 'living');
    final kitchen = await _storage.read(key: 'kitchen');
    final dining = await _storage.read(key: 'dining');
    final parking = await _storage.read(key: 'parking');
    final district = await _storage.read(key: 'district');
    final amphoe = await _storage.read(key: 'amphoe');
    final province = await _storage.read(key: 'province');
    final zipcode = await _storage.read(key: 'zipcode');
    final lat = await _storage.read(key: 'lat');
    final long = await _storage.read(key: 'long');
    final photo = await _storage.read(key: 'img');
    final fbId = await _storage.read(key: 'fb_id');

    setState(() {
      data['email'] = email;
      data['property'] = property;
      data['price'] = price;
      data['area'] = area;
      data['bedroom'] = bedroom;
      data['bathroom'] = bathroom;
      data['living'] = living;
      data['kitchen'] = kitchen;
      data['dining'] = dining;
      data['parking'] = parking;
      data['district'] = district;
      data['amphoe'] = amphoe;
      data['province'] = province;
      data['zipcode'] = zipcode;
      data['lat'] = lat;
      data['long'] = long;
      data['photo'] = photo;
      data['fb_id'] = fbId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FormPage'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                widget.data['fn'] = 'add';
                widget.data['body'] = {
                  "email": data['email'],
                  "type": data['property'],
                  "price": data['price'],
                  "area": data['area'],
                  "bedroom": data['bedroom'],
                  "bathroom": data['bathroom'],
                  "living": data['living'],
                  "kitchen": data['kitchen'],
                  "dining": data['dining'],
                  "parking": data['parking'],
                  "district": data['district'],
                  "amphoe": data['amphoe'],
                  "province": data['province'],
                  "zipcode": data['zipcode'],
                  "lat": data['lat'],
                  "lng": data['long'],
                  "img": data['photo'],
                  "fb_id": data['fb_id'],
                };
                // ignore: unused_local_variable
                var response = await Navigator.pushNamed(
                  context,
                  '/api',
                );
                widget.data['fn'] = 'get';
                widget.data['body'] = {};
                response = await Navigator.pushNamed(
                  context,
                  '/api',
                );
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/home',
                  (route) => false,
                );
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
