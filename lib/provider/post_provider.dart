import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasbih/api_services/barkat_service.dart';

import '../models/post_model.dart';

class PostProvider extends ChangeNotifier {
  List<Posts> _postList = [];
  List<Posts> get postList => _postList;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future getAllPost() async {
    _isLoading = true;
    _postList.clear;
    notifyListeners();
    var respo = await BarkatService.instance.getAllPost();
    print('rabin ${respo.toString()}');
    if (respo != null) {
      _postList = respo;
      _isLoading = false;
    }
    notifyListeners();
  }

  Future getMyPost() async {
    _isLoading = true;
    _postList.clear;

    notifyListeners();
    var respo = await BarkatService.instance.getMyPost();
    print('rabin ${respo.toString()}');
    if (respo != null) {
      _postList = respo;
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addPost(String? text, File? img) async {
    _isLoading = true;
    notifyListeners();
    Map<String, String> payload = {
      'caption': text ?? '',
    };
    if (img != null) {
      final bytes = await img.readAsBytes();
      final base64Image = base64Encode(bytes);
      payload['image'] = base64Image;
    }

    bool respo = await BarkatService.instance.addPost(payload);
    if (respo == true) {
      getMyPost();
      _isLoading = false;
      notifyListeners();

      return true;
      // Get.back();
    }
    notifyListeners();
    return false;
  }

  Future<bool> deleteMyPost(int? id) async {
    _isLoading = true;
    notifyListeners();

    bool respo = await BarkatService.instance.deleteMyPost(id);
    if (respo == true) {
      getMyPost();
      _isLoading = false;
      notifyListeners();
      return true;
      // Get.back();
    }
    notifyListeners();
    return false;
  }
}
