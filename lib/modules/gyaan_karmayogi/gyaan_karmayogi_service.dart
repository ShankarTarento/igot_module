import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:igot_module/modules/data_models/gyaan_karmayogi_resource_model.dart';
import 'package:igot_module/modules/utils/helper.dart';

class GyaanKarmayogiService {
  static Future<List<dynamic>> getGyaanConfig(
      {@required String token,
      @required String apiKey,
      @required String wid,
      @required String apiUrl,
      @required String rootOrgId}) async {
    Response response = await get(
      Uri.parse(
          '$apiUrl/assets/configurations/feature/knowledge-resource.json'),
      headers: ModuleHelper.getHeaders(
          token: token, wid: wid, rootOrgId: rootOrgId, apiKey: apiKey),
    );

    var data = jsonDecode(response.body);
    List<dynamic> categories = data["allowedCategories"];

    return categories;
  }

  static Future<List<GyaanKarmayogiResource>> getGyaanKarmaYogiResources(
      {@required String authToken,
      @required String apiUrl,
      @required String wid,
      @required String apiKey,
      @required Map<String, dynamic> requestBody,
      @required String baseUrl,
      @required String deptId}) async {
    List<GyaanKarmayogiResource> gyaanKarmayogiResource = [];

    var body = json.encode(requestBody);
    Response response = await post(Uri.parse(apiUrl),
        headers: ModuleHelper.postHeaders(
          apiBaseUrl: baseUrl,
          apiKey: apiKey,
          rootOrgId: deptId,
          token: authToken,
          wid: wid,
        ),
        body: body);

    if (response.statusCode == 200) {
      var contents = jsonDecode(response.body);
      List resources = contents["result"]["content"];

      for (var resource in resources) {
        gyaanKarmayogiResource.add(GyaanKarmayogiResource.fromJson(resource));
      }
    } else {
      debugPrint("#######################---error");
    }
    return gyaanKarmayogiResource;
  }
}
