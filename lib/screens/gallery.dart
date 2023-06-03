import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Gallery extends StatefulWidget {
  const Gallery({
    Key? key,
    required this.data,
  }) : super(key: key);

  final Map<String, dynamic> data;

  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  bool isFavorite = false;
  final storage = FlutterSecureStorage();
  late Future<String?> email;
  String? currentUserEmail;

  @override
  void initState() {
    super.initState();
    email = _getEmail();
    email.then((value) {
      setState(() {
        currentUserEmail = value;
      });
    });
    checkFavorite();
  }

  Future<String?> _getEmail() async {
    return await storage.read(key: 'email');
  }

  void checkFavorite() {
    final item = widget.data['items'][widget.data['index']];
    final favorites = widget.data['favorite'];
    isFavorite = favorites.contains(item['item_id']);
    print(item['email']);
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.data['items'][widget.data['index']];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gallery'),
        centerTitle: true,
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
        ),
        itemCount: item['img'].length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              image: DecorationImage(
                image: NetworkImage(
                  'https://wealthi-re.s3.ap-southeast-1.amazonaws.com/image/' +
                      item['img'][index],
                ),
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}
