import 'package:flutter/services.dart';
import 'dart:convert';
import '../model/JsonData.dart';

class JsonService {
  Future<List<AddressData>> getAddressData() async {
    final data = await rootBundle.loadString('assets/address.json');
    var jsonData = json.decode(data) as List;
    return jsonData.map((e) => AddressData.fromJson(e)).toList();
  }

  List<AddressData> filterAddressDataByZipcode(
      List<AddressData> fetchedData, String input) {
    List<AddressData> filteredData = [];

    for (var data in fetchedData) {
      if (data.getZipcode() != null && data.getZipcode()!.contains(input)) {
        filteredData.add(data);
      }
      if (data.getDistrict() != null && data.getDistrict()!.contains(input)) {
        filteredData.add(data);
      }
      if (data.getProvince() != null && data.getProvince()!.contains(input)) {
        filteredData.add(data);
      }
      if (data.getAmphoe() != null && data.getAmphoe()!.contains(input)) {
        filteredData.add(data);
      }
    }

    return filteredData;
  }
  //return jsonData.map((e) => AddressData.fromJson(e)).toList();

  List<AddressData> filterAddressDataByUser(
      List<AddressData> fetchedData, String input) {
    List<AddressData> filteredData = [];
    List<String> data2 = [];
    List<Map> data3 = [];
    for (var data in fetchedData) {
      if (data.getAmphoe() != null && data.getAmphoe()!.contains(input)) {
        data2.add(jsonEncode({"amphoe": data.getAmphoe()}));
        data2.add(jsonEncode({"province": data.getProvince()}));

        filteredData.add(data);
      }
      if (data.getProvince() != null && data.getProvince()!.contains(input)) {
        filteredData.add(data);
      }
    }
    var uniqueData2 = data2.toSet().toList();
    for (var data in uniqueData2) {
      data3.add(jsonDecode(data));
    }

    print(data3);

    return filteredData;
  }
}
