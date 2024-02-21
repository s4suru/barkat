import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasbih/api_services/barkat_service.dart';
import 'package:tasbih/screens/login_screen.dart';
import 'package:tasbih/screens/posts/post_screen.dart';
import 'package:tasbih/screens/profile/profile_menu_widget.dart';
import 'package:tasbih/screens/profile/profile_update_screen.dart';

import '../../constant/app_constant.dart';
import '../../languageSelectionScreen.dart';
import '../../provider/community_provider.dart';

class CommunityDetailScreen extends StatefulWidget {
  CommunityDetailScreen({Key? key, required this.index}) : super(key: key);

  int index;
  @override
  State<CommunityDetailScreen> createState() => _CommunityDetailScreenState();
}

class _CommunityDetailScreenState extends State<CommunityDetailScreen> {
  Color tPrimaryColor = Colors.green.shade200;
  late CommunityProvider communityProvider;
  String? name, email;
  String image = '';
  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) {
      // Provider.of<CommunityProvider>(context, listen: false).myProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    // var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    communityProvider = Provider.of<CommunityProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: tPrimaryColor,
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(LineAwesomeIcons.angle_left)),
        title: Text(
          'Detail Info',
        ),
        // actions: [
        //   IconButton(
        //       onPressed: () {},
        //       icon: Icon(isDark ? LineAwesomeIcons.sun : LineAwesomeIcons.moon))
        // ],
      ),
      body: communityProvider.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    /// -- IMAGE
                    Stack(
                      children: [
                        SizedBox(
                            width: double.infinity,
                            height: 320,
                            child: communityProvider
                                        .cList[widget.index].photo !=
                                    null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          "${AppConstants.PROFILE_IMAGE_URL}${communityProvider.cList[widget.index].photo}",
                                      fit: BoxFit.fitWidth,
                                      height: 60,
                                      width: 60,
                                      placeholder: (context, url) =>
                                          const Center(
                                              child: CircularProgressIndicator(
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
                                  )
                            // decoration: BoxDecoration(
                            //     borderRadius: BorderRadius.circular(30),
                            //     border: Border.all(
                            //       color: Colors.green,
                            //       width: 2.0,
                            //     ),
                            //     image:
                            //         communityProvider.cList[widget.index].photo !=
                            //                 null
                            //             ? DecorationImage(
                            //                 image:
                            //                 NetworkImage(
                            //                     "${AppConstants.PROFILE_IMAGE_URL}${communityProvider.cList[widget.index].photo}"),
                            //                 fit: BoxFit.fitWidth,
                            //               )
                            //             : const DecorationImage(
                            //                 image: NetworkImage(
                            //                   "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTf-H0m8PLT9RhcZM6yR4cAR1T7K29zmMgUo_hTwYmzBw&s",
                            //                 ),
                            //                 fit: BoxFit.cover,
                            //               )),

                            ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text('${communityProvider.cList[widget.index].name}',
                        style: Theme.of(context).textTheme.headline4),
                    Text('${communityProvider.cList[widget.index].email}',
                        style: Theme.of(context).textTheme.bodyText2),
                    const SizedBox(height: 20),

                    const SizedBox(height: 10),
                    const Divider(),
                    const SizedBox(height: 10),

                    /// -- MENU
                    ProfileMenuWidget(
                        title: '${communityProvider.cList[widget.index].name}',
                        icon: LineAwesomeIcons.user,
                        onPress: () {}),
                    ProfileMenuWidget(
                        title: '${communityProvider.cList[widget.index].email}',
                        icon: Icons.email,
                        onPress: () {}),
                    ProfileMenuWidget(
                        title: '${communityProvider.cList[widget.index].phone}',
                        icon: LineAwesomeIcons.phone,
                        onPress: () {}),

                    const Divider(),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
    );
  }
}
