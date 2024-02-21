import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:tasbih/api_services/hadith_service.dart';
import 'package:tasbih/colors.dart';
import 'package:tasbih/screens/hadith/hadith_detail_screen.dart';
import 'package:tasbih/screens/surah_page.dart';
import '../../models/allahname_model.dart';
import '../../models/surah_list_model.dart';
import 'hadith_details_screen.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class HadithByCategoryScreen extends StatefulWidget {
  // final String id;
  var hadith;
  String lang;
  HadithByCategoryScreen({super.key, required this.hadith, required this.lang});
  @override
  _HadithByCategoryScreenState createState() => _HadithByCategoryScreenState();
}

class _HadithByCategoryScreenState extends State<HadithByCategoryScreen> {
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
  String selectedLang = '';
  String? selectedLangCode;
  final int _pageSize = 10;

  final PagingController<int, dynamic> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(
          id: widget.hadith['id'],
          lang: selectedLangCode ?? widget.lang,
          pageKey: pageKey,
          isreset: false);
    });
    super.initState();
    // fetchData(widget.lang);
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  Future<void> _fetchPage(
      {dynamic id, String? lang, int? pageKey, bool? isreset}) async {
    try {
      isLoading = true;
      selectedLang = _translang[_transLangCode.indexOf(lang!)];

      if (isreset == true) {
        _pagingController.itemList!.clear();
      }
      final newItems =
          await ApiService.getHadithByCategory(id, lang, pageKey!, _pageSize);
      final isLastPage = newItems!.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
      setState(() {
        isLoading = false;
      });
    } catch (error) {
      // _pagingController.error = error;
    }
  }

  // Future<void> fetchData(String lang) async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   final response = await http.get(Uri.parse(
  //       'https://hadeethenc.com/api/v1/hadeeths/list/?language=$lang&category_id=${widget.hadith['id']}&page=1&per_page=20'));

  //   if (response.statusCode == 200) {
  //     final jsonResponse = json.decode(response.body)['data'];
  //     setState(() {
  //       selectedLang = _translang[_transLangCode.indexOf(lang)];
  //       selectedLangCode = lang;
  //       _hList = jsonResponse ?? [];
  //       isLoading = false;
  //     });
  //   } else {
  //     print('Request failed with status: ${response.statusCode}');
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

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
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0, right: 12),
                      child: Column(
                        children: [
                          Text(
                            '${widget.hadith['title']}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
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
                            _fetchPage(
                                id: widget.hadith['id'],
                                lang: _transLangCode[index],
                                pageKey: 1,
                                isreset: true);
                            setState(() {
                              selectedLangCode = _transLangCode[index];
                            });
                            // fetchData(_transLangCode[index]);
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
              top: 114.h,
              left: 8.w,
              right: 8.w,
              child: Container(
                  height: 680,
                  width: double.infinity,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(24)),
                  child:
                      // ListView.builder(
                      //   physics: const BouncingScrollPhysics(),
                      //   itemCount: _hList.length,
                      //   itemBuilder: (context, index) {
                      //     return
                      //         // Column(
                      //         //   children: [
                      //         Container(
                      //       height: 68.h,
                      //       width: 328.w,
                      //       margin: const EdgeInsets.all(4),
                      //       decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(12),
                      //         color: const Color.fromARGB(255, 37, 39, 38),
                      //       ),
                      //       child: Center(
                      //         child: ListTile(
                      //           onTap: () => Get.to(HadithDetailsScreen(
                      //             id: '${_hList[index]['id']}',
                      //             lang: selectedLangCode,
                      //           )),
                      //           leading: Container(
                      //             height: 40.h,
                      //             width: 45.w,
                      //             // padding: EdgeInsets.all(10),
                      //             decoration: const BoxDecoration(
                      //               shape: BoxShape.circle,
                      //               color: Color.fromARGB(255, 97, 255, 181),
                      //             ),
                      //             child: Center(
                      //               child: Text(
                      //                 ' ${index + 1}',
                      //                 style: TextStyle(
                      //                     color: Colors.white,
                      //                     fontWeight: FontWeight.bold,
                      //                     fontSize: 18.sp),
                      //               ),
                      //             ),
                      //           ),
                      //           title: Text(
                      //             _hList[index]['title'].toString(),
                      //             maxLines: 3,
                      //             overflow: TextOverflow.ellipsis,
                      //             style: const TextStyle(color: Colors.white),
                      //           ),
                      //           // subtitle: Text(
                      //           //   alname.transliteration ?? '',
                      //           //   style: const TextStyle(color: Colors.white),
                      //           // ),
                      //           trailing: const Icon(
                      //             Icons.arrow_forward_ios,
                      //             color: Colors.white,
                      //           ),
                      //         ),
                      //       ),
                      //     );
                      //     // SizedBox(
                      //     //   height: 10.h,
                      //     // )
                      //     //   ],
                      //     // );
                      //   },
                      // ),
                      PagedListView<int, dynamic>(
                          physics: const BouncingScrollPhysics(),
                          pagingController: _pagingController,
                          builderDelegate: PagedChildBuilderDelegate<dynamic>(
                              noItemsFoundIndicatorBuilder: (context) =>
                                  loadingIndicator(),
                              firstPageProgressIndicatorBuilder: (context) =>
                                  loadingIndicator(),
                              itemBuilder: (_, item, index) =>
                                  _buildList(item, index)))),
            ),
            // if (isLoading) loadingIndicator()
          ],
        ),
      ),
    );
  }

  loadingIndicator() {
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

  _buildList(item, index) {
    return Container(
      height: 68.h,
      width: 328.w,
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color.fromARGB(255, 37, 39, 38),
      ),
      child: Center(
        child: ListTile(
          onTap: () {
            print('rabin $selectedLangCode');
          },
          // Get.to(HadithDetailsScreen(
          //   id: item['id'],
          //   lang: selectedLangCode ?? widget.lang,
          // )),
          leading: Container(
            height: 40.h,
            width: 45.w,
            // padding: EdgeInsets.all(10),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromARGB(255, 97, 255, 181),
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp),
              ),
            ),
          ),
          title: Text(
            item['title'].toString(),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white),
          ),
          // subtitle: Text(
          //   alname.transliteration ?? '',
          //   style: const TextStyle(color: Colors.white),
          // ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            color: Colors.white,
          ),
        ),
      ),
    );
    // SizedBox(
    //   height: 10.h,
    // )
    //   ],
    // );
  }
}
