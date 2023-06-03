// ignore_for_file: prefer_interpolation_to_compose_strings, unused_shown_name, unused_local_variable

import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math' show asin, atan2, cos, pi, sin, sqrt;
import 'detail.dart';

class FilterMap extends StatefulWidget {
  const FilterMap({
    Key? key,
    required this.data,
  }) : super(key: key);

  final Map<String, dynamic> data;

  @override
  _FilterMapState createState() => _FilterMapState();
}

class _FilterMapState extends State<FilterMap> {
  final LatLng _center = const LatLng(13.7248785, 100.4683012);
  LatLng? _markerLocation;
  Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: _center, zoom: 11.0),
      ),
    );
  }

  void _onMarkerTapped(LatLng location) async {
    final item = widget.data['items'][widget.data['index']];
    setState(() {
      _markerLocation = location;
      _markers.clear();
    });

    print(location);

    print('Pin: ${location.latitude}, ${location.longitude}');

    List<Item> nearbyItems = await getNearbyItems(location);

    final double radius = 5.0;

    for (Item item in nearbyItems) {
      final distance = calculateDistance(
          location.latitude, location.longitude, item.lat!, item.lng!);
      if (distance <= radius) {
        final markerId = MarkerId(item.itemId!);

        Uint8List? markerIconBytes = await loadNetworkImage(
          'https://wealthi-re.s3.ap-southeast-1.amazonaws.com/image/' +
              item.img!,
        );

        final ui.Codec markerImageCodec = await ui.instantiateImageCodec(
          markerIconBytes!,
          targetWidth: 200,
          targetHeight: 200,
        );

        final ui.FrameInfo frameInfo = await markerImageCodec.getNextFrame();

        final ByteData? byteData = await frameInfo.image.toByteData(
          format: ui.ImageByteFormat.png,
        );

        final Uint8List resizedMarkerIconBytes = byteData!.buffer.asUint8List();

        final marker = Marker(
          markerId: markerId,
          position: LatLng(item.lat!, item.lng!),
          icon: BitmapDescriptor.fromBytes(resizedMarkerIconBytes),
          // infoWindow: InfoWindow(
          //   title: item.itemId!,
          //   snippet: 'Distance: ${distance.toStringAsFixed(2)} km',
          // ),
          onTap: () {
            _goToItemDetailPage(item.itemId!);
          },
        );

        setState(() {
          _markers.add(marker);
        });
      }
    }
  }

  Future<List<Item>> getNearbyItems(LatLng location) async {
    List<Item> nearbyItems =
        (widget.data['items'] as List<dynamic>).map((item) {
      return Item(
        itemId: item['item_id'],
        lat: item['lat'],
        lng: item['lng'],
        img: item['img'][0],
      );
    }).toList();

    for (Item item in nearbyItems) {
      item.markerIconBytes = await loadNetworkImage(
        'https://wealthi-re.s3.ap-southeast-1.amazonaws.com/image/' + item.img!,
      );
    }

    return nearbyItems;
  }

  Future<Uint8List?> loadNetworkImage(String path) async {
    final Completer<ui.Image> completer = Completer();
    final Uri uri = Uri.parse(path);
    final NetworkImage networkImage = NetworkImage(uri.toString());

    networkImage
        .resolve(ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo info, bool _) {
      completer.complete(info.image);
    }));

    final ui.Image image = await completer.future;
    final ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const int radiusOfEarth = 6371; // Radius of the Earth in kilometers
    final double dLat = degreesToRadians(lat2 - lat1);
    final double dLon = degreesToRadians(lon2 - lon1);
    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(degreesToRadians(lat1)) *
            cos(degreesToRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    final double distance = radiusOfEarth * c;
    return distance;
  }

  double degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }

  void _goToItemDetailPage(String itemId) {
    final item = widget.data['items'].firstWhere(
      (item) => item['item_id'] == itemId,
    );
    widget.data['index'] = widget.data['items'].indexOf(item);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Detail(data: widget.data),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(target: _center, zoom: 11.0),
        onTap: _onMarkerTapped,
        markers: _markerLocation != null
            ? {
                // Marker(
                //   markerId: const MarkerId('Pin_1'),
                //   position: _markerLocation!,
                // ),
                ..._markers,
              }
            : {},
      ),
    );
  }
}

class Item {
  final String? itemId;
  final double? lat;
  final double? lng;
  final String? img;
  Uint8List? markerIconBytes;

  Item({this.itemId, this.lat, this.lng, this.img});
}


  // void _goToItemDetailPage(String itemId) {
  //   final item = widget.data['items'].firstWhere(
  //     (item) => item['item_id'] == itemId,
  //   );
  //   widget.data['index'] = widget.data['items'].indexOf(item);

  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => Detail(data: widget.data),
  //     ),
  //   );
  // }