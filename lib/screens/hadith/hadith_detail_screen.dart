import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../colors.dart';
import '../../models/hadiths_model.dart';

class HadithDetailScreen extends StatefulWidget {
  final String id;
  const HadithDetailScreen({super.key, required this.id});

  @override
  State<HadithDetailScreen> createState() => _HadithDetailScreenState();
}

class _HadithDetailScreenState extends State<HadithDetailScreen> {
  Hadith? _hdetail;
  bool isLoading = false;
  String langTitle = '';
  @override
  void initState() {
    super.initState();
    fetchData('en');
  }

  Future<void> fetchData(String lang) async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get(Uri.parse(
        'https://hadeethenc.com/api/v1/hadeeths/one/?language=$lang&id=${widget.id}'));

    print('rabin ${response.body}');
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      setState(() {
        _hdetail = Hadith.fromJson(jsonResponse);
        isLoading = false;
        langTitle = setlang(lang);
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            InkWell(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(6),
                // height: 34,width: 34,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.white),
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.green.shade200,
                ),
              ),
            ),
            const SizedBox(
              width: 18,
            ),
            const Text('Details'),
            const SizedBox(
              width: 4,
            ),
            Text('($langTitle)'),
            const Spacer(),
            IconButton(
              onPressed: () => popupForTranslation(),
              icon: const Icon(Icons.translate),
            ),
          ],
        ),
        elevation: 0,
        backgroundColor: Colors.green.shade300,
      ),
      body: isLoading
          ? _showLoadingView()
          : 
          SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.green.shade300,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 4),
                              decoration: BoxDecoration(
                                  color: Colors.blueAccent,
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
                          color: Colors.green.shade300,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 4),
                              decoration: BoxDecoration(
                                  color: Colors.blueAccent,
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
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.green.shade300,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 4),
                              decoration: BoxDecoration(
                                  color: Colors.blueAccent,
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
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.green.shade300,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 4),
                              decoration: BoxDecoration(
                                  color: Colors.blueAccent,
                                  borderRadius: BorderRadius.circular(5)),
                              child: const Text('Hints',
                                  style: TextStyle(color: Colors.white))),
                          Text(
                            '${_hdetail?.hints!.map((e) => e.toString().replaceAll(RegExp(r'[()]'), ''))}',
                            textAlign: TextAlign.justify,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                letterSpacing: .2),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    
    );
  }

  popupForTranslation() async {
    final result = await showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(100, 80, 10, 00),
      items: [
        PopupMenuItem(
          onTap: () => fetchData('ar'),
          child: const Row(children: [
            Icon(LineAwesomeIcons.language),
            SizedBox(width: 2),
            Text('Arabic'),
            // Icon(Icons.check,color: Colors.green,)
          ]),
        ),
        PopupMenuItem(
          onTap: () => fetchData('hi'),
          child: const Row(children: [
            Icon(LineAwesomeIcons.language),
            SizedBox(width: 2),
            Text('Hindi')
          ]),
        ),
        PopupMenuItem(
          onTap: () => fetchData('bn'),
          child: const Row(children: [
            Icon(LineAwesomeIcons.language),
            SizedBox(width: 2),
            Text('Bengali')
          ]),
        ),
        PopupMenuItem(
          onTap: () => fetchData('ur'),
          child: const Row(children: [
            Icon(LineAwesomeIcons.language),
            SizedBox(width: 2),
            Text('Urdu')
          ]),
        ),
        PopupMenuItem(
          onTap: () => fetchData('te'),
          child: const Row(children: [
            Icon(LineAwesomeIcons.language),
            SizedBox(width: 2),
            Text('Telugu')
          ]),
        ),
        PopupMenuItem(
          onTap: () => fetchData('ta'),
          child: const Row(children: [
            Icon(LineAwesomeIcons.language),
            SizedBox(width: 2),
            Text('Tamil')
          ]),
        ),
        PopupMenuItem(
          onTap: () => fetchData('en'),
          child: const Row(children: [
            Icon(LineAwesomeIcons.language),
            SizedBox(width: 2),
            Text('English')
          ]),
        ),
      ],
    );

    // if (result != null) {
    //   if (result == 1) {
    //    fetchData('ar');
    //   }
    // }
  }

  _showLoadingView() {
    return Center(
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
    )));
  }

  String setlang(String lang) {
    String lng = '';
    switch (lang) {
      case 'ar':
        lng = 'Arabic';
        break;
      case 'hi':
        lng = 'Hindi';
        break;

      case 'en':
        lng = 'English';
        break;

      case 'ur':
        lng = 'Urdu';
        break;

      case 'ta':
        lng = 'Tamil';
        break;

      case 'bn':
        lng = 'Bangali';
        break;
      case 'te':
        lng = 'Telugu';
        break;
    }
    return lng;
  }
}
