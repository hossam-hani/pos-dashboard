import 'package:dio/dio.dart';
import 'package:eckit/models/boot_data.dart';

import '../const.dart';


class Boot_Service{

    static Future<BootData> get_bootData() async {
    try {
      Response response = await Dio().get("$baseUrl/boot");
      return BootData.fromJson(response.data);
    } catch (e) {
      print(e);
    }
    return null;
  }


}