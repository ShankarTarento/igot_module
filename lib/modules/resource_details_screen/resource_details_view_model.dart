import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:igot_module/modules/data_models/gyaan_karmayogi_resource_details.dart';
import 'package:igot_module/modules/utils/helper.dart';
import 'package:url_launcher/url_launcher.dart';

class ResourceDetailsViewModel {
  static Future<ResourceDetails> getCourseDetails(
      {@required String token,
      @required String baseUrl,
      @required String id,
      @required String wid,
      @required String apiKey,
      @required String rootOrgId}) async {
    ResourceDetails resourceDetails;
    Response res = await get(Uri.parse('$baseUrl/api/content/v1/read/$id'),
        headers: ModuleHelper.getHeaders(
            token: token, wid: wid, rootOrgId: rootOrgId, apiKey: apiKey));
    if (res.statusCode == 200) {
      var courseDetails = jsonDecode(res.body);

      resourceDetails =
          ResourceDetails.fromJson(courseDetails['result']['content']);
      return resourceDetails;
    } else {
      return null;
    }
  }

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

  static void launchURL({@required String url}) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
}
