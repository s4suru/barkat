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

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Color tPrimaryColor = Colors.green.shade200;
  late CommunityProvider communityProvider;
  String? name, email;
  String image = '';
  @override
  void initState() {
    getSharedData();
    super.initState();
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) {
      Provider.of<CommunityProvider>(context, listen: false).myProfile();
    });
  }

  getSharedData() async {
    await SharedPreferences.getInstance().then((value) {
      setState(() {
        name = value.getString('name');
        email = value.getString('email');
      });
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
          'Profile',
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
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.green,
                                width: 3.0,
                              ),
                              image: communityProvider.community.photo != null
                                  ? DecorationImage(
                                      image: NetworkImage(
                                          "${AppConstants.PROFILE_IMAGE_URL}${communityProvider.community.photo}"),
                                      fit: BoxFit.cover,
                                    )
                                  : const DecorationImage(
                                      image: NetworkImage(
                                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTf-H0m8PLT9RhcZM6yR4cAR1T7K29zmMgUo_hTwYmzBw&s",
                                      ),
                                      fit: BoxFit.cover,
                                    )),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: InkWell(
                            onTap: () =>
                                Get.to(() => const UpdateProfileScreen()),
                            child: Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: tPrimaryColor),
                              child: const Icon(
                                LineAwesomeIcons.alternate_pencil,
                                color: Colors.black,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text('${communityProvider.community.name}',
                        style: Theme.of(context).textTheme.headline4),
                    Text('${communityProvider.community.email}',
                        style: Theme.of(context).textTheme.bodyText2),
                    const SizedBox(height: 20),

                    /// -- BUTTON
                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () =>
                            Get.to(() => const UpdateProfileScreen()),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: tPrimaryColor,
                            side: BorderSide.none,
                            shape: const StadiumBorder()),
                        child: Text('Edit Profile',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Divider(),
                    const SizedBox(height: 10),

                    /// -- MENU
                    ProfileMenuWidget(
                        title: "Change Language",
                        icon: LineAwesomeIcons.cog,
                        onPress: () => Get.to(const SetLanguage())),
                    ProfileMenuWidget(
                        title: "My Posts",
                        icon: LineAwesomeIcons.wallet,
                        onPress: () => Get.to(const PostScreen())),
                    // ProfileMenuWidget(
                    //     title: "User Management",
                    //     icon: LineAwesomeIcons.user_check,
                    //     onPress: () {}),
                    const Divider(),
                    const SizedBox(height: 10),
                    // ProfileMenuWidget(
                    //     title: "Information",
                    //     icon: LineAwesomeIcons.info,
                    //     onPress: () {}),
                    ProfileMenuWidget(
                        title: "Logout",
                        icon: LineAwesomeIcons.alternate_sign_out,
                        textColor: Colors.red,
                        endIcon: false,
                        onPress: () => _showLogoutDialog()),
                  ],
                ),
              ),
            ),
    );
  }

  _showLogoutDialog() {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Center(child: Text("INFO")),
            content: const Text("Are you sure, you want to Logout?"),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("CANCEL"),
              ),
              TextButton(
                onPressed: () => _logOut(),
                child: const Text("YES"),
              ),
            ],
          );
        });

    // return Get.defaultDialog(
    //   title: "LOGOUT",
    //   titleStyle: const TextStyle(fontSize: 20),
    //   content: const Padding(
    //     padding: EdgeInsets.symmetric(vertical: 15.0),
    //     child: Text("Are you sure, you want to Logout?"),
    //   ),
    //   confirm: Expanded(
    //     child: ElevatedButton(
    //       onPressed: () => _logOut(),
    //       style: ElevatedButton.styleFrom(
    //           backgroundColor: Colors.redAccent, side: BorderSide.none),
    //       child: const Text("Yes"),
    //     ),
    //   ),
    //   cancel:
    //       OutlinedButton(onPressed: () => Get.back(), child: const Text("No")),
    // );
  }

  _logOut() async {
    var respo = await BarkatService.instance.logOut();
    print('rabin $respo');
    if (respo) {
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(),
        ),
        barrierDismissible: true,
      );
      await Future.delayed(const Duration(seconds: 2));
      Get.back();
      Get.offAll(LoginScreen());
    } else {
      Get.back();

      Get.showSnackbar(GetSnackBar(
        title: 'Info',
        message: 'Oops! Something went wrong',
        icon: const Icon(Icons.info),
        duration: const Duration(seconds: 1),
        snackStyle: SnackStyle.FLOATING,
        backgroundGradient:
            LinearGradient(colors: [Colors.red, Colors.red.shade200]),
        snackPosition: SnackPosition.TOP,
      ));
    }
    print('rabin $respo');
  }
}
