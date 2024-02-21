import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:tasbih/colors.dart';
import 'package:tasbih/screens/surah_page.dart';

import '../models/allahname_model.dart';
import '../models/surah_list_model.dart';

class AllahNameScreen extends StatefulWidget {
  @override
  _AllahNameScreenState createState() => _AllahNameScreenState();
}

class _AllahNameScreenState extends State<AllahNameScreen> {
  List<AllahData> allahList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });
    String jsonAssetPath = 'assets/allah_name.json';
    final String respo = await rootBundle.loadString(jsonAssetPath);
    final allahnamelist = AllahName.fromJson(json.decode(respo));
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      allahList = allahnamelist.data ?? [];
      isLoading = false;
    });
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
              top: 35.h,
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
                    padding: const EdgeInsets.only(left: 18.0, right: 12),
                    child: Text(
                      'Name of Allah',
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
              child: Container(
                height: 740,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: allahList.length,
                  itemBuilder: (context, index) {
                    final alname = allahList[index];
                    return Column(
                      children: [
                        Container(
                          height: 64.h,
                          width: 328.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Color.fromARGB(255, 37, 39, 38),
                          ),
                          child: ListTile(
                            leading: Container(
                              height: 45.h,
                              width: 50.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(150),
                                color: Color.fromARGB(255, 97, 255, 181),
                              ),
                              child: Center(
                                child: Text(
                                  alname.number.toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.sp),
                                ),
                              ),
                            ),
                            title: Text(
                              alname.name ?? '',
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              alname.transliteration ?? '',
                              style: const TextStyle(color: Colors.white),
                            ),
                            // trailing: const Icon(
                            //   Icons.arrow_forward_ios,
                            //   color: Colors.white,
                            // ),
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
