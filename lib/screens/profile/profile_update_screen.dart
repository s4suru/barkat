import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasbih/constant/app_constant.dart';
import 'package:tasbih/provider/community_provider.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({Key? key}) : super(key: key);

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  late CommunityProvider communityProvider;

  File? _imgFile;
  dynamic? image;
  @override
  void initState() {
    // getSharedData();
    super.initState();
  }

  // getSharedData() async {
  //   await SharedPreferences.getInstance().then((value) {
  //     setState(() {
  //       _nameController.text = value.getString('name') ?? '';
  //       _phoneController.text = value.getString('phone') ?? '';
  //       _emailController.text = value.getString('email') ?? '';
  //       image = value.getString('pfimage') ?? '';
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // final controller = Get.put(ProfileController());
    communityProvider = Provider.of<CommunityProvider>(context);
    _nameController.text = communityProvider.community.name.toString();
    _phoneController.text = communityProvider.community.phone.toString();
    _emailController.text = communityProvider.community.email.toString();
    Color tPrimaryColor = Colors.green.shade200;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: tPrimaryColor,
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(LineAwesomeIcons.angle_left)),
        title: const Text(
          'Edit Profile',
        ),
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.green, // this is the border color
                            width: 3.0,
                          ),
                          image: _imgFile == null
                              ? DecorationImage(
                                  image: communityProvider.community.photo !=
                                          null
                                      ? NetworkImage(
                                          "${AppConstants.PROFILE_IMAGE_URL}${communityProvider.community.photo}")
                                      : const NetworkImage(
                                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTf-H0m8PLT9RhcZM6yR4cAR1T7K29zmMgUo_hTwYmzBw&s",
                                        ),
                                  fit: BoxFit.cover,
                                )
                              : DecorationImage(
                                  image: FileImage(_imgFile!),
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: () => _showProfileChangeDialog(context),
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: tPrimaryColor),
                            child: const Icon(LineAwesomeIcons.camera,
                                color: Colors.black, size: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  Form(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                              label: Text('Name'),
                              prefixIcon: Icon(LineAwesomeIcons.user)),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          readOnly: true,
                          controller: _emailController,
                          decoration: const InputDecoration(
                              label: Text('Email'),
                              prefixIcon: Icon(LineAwesomeIcons.envelope_1)),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _phoneController,
                          decoration: const InputDecoration(
                              label: Text('Phone'),
                              prefixIcon: Icon(LineAwesomeIcons.phone)),
                        ),
                        const SizedBox(height: 20),
                        // TextFormField(
                        //   obscureText: true,
                        //   decoration: InputDecoration(
                        //     label: const Text('password'),
                        //     prefixIcon: const Icon(Icons.fingerprint),
                        //     suffixIcon: IconButton(
                        //         icon: const Icon(LineAwesomeIcons.eye_slash),
                        //         onPressed: () {}),
                        //   ),
                        // ),
                        // const SizedBox(height: tFormHeight),

                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () => _updateProfile(),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: tPrimaryColor,
                                  side: BorderSide.none,
                                  shape: const StadiumBorder()),
                              child: const Text(
                                'Update',
                              )),
                        ),
                        // const SizedBox(height: tFormHeight),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showProfileChangeDialog(BuildContext ctx) {
    showModalBottomSheet(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        context: ctx,
        builder: (BuildContext context) {
          return SizedBox(
            // margin: EdgeInsets.only(top: 40),
            height: 170,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.all(5),
                    height: 5,
                    width: 36,
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  InkWell(
                    onTap: () {
                      _openImagePicker(ImageSource.gallery);
                      Get.back();
                    },
                    child: Text(
                      'Choose from Gallery',
                      style: GoogleFonts.abel(
                        textStyle: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF848484),
                            overflow: TextOverflow.ellipsis),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Divider(
                    thickness: 0.3,
                    indent: 18.0,
                    endIndent: 18.0,
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  InkWell(
                    onTap: () {
                      _openImagePicker(ImageSource.camera);
                      Get.back();
                    },
                    child: Text(
                      'Take from Camera',
                      style: GoogleFonts.abel(
                        textStyle: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF848484),
                            overflow: TextOverflow.ellipsis),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Divider(
                    thickness: 0.3,
                    indent: 18.0,
                    endIndent: 18.0,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ]),
          );
        });
  }

  Future<void> _openImagePicker(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image =
        await picker.pickImage(source: source, imageQuality: 50);

    if (image != null) {
      setState(() {
        _imgFile = File(image.path);
      });
    }
  }

  _updateProfile() async {
    if (_nameController.text.isEmpty || _phoneController.text.isEmpty) {
      Get.showSnackbar(GetSnackBar(
        title: 'Info',
        message: 'Field cannot be blank',
        icon: const Icon(Icons.info),
        duration: const Duration(seconds: 2),
        snackStyle: SnackStyle.FLOATING,
        backgroundGradient:
            LinearGradient(colors: [Colors.red, Colors.red.shade200]),
        snackPosition: SnackPosition.TOP,
      ));
    } else {
      processingDialog('Please wait...');
      var respo = await communityProvider.updateProfile(
          _nameController.text, _phoneController.text, _imgFile);
      if (respo == true) {
        Get.back();
        Get.back();
        Get.showSnackbar(GetSnackBar(
          title: 'Info',
          message: 'Profile updated successfully',
          icon: const Icon(Icons.info),
          duration: const Duration(seconds: 2),
          snackStyle: SnackStyle.FLOATING,
          backgroundGradient:
              LinearGradient(colors: [Colors.green, Colors.green.shade200]),
          snackPosition: SnackPosition.TOP,
        ));
      } else {
        Get.back();
        Get.showSnackbar(GetSnackBar(
          title: 'Info',
          message: 'Oops! Something went wrong',
          icon: const Icon(Icons.info),
          duration: const Duration(seconds: 2),
          snackStyle: SnackStyle.FLOATING,
          backgroundGradient:
              LinearGradient(colors: [Colors.red, Colors.red.shade200]),
          snackPosition: SnackPosition.TOP,
        ));
      }
    }
  }

  processingDialog(message) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Info'),
            content: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  strokeWidth: 2,
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    message,
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                )
              ],
            ),
          );
        });
  }
}
