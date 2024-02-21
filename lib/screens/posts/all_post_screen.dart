import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tasbih/constant/app_constant.dart';
import 'package:tasbih/provider/post_provider.dart';
import 'package:tasbih/screens/posts/add_post_screen.dart';

class AllPostScreen extends StatefulWidget {
  const AllPostScreen({super.key});

  @override
  State<AllPostScreen> createState() => _AllPostScreenState();
}

class _AllPostScreenState extends State<AllPostScreen> {
  late PostProvider postProvider;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) {
      Provider.of<PostProvider>(context, listen: false).getAllPost();
    });
  }

  @override
  Widget build(BuildContext context) {
    postProvider = Provider.of<PostProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade200,
        title: const Text('Barkat Feeds'),
      ),
      body: postProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : postProvider.postList.isEmpty
              ? const Center(child: Text('There is no any post'))
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemCount: postProvider.postList.length,
                          itemBuilder: (context, index) {
                            return postProvider.postList[index].fileName == null
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
                                            Row(
                                              children: [
                                                postProvider.postList[index]
                                                            .community!.photo !=
                                                        null
                                                    ? ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl:
                                                              "${AppConstants.PROFILE_IMAGE_URL}${postProvider.postList[index].community!.photo}",
                                                          fit: BoxFit.fill,
                                                          height: 30,
                                                          width: 30,
                                                          placeholder: (context,
                                                                  url) =>
                                                              const Center(
                                                                  child:
                                                                      CircularProgressIndicator(
                                                            strokeWidth: 2.0,
                                                          )),
                                                        ))
                                                    : ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
                                                        child: Image.asset(
                                                          'assets/images/userpf.png',
                                                          height: 30,
                                                          width: 30,
                                                        ),
                                                      ),
                                                const SizedBox(
                                                  width: 6,
                                                ),
                                                Text(
                                                  'Posted by ${postProvider.postList[index].community!.name}',
                                                )
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Visibility(
                                                  visible: postProvider
                                                          .postList[index]
                                                          .caption !=
                                                      null,
                                                  child: Text(
                                                    '${postProvider.postList[index].caption}',
                                                    textAlign:
                                                        TextAlign.justify,
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                : Container(
                                    margin: const EdgeInsets.only(
                                        bottom: 10, left: 8, right: 8, top: 4),
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
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              postProvider.postList[index]
                                                          .community!.photo !=
                                                      null
                                                  ? ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      child: CachedNetworkImage(
                                                        imageUrl:
                                                            "${AppConstants.PROFILE_IMAGE_URL}${postProvider.postList[index].community!.photo}",
                                                        fit: BoxFit.fill,
                                                        height: 30,
                                                        width: 30,
                                                        placeholder: (context,
                                                                url) =>
                                                            const Center(
                                                                child:
                                                                    CircularProgressIndicator(
                                                          strokeWidth: 2.0,
                                                        )),
                                                      ))
                                                  : ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                      child: Image.asset(
                                                        'assets/images/userpf.png',
                                                        height: 30,
                                                        width: 30,
                                                      ),
                                                    ),
                                              const SizedBox(
                                                width: 6,
                                              ),
                                              Text(
                                                'Posted by ${postProvider.postList[index].community!.name}',
                                              )
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                            visible: postProvider
                                                    .postList[index].caption !=
                                                null,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                '${postProvider.postList[index].caption}',
                                                textAlign: TextAlign.left,
                                                maxLines: 4,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            )),
                                        Expanded(
                                          child: Visibility(
                                            visible: postProvider
                                                    .postList[index].fileName !=
                                                null,
                                            child: SizedBox(
                                              width: double.infinity,
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
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
                                  );
                          }),
                    )
                  ],
                ),
    );
  }
}
