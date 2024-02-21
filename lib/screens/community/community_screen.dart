import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tasbih/constant/app_constant.dart';
import 'package:tasbih/provider/community_provider.dart';
import 'package:tasbih/provider/post_provider.dart';
import 'package:tasbih/screens/community/com_detail.dart';
import 'package:tasbih/screens/posts/add_post_screen.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  late CommunityProvider communityProvider;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) {
      Provider.of<CommunityProvider>(context, listen: false).getAllUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    communityProvider = Provider.of<CommunityProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade200,
        title: const Text('Barkat Community'),
      ),
      body: communityProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : communityProvider.cList.isEmpty
              ? const Center(child: Text('No users'))
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemCount: communityProvider.cList.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.only(
                                  bottom: 10, left: 8, right: 8, top: 6),
                              height: 120,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.green.withOpacity(0.1),
                                        offset: const Offset(1, 1),
                                        spreadRadius: 0.2,
                                        blurRadius: 8)
                                  ],
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Center(
                                child: ListTile(
                                  onTap: () => Get.to(
                                      () => CommunityDetailScreen(index: index)),
                                  leading: communityProvider.cList[index].photo !=
                                          null
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(50),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                "${AppConstants.PROFILE_IMAGE_URL}${communityProvider.cList[index].photo}",
                                            fit: BoxFit.fitWidth,
                                            height: 60,
                                            width: 60,
                                            placeholder: (context, url) =>
                                                const Center(
                                                    child:
                                                        CircularProgressIndicator(
                                              strokeWidth: 2.0,
                                            )),
                                          ))
                                      : ClipRRect(
                                          borderRadius: BorderRadius.circular(30),
                                          child: Image.asset(
                                            'assets/images/userpf.png',
                                            height: 60,
                                            width: 60,
                                          ),
                                        ),
                                  title: Text(
                                    '${communityProvider.cList[index].name}',
                                    style: TextStyle(
                                        fontSize: 18, letterSpacing: .2),
                                  ),
                                  trailing: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(100),
                                        color: Colors.green.withOpacity(0.1),
                                      ),
                                      child: const Icon(
                                          LineAwesomeIcons.angle_right,
                                          size: 18.0,
                                          color: Colors.grey)),
                                ),
                              ),

                              //   child: Row(
                              //     children: [
                              //       SizedBox(
                              //         width: 20,
                              //       ),
                              //       communityProvider.cList[index].photo != null
                              //           ? ClipRRect(
                              //               borderRadius:
                              //                   BorderRadius.circular(50),
                              //               child: CachedNetworkImage(
                              //                 imageUrl:
                              //                     "${AppConstants.PROFILE_IMAGE_URL}${communityProvider.cList[index].photo}",
                              //                 fit: BoxFit.fill,
                              //                 height: 60,
                              //                 width: 60,
                              //                 placeholder: (context, url) =>
                              //                     const Center(
                              //                         child:
                              //                             CircularProgressIndicator(
                              //                   strokeWidth: 2.0,
                              //                 )),
                              //               ))
                              //           : ClipRRect(
                              //               borderRadius:
                              //                   BorderRadius.circular(30),
                              //               child: Image.asset(
                              //                 'assets/images/logo.png',
                              //                 height: 60,
                              //                 width: 60,
                              //               ),
                              //             ),
                              //       SizedBox(
                              //         width: 20,
                              //       ),
                              //       Column(
                              //         mainAxisAlignment:
                              //             MainAxisAlignment.center,
                              //         crossAxisAlignment:
                              //             CrossAxisAlignment.start,
                              //         children: [
                              //           Text(
                              //             '${communityProvider.cList[index].name}',
                              //             style: TextStyle(
                              //                 fontSize: 18, letterSpacing: .2),
                              //           ),
                              //           // Text(
                              //           //     '${communityProvider.cList[index].email}'),
                              //           // Text(
                              //           //     '${communityProvider.cList[index].phone}')
                              //         ],
                              //       )
                              //     ],
                              //   ),
                            );
                          }),
                    )
                  ],
                ),
    );
  }
}
