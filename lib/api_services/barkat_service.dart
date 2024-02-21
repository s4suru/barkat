import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasbih/constant/app_constant.dart';
import 'package:tasbih/models/post_model.dart';
import 'package:tasbih/screens/login_screen.dart';

import '../models/community_model.dart';

class BarkatService {
  BarkatService._();
  static final BarkatService _instance = BarkatService._();
  static get instance => _instance;

  Future<bool> login(String email, String password) async {
    var payload = {'email': email, 'password': password};
    var response = await http.post(Uri.parse('${AppConstants.SERVER_URL}login'),
        body: payload);
    var data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['status'] == true) {
      await SharedPreferences.getInstance().then((value) {
        value.setBool("isLoggedIn", true);
        value.setString("name", data['data']['name'] ?? "");
        value.setString("email", data['data']['email'] ?? "");
        value.setString("phone", data['data']['phone'] ?? "");
        value.setString("token", data['data']['remember_token'] ?? "");
        value.setString("password", password ?? "");
        value.setInt('user_id', data['data']['id'] as int);
      });
      return true;
    }
    return false;
  }

  Future<bool> logOut() async {
    var pref = await SharedPreferences.getInstance();
    String? token = pref.getString("token");
    var headers = {
      'Accept': 'application/json',
      "Authorization": "Bearer $token"
    };
    var response = await http
        .post(Uri.parse('${AppConstants.SERVER_URL}logout'), headers: headers);
    var data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['status'] == true) {
      await SharedPreferences.getInstance().then((value) {
        value.remove("isLoggedIn");
        value.remove("name");
        value.remove("token");
        value.remove("user_id");
      });

      return true;
    }
    return false;
  }

  Future<String> register(Map<dynamic, dynamic> payload) async {
    var respo = await http.post(Uri.parse('${AppConstants.SERVER_URL}register'),
        body: (payload));
    if (respo.statusCode == 200 && jsonDecode(respo.body)['status'] == true) {
      return 'success';
    } else if (respo.statusCode == 422) {
      var err = jsonDecode(respo.body)['errors'];
      return err.toString();
    }
    return 'failed';
  }

  Future<List<Posts>> getMyPost() async {
    var pref = await SharedPreferences.getInstance();
    String? token = pref.getString("token");
    var headers = {
      'Accept': 'application/json',
      "Authorization": "Bearer $token"
    };

    List<Posts> plist = [];
    var respo = await http.post(
        Uri.parse('${AppConstants.SERVER_URL}post/view'),
        headers: headers);
    if (respo.statusCode == 200 && jsonDecode(respo.body)['status'] == true) {
      var data = jsonDecode(respo.body)['data'];
      plist = data.map<Posts>((e) => Posts.fromJson(e)).toList();
    }
    return plist;
  }

  Future<List<Posts>> getAllPost() async {
    var pref = await SharedPreferences.getInstance();
    String? token = pref.getString("token");
    var headers = {
      'Accept': 'application/json',
      "Authorization": "Bearer $token"
    };

    List<Posts> plist = [];
    var respo = await http.post(
        Uri.parse('${AppConstants.SERVER_URL}post/view/all'),
        headers: headers);
    if (respo.statusCode == 200 && jsonDecode(respo.body)['status'] == true) {
      var data = jsonDecode(respo.body)['data'];
      plist = data.map<Posts>((e) => Posts.fromJson(e)).toList();
    }
    return plist;
  }

  Future<List<Community>> getAllUsers() async {
    var pref = await SharedPreferences.getInstance();
    String? token = pref.getString("token");
    var headers = {
      'Accept': 'application/json',
      "Authorization": "Bearer $token"
    };

    List<Community> clist = [];
    var respo = await http.post(Uri.parse('${AppConstants.SERVER_URL}users'),
        headers: headers);
    if (respo.statusCode == 200) {
      var data = jsonDecode(respo.body)['data'];
      clist = data.map<Community>((e) => Community.fromJson(e)).toList();
    }
    return clist;
  }

  Future<bool> addPost(Map<String, String> payload) async {
    var pref = await SharedPreferences.getInstance();
    String? token = pref.getString("token");
    var headers = {
      'Accept': 'application/json',
      "Authorization": "Bearer $token"
    };
    print('rabin ${payload.toString()}');

    var respo = await http.post(Uri.parse('${AppConstants.SERVER_URL}post/add'),
        headers: headers, body: payload);
    print('rabin ${respo.body}');

    if (respo.statusCode == 200 && jsonDecode(respo.body)['status'] == true) {
      return true;
    }
    return false;
  }

  Future<bool> updateProfile(Map<String, String> payload) async {
    var pref = await SharedPreferences.getInstance();
    String? token = pref.getString("token");
    var headers = {
      'Accept': 'application/json',
      "Authorization": "Bearer $token"
    };
    print('rabin ${payload.toString()}');

    var respo = await http.post(
        Uri.parse('${AppConstants.SERVER_URL}update/profile'),
        headers: headers,
        body: payload);
    print('rabin ${respo.body}');
    var data = jsonDecode(respo.body);

    if (respo.statusCode == 200 && data['status'] == true) {
      await SharedPreferences.getInstance().then((value) {
        value.setString("name", data['data']['name'] ?? "");
        value.setString("pfimage", data['data']['photo'] ?? "");
        value.setString("phone", data['data']['phone'] ?? "");
      });
      return true;
    }
    return false;
  }

  Future<Community> myProfile() async {
    var pref = await SharedPreferences.getInstance();
    String? token = pref.getString("token");
    var headers = {
      'Accept': 'application/json',
      "Authorization": "Bearer $token"
    };

    // Community clist;
    var respo = await http.post(
        Uri.parse('${AppConstants.SERVER_URL}my/profile'),
        headers: headers);
    print('rabinprof ${respo.body}');
    if (respo.statusCode == 200) {
      var data = jsonDecode(respo.body)['data'];
      return Community.fromJson(data);
    }
    throw Exception();
    // return clist;
  }

  Future<bool> deleteMyPost(int id) async {
    var pref = await SharedPreferences.getInstance();
    String? token = pref.getString("token");
    var headers = {
      'Accept': 'application/json',
      "Authorization": "Bearer $token"
    };
    Map<String, String> payload = {
      'id': '$id',
    };
    var respo = await http.post(
        Uri.parse('${AppConstants.SERVER_URL}post/delete'),
        headers: headers,
        body: payload);
    print('rabin ${respo.body}');
    var data = jsonDecode(respo.body);

    if (respo.statusCode == 200 && data['status'] == true) {
      return true;
    }
    return false;
  }
}
