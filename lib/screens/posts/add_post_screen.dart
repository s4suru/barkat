import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../api_services/barkat_service.dart';
import '../../provider/post_provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  late PostProvider postProvider;
  File? img;
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    postProvider = Provider.of<PostProvider>(context);
    return Scaffold(
      appBar: AppBar(
          title: const Text('Add Post'),
          backgroundColor: Colors.green.shade200),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 6, right: 6),
            margin: EdgeInsets.all(6),
            decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(10)),
            height: 300,
            child: TextFormField(
              expands: true,
              maxLines: null,
              minLines: null,
              controller: _textController,
              style: TextStyle(
                fontSize: 14.0,
              ),
              decoration: InputDecoration(
                  hintText: 'Share your thought..', border: InputBorder.none),
            ),
          ),
          img != null
              ? Stack(
                  children: [
                    //File image
                    Image.file(img!,
                        width: MediaQuery.of(context).size.width,
                        height: 200,
                        fit: BoxFit.cover),

                    //Delete icon
                    Positioned(
                      right: 0,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            img = null;
                          });
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.delete,
                            color: Colors.redAccent.shade100,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : InkWell(
                  onTap: () async {
                    var file = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);
                    if (file != null) {
                      setState(() {
                        img = File(file.path);
                      });
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.all(6),
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.upload_file,
                            color: Colors.grey,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Upload image",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
          SizedBox(
            width: 200,
            child: ElevatedButton(
              onPressed: () => addPost(),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade200,
                  side: BorderSide.none,
                  shape: const StadiumBorder()),
              child: const Text('Add', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  addPost() async {
    if (_textController.text.isEmpty && img == null) {
      Get.showSnackbar(GetSnackBar(
        title: 'Info',
        message: 'Share your thought or post image',
        icon: const Icon(Icons.info),
        duration: const Duration(seconds: 2),
        snackStyle: SnackStyle.FLOATING,
        backgroundGradient:
            LinearGradient(colors: [Colors.red, Colors.red.shade200]),
        snackPosition: SnackPosition.TOP,
      ));
    } else {
      processingDialog('Please wait...');
      var respo =
          await postProvider.addPost(_textController.text.toString(), img);
      if (respo == true) {
        Get.back();
        Get.back();
        Get.showSnackbar(GetSnackBar(
          title: 'Info',
          message: 'Your post has been added',
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
