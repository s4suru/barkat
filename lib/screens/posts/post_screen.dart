import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tasbih/constant/app_constant.dart';
import 'package:tasbih/provider/post_provider.dart';
import 'package:tasbih/screens/posts/add_post_screen.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  late PostProvider postProvider;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) {
      Provider.of<PostProvider>(context, listen: false).getMyPost();
    });
  }

  @override
  Widget build(BuildContext context) {
    postProvider = Provider.of<PostProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade200,
        title: const Text('My Post'),
      ),
      floatingActionButton: Container(
          decoration: BoxDecoration(
              color: Colors.green.shade200, shape: BoxShape.circle),
          child: IconButton(
              onPressed: () => Get.to(const AddPostScreen()),
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ))),
      body: postProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : postProvider.postList.isEmpty
              ? const Center(child: Text('You have not any post'))
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemCount: postProvider.postList.length,
                          itemBuilder: (context, index) {
                            return Dismissible(
                                confirmDismiss:
                                    (DismissDirection direction) async {
                                  return await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Confirm"),
                                        content: const Text(
                                            "Are you sure you want to remove this post?"),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context)
                                                    .pop(false),
                                            child: const Text("CANCEL"),
                                          ),
                                          TextButton(
                                            onPressed: () => _deleteMyPost(
                                                postProvider
                                                    .postList[index].postId),
                                            child: const Text("REMOVE"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                direction: DismissDirection.endToStart,
                                key: Key(
                                    postProvider.postList[index].toString()),
                                background: Container(
                                  color: Colors.red,
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 16.0),
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                ),
                                child: postProvider.postList[index].fileName ==
                                        null
                                    ? Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(14),
                                            margin: const EdgeInsets.only(
                                                bottom: 10,
                                                left: 8,
                                                right: 8,
                                                top: 8),
                                            // height: containerHeight,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.lightBlue
                                                          .withOpacity(0.1),
                                                      offset:
                                                          const Offset(1, 1),
                                                      spreadRadius: 0.2,
                                                      blurRadius: 8)
                                                ],
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Visibility(
                                                    visible: postProvider
                                                            .postList[index]
                                                            .caption !=
                                                        null,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              6.0),
                                                      child: Text(
                                                        '${postProvider.postList[index].caption}',
                                                        textAlign:
                                                            TextAlign.justify,
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container(
                                        margin: const EdgeInsets.only(
                                            bottom: 10,
                                            left: 8,
                                            right: 8,
                                            top: 4),
                                        height: 300,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.lightBlue
                                                      .withOpacity(0.1),
                                                  offset: const Offset(1, 1),
                                                  spreadRadius: 0.2,
                                                  blurRadius: 8)
                                            ],
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Visibility(
                                                visible: postProvider
                                                        .postList[index]
                                                        .caption !=
                                                    null,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    '${postProvider.postList[index].caption}',
                                                    textAlign: TextAlign.left,
                                                    maxLines: 4,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                )),
                                            Expanded(
                                              child: Visibility(
                                                visible: postProvider
                                                        .postList[index]
                                                        .fileName !=
                                                    null,
                                                child: SizedBox(
                                                  width: double.infinity,
                                                  child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      child: CachedNetworkImage(
                                                        imageUrl:
                                                            "${AppConstants.IMAGE_URL}${postProvider.postList[index].fileName}",
                                                        fit: BoxFit.fill,
                                                        placeholder: (context,
                                                                url) =>
                                                            const Center(
                                                                child:
                                                                    CircularProgressIndicator(
                                                          strokeWidth: 2.0,
                                                        )),
                                                      )),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ));
                          }),
                    )
                  ],
                ),
    );
  }

  _deleteMyPost(int? postId) async {
    Get.back();
    var respo = await postProvider.deleteMyPost(postId);
    processingDialog('Please wait...');
    if (respo == true) {
      Get.back();
      // Get.back();
      Get.showSnackbar(GetSnackBar(
        title: 'Info',
        message: 'Post removed successfully',
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

  processingDialog(message) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Info'),
            content: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(
                  strokeWidth: 2,
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                )
              ],
            ),
          );
        });
  }
}
