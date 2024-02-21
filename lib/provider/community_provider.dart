import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasbih/api_services/barkat_service.dart';

import '../models/community_model.dart';
import '../models/post_model.dart';

class CommunityProvider extends ChangeNotifier {
  List<Community> _cList = [];
  List<Community> get cList => _cList;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future getAllUsers() async {
    _isLoading = true;
    _cList.clear;
    notifyListeners();
    var respo = await BarkatService.instance.getAllUsers();
    print('rabin ${respo.toString()}');
    if (respo != null) {
      _cList = respo;
      _isLoading = false;
    }
    notifyListeners();
  }

  Future<bool> updateProfile(String? name, String? phone, File? img) async {
    Map<String, String> payload = {'name': name ?? '', 'phone': phone ?? ''};
    if (img != null) {
      final bytes = await img.readAsBytes();
      final base64Image = base64Encode(bytes);
      payload['image'] = base64Image;
    }
    bool respo = await BarkatService.instance.updateProfile(payload);
    myProfile();
    notifyListeners();
    return respo;
  }

  Community _community = Community();
  Community get community => _community;

  Future myProfile() async {
    _isLoading = true;
    notifyListeners();
    _community = await BarkatService.instance.myProfile();

    _isLoading = false;
    // }
    notifyListeners();
  }
}
