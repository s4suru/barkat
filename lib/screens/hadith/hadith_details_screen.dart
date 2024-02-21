import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:tasbih/colors.dart';
import 'package:tasbih/screens/hadith/hadith_detail_screen.dart';
import 'package:tasbih/screens/surah_page.dart';

import '../../models/allahname_model.dart';
import '../../models/hadiths_model.dart';
import '../../models/surah_list_model.dart';

class HadithDetailsScreen extends StatefulWidget {
  final String id;
  String lang;
  HadithDetailsScreen({super.key, required this.id, required this.lang});
  @override
  _HadithDetailsScreenState createState() => _HadithDetailsScreenState();
}

class _HadithDetailsScreenState extends State<HadithDetailsScreen> {
  bool isLoading = false;
  Hadith? _hdetail;
  final List<String> _translang = [
    'English',
    'Urdu',
    'Arabic',
    'Bengali',
    'Hindi'
  ];
  final List<String> _transLangCode = ['en', 'ur', 'ar', 'bn', 'hi'];
  String selectedLang = '';
  @override
  void initState() {
    super.initState();
    fetchData(widget.lang);
  }

  Future<void> fetchData(String lang) async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get(Uri.parse(
        'https://hadeethenc.com/api/v1/hadeeths/one/?language=$lang&id=${widget.id}'));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      setState(() {
        selectedLang = _translang[_transLangCode.indexOf(lang)];
        _hdetail = Hadith.fromJson(jsonResponse);
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
              top: 34.h,
              left: 20.w,
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
                    padding: const EdgeInsets.only(left: 12.0, right: 12),
                    child: Text(
                      'Back',
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
                top: 80.h,
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
            Visibility(
              visible: !isLoading && _hdetail?.title != null,
              child: Positioned(
                top: 114.h,
                left: 8.w,
                right: 8.w,
                child: Container(
                  height: 680,
                  width: double.infinity,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(24)),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Container(
                            // height: 100,
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 37, 39, 38),
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              '${_hdetail?.grade} - ${_hdetail?.attribution}',
                              textAlign: TextAlign.justify,
                              maxLines: 3,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  letterSpacing: .2),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            padding: const EdgeInsets.all(10),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                // color: Colors.green.shade300,
                                color: const Color.fromARGB(255, 37, 39, 38),
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 4),
                                    decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: const Text('Title',
                                        style: TextStyle(color: Colors.white))),
                                Text(
                                  '${_hdetail?.title}',
                                  textAlign: TextAlign.justify,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      letterSpacing: .2),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                // color: Colors.green.shade300,
                                color: const Color.fromARGB(255, 37, 39, 38),
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 4),
                                    decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: const Text('Hadeeth',
                                        style: TextStyle(color: Colors.white))),
                                Text(
                                  '${_hdetail?.hadeeth}',
                                  textAlign: TextAlign.justify,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      letterSpacing: .2),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: _hdetail?.explanation != null,
                            child: Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(top: 10),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 37, 39, 38),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14, vertical: 4),
                                      decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.circular(5)),
                                      child: const Text(
                                        'Explanation',
                                        style: TextStyle(color: Colors.white),
                                      )),
                                  Text(
                                          '${_hdetail?.explanation}',
                                          textAlign: TextAlign.justify,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              letterSpacing: .2),
                                        ),
                                ],
                              ),
                            ),
                          ),
                          Visibility(
                            visible: _hdetail?.hints?.length != 0,
                            child: Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(top: 10),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  // color: Colors.green.shade300,
                                  color: const Color.fromARGB(255, 37, 39, 38),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14, vertical: 4),
                                      decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: const Text('Hints',
                                          style:
                                              TextStyle(color: Colors.white))),
                                  Text(
                                    '${_hdetail?.hints!.map((e) => e.toString().replaceAll(RegExp(r'[()]'), ''))}',
                                    textAlign: TextAlign.justify,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        letterSpacing: .2),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (!isLoading && _hdetail?.title == null)
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Sorry!',
                        style: TextStyle(
                            color: Colors.white,
                            letterSpacing: .2,
                            fontSize: 18)),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      'Translation not available in $selectedLang',
                      style: const TextStyle(
                          color: Colors.white, letterSpacing: .2, fontSize: 14),
                    ),
                  ],
                ),
              ),
            if (isLoading)
              Center(
                  child: Center(
                      child: Container(
                height: 96,
                width: 96,
                margin: const EdgeInsets.symmetric(horizontal: 20),
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
