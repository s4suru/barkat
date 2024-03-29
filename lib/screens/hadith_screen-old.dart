import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../api_services/hadith_service.dart';
import '../colors.dart';
import '../models/hadith_model.dart';

class HadithListView extends StatefulWidget {
  @override
  _HadithListViewState createState() => _HadithListViewState();
}

class _HadithListViewState extends State<HadithListView> {
  final PageController _pageController = PageController();
  int currentIndex = 0;
  bool isLoading = true;
  List _hadith = [];
  @override
  void initState() {
    super.initState();
    // fetchHadith();
    readJson();
  }

  // Future<void> fetchHadith() async {
  //   try {
  //     final hadithService = ApiService();
  //     final fetchedHadith = await hadithService.fetchHadithList();
  //     setState(() {
  //       hadithList = fetchedHadith;
  //       isLoading = false;
  //     });
  //   } catch (e) {
  //     print('Error fetching hadith: $e');
  //     // Handle error
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

  Future<void> readJson() async {
    String jsonAssetPath = 'assets/hadith.json';

    final String response = await rootBundle.loadString(jsonAssetPath);
    final data = await json.decode(response);
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _hadith = data['data'];
      isLoading = false;
    });
  }

  void changePage() {
    setState(() {
      final random = Random();
      currentIndex = random.nextInt(_hadith.length);
      // currentIndex = random.nextInt(7);
      _pageController.jumpToPage(
        currentIndex,
      );
    });
  }

  // Widget buildHadithContent(HadithApiModel hadith) {
  buildHadithContent(dynamic hadith) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 36.0),
            child: Text(
              hadith['h_ar'] ?? '',
              style: TextStyle(
                color: AppColors.colorWhiteMidEmp,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Text(
              hadith['h_hi'] ?? '',
              style: TextStyle(
                color: AppColors.colorWhiteMidEmp,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),

          SizedBox(height: 16.h),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Text(
              hadith['h_np'] ?? '',
              style: TextStyle(
                color: AppColors.colorWhiteMidEmp,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),

          // SizedBox(height: 26.h),
          // Padding(
          //   padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          //   child: Text(
          //     // 'Sahih Muslim (IFA), Chapter 01, Hadith no ${hadith.hadithNo ?? ''}',
          //     'Sahih Muslim (IFA), Chapter 01, Hadith no }',
          //     style: TextStyle(
          //       color: AppColors.colorWhiteMidEmp,
          //       fontSize: 14.sp,
          //       fontWeight: FontWeight.w400,
          //     ),
          //   ),
          // ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  Widget buildLoadingIndicator() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
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
        ),
        SizedBox(
          height: 5.h,
        ),
        const Text(
          'Please wait.....',
          style: TextStyle(color: Colors.white),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/secondary_background.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 45.h,
              left: 20.w,
              right: 16.w,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 12),
                    child: Text(
                      'hadith'.tr,
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
                height: 500.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: isLoading
                    ? buildLoadingIndicator()
                    : PageView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        controller: _pageController,
                        itemCount: _hadith.length,
                        // itemCount: 7,
                        itemBuilder: (context, index) {
                          // final hadith = hadithList[7];
                          return buildHadithContent(_hadith[index]);
                          // return buildHadithContent();
                        },
                      ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: changePage,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 40),
                  height: 50.h,
                  width: 96.w,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.colorButtonGradientStart,
                        AppColors.colorButtonGradientEnd,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.colorWhiteHighEmp,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
