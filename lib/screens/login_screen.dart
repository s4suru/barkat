import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasbih/api_services/barkat_service.dart';
import 'package:tasbih/screens/home_screen.dart';
import 'package:tasbih/screens/signup_screen.dart';

import '../helper/helper_function.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? name;
  String? email;
  String? password;
  Color primaryColor = Color.fromARGB(255, 117, 199, 244);
  Color textprimaryColor = Color(0xFF1E1E24);
  final formKey = GlobalKey<FormState>();
  String image = "";

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          // backgroundColor: Colors.white,
          body: body(),
        ),
      ),
    );
  }

  body() {
    return Container(
      //  decoration: const BoxDecoration(
      //         image: DecorationImage(
      //             image: AssetImage("assets/images/secondary_background.png"),
      //             fit: BoxFit.fill)),
      child: Stack(children: [
        Image.asset(
          "assets/images/logo.png",
          fit: BoxFit.fill,
        ),
        Align(
          alignment: Alignment.center,
          child: Container(
            // height: MediaQuery.of(context).size.height,
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(20, 25, 20, 0),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SizedBox(
                    //   height: 10,
                    // ),
                    // Center(
                    //   child: Image.asset("assets/images/logo.png", height: 100),
                    // ),

                    SizedBox(
                      height: 160,
                    ),

                    Text(
                      'Email Address',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          // style: TextStyle(color: Colors.white),
                          cursorColor: primaryColor,
                          onSaved: (val) => email = val!,
                          decoration: InputDecoration(
                            hintText: 'Email Address',
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 10),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            focusColor: Colors.grey[400],
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: primaryColor,
                              ),
                            ),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                          ),
                          keyboardType: TextInputType.name,
                          onChanged: (val) {
                            setState(() {
                              email = val;
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      'Password',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextFormField(
                      // style: TextStyle(color: Colors.white),
                      cursorColor: primaryColor,
                      onSaved: (val) => password = val!,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: primaryColor,
                          ),
                        ),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                      ),
                      keyboardType: TextInputType.name,
                      onChanged: (val) {
                        setState(() {
                          password = val;
                        });
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // GestureDetector(
                    //   onTap: () {
                    //     Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (context) => ForgetPassword()));
                    //   },
                    //   child: Align(
                    //     alignment: Alignment.centerRight,
                    //     child: Text(
                    //       FORGET_PASSWORD,
                    //       style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: 60,
                    // ),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              if (email == '' || password == '') {
                                final snackBar = SnackBar(
                                  content: Text('Field empty.'),
                                  backgroundColor: Colors.blue,
                                  behavior: SnackBarBehavior.floating,
                                  action: SnackBarAction(
                                    label: 'Dismiss',
                                    disabledTextColor: Colors.white,
                                    textColor: Colors.yellow,
                                    onPressed: () {
                                      //Do whatever you want
                                    },
                                  ),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              } else if (formKey.currentState!.validate()) {
                                formKey.currentState!.save();
                                loginIntoAccount();
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.fromLTRB(15, 5, 15, 15),
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: Colors.green.shade200,
                              ),
                              child: Center(
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 17),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUpScreen()),
                            );
                          },
                          child: Text(
                            'Register',
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 13,
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                      ],
                    ),
                    // SizedBox(
                    //   height: 20,
                    // ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     InkWell(
                    //       onTap: () {
                    //         Navigator.push(
                    //           context,
                    //           MaterialPageRoute(builder: (context) => RootScreen()),
                    //         );
                    //       },
                    //       child: Text(
                    //         'Continue as Guest',
                    //         style: TextStyle(
                    //             color: NAVY_BLUE,
                    //             fontSize: 13,
                    //             fontWeight: FontWeight.w800),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }

  errorDialog(message) {
    return showDialog(
      barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 10,
                ),
                Icon(
                  Icons.error,
                  size: 80,
                  color: Colors.red,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  message.toString(),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          );
        });
  }

  processingDialog(message) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('loading'),
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

  loginIntoAccount() async {
    processingDialog('logging in...');
    var res = await BarkatService.instance.login(email!, password!);
    if (res == true) {
      Get.back();
      Get.offAll(const HomeScreen());
    } else {
      Get.back();
      errorDialog('Invalid credentials');
      Future.delayed(const Duration(seconds: 2), () {
        Get.back();
      });
    }
  }
}
