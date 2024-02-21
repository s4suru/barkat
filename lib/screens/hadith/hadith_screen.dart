import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:tasbih/colors.dart';
import 'package:tasbih/screens/hadith/hadith_categorywise_screen.dart';
import 'package:tasbih/screens/surah_page.dart';

import '../../models/allahname_model.dart';
import '../../models/surah_list_model.dart';

class HadithScreen extends StatefulWidget {
  @override
  _HadithScreenState createState() => _HadithScreenState();
}

class _HadithScreenState extends State<HadithScreen> {
  bool isLoading = false;
  List _hList = [];
  final List<String> _translang = [
    'English',
    'Urdu',
    'Arabic',
    'Bengali',
    'Hindi'
  ];
  final List<String> _transLangCode = ['en', 'ur', 'ar', 'bn', 'hi'];
  String selectedLang = 'English';
  String selectedLangCode = 'en';

  @override
  void initState() {
    super.initState();
    fetchData(_transLangCode[0]);
  }

  Future<void> fetchData(String lang) async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get(Uri.parse(
        'https://hadeethenc.com/api/v1/categories/roots/?language=$lang'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      setState(() {
        selectedLang = _translang[_transLangCode.indexOf(lang)];
        selectedLangCode = lang;
        _hList = jsonResponse ?? [];
        isLoading = false;
      });
    } else {
      print('Request failed with status: ${response.statusCode}');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              "assets/images/secondary_background.png",
            ),
            fit: BoxFit.cover,
          ),
          // color: Color(0xffD2FED9)
        ),
        child: Stack(
          children: [
            Positioned(
              top: 30.h,
              left: 16.w,
              right: 16.w,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.white),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Color.fromARGB(255, 20, 19, 19),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0, right: 12),
                    child: Text(
                      'Hadiths',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
                top: 70.h,
                left: 8.w,
                right: 8.w,
                child: SizedBox(
                  height: 60,
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: _translang.length,
                    itemBuilder: (context, index) {
                      return SingleChildScrollView(
                        child: InkWell(
                          onTap: () {
                            fetchData(_transLangCode[index]);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.green),
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            padding: const EdgeInsets.all(8),
                            height: 40,
                            child: Row(
                              children: [
                                Text(
                                  _translang[index],
                                  style: const TextStyle(color: Colors.white),
                                ),
                                Visibility(
                                    visible: selectedLang == _translang[index],
                                    child: Container(
                                        margin: const EdgeInsets.only(left: 4),
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white),
                                        child: const Icon(
                                          Icons.check,
                                          size: 16,
                                          color: Colors.green,
                                        )))
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )),
            Positioned(
              top: 90.h,
              left: 8.w,
              right: 8.w,
              child: Container(
                height: 700.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: ListView.builder(
                  itemCount: _hList.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Container(
                          height: 64.h,
                          width: 328.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: const Color.fromARGB(255, 37, 39, 38),
                          ),
                          child: Center(
                            child: ListTile(
                              onTap: () => Get.to(HadithByCategoryScreen(
                                  hadith: _hList[index],
                                  lang: selectedLangCode)),
                              leading: Container(
                                height: 45.h,
                                width: 50.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(150),
                                  color:
                                      const Color.fromARGB(255, 97, 255, 181),
                                ),
                                child: Center(
                                  child: Text(
                                    _hList[index]['id'].toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.sp),
                                  ),
                                ),
                              ),
                              title: Text(
                                _hList[index]['title'] ?? '',
                                style: const TextStyle(color: Colors.white),
                              ),
                              trailing: const Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        )
                      ],
                    );
                  },
                ),
              ),
            ),
            if (isLoading)
              Center(
                  child: Center(
                      child: Container(
                height: 96,
                width: 96,
                margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: AppColors.colorPrimaryDark,
                    borderRadius: BorderRadius.circular(12)),
                child: const Center(
                    child: CircularProgressIndicator(
                  color: Colors.white,
                )),
              ))),
          ],
        ),
      ),
    );
  }
}
