import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:tasbih/screens/login_screen.dart';
import '../api_services/barkat_service.dart';
import '../main.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

Color primaryColor = Color.fromARGB(255, 117, 199, 244);
Color textprimaryColor = Color(0xFF1E1E24);

class _SignUpScreenState extends State<SignUpScreen> {
  String name = "";
  String emailAddress = "";
  String phoneNumber = "";
  String password = "";
  String confirmPassword = "";
  String path = "";
  final Tname = TextEditingController();
  final TemailAddress = TextEditingController();
  final TphoneNumber = TextEditingController();
  final Tpassword = TextEditingController();
  final TconfirmPassword = TextEditingController();

  // final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        // resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            'Register',
            style: TextStyle(color: Colors.black),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () => Get.back(),
          ),
        ),
        body: body(),
      ),
    );
  }

  body() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // SizedBox(
            //   height: 20,
            // ),
            // Text(
            //   'Hello! Register to get started',
            //   //  Bold color google
            //   style: GoogleFonts.poppins(
            //     fontSize: 20,
            //     fontWeight: FontWeight.w700,
            //     color: Colors.black,
            //   ),
            // ),
            SizedBox(
              height: 20,
            ),
            Column(
              children: [
                makeInput(label: "Name", controller: Tname),
                makeInput(
                    label: "Email",
                    keyboardType: TextInputType.emailAddress,
                    controller: TemailAddress),
                makeInput(
                    label: "Phone Number",
                    keyboardType: TextInputType.number,
                    controller: TphoneNumber),
                makeInput(
                    label: "Password", obsureText: true, controller: Tpassword),
                makeInput(
                    label: "Confirm Pasword",
                    obsureText: true,
                    controller: TconfirmPassword),
              ],
            ),
            button(),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an account? "),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }

  button() {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              name = Tname.text;
              emailAddress = TemailAddress.text;
              phoneNumber = TphoneNumber.text;
              password = Tpassword.text;
              confirmPassword = TconfirmPassword.text;

              if (name == '' ||
                  emailAddress == '' ||
                  password == '' ||
                  // phoneNumber == '' ||
                  confirmPassword == '') {
                final snackBar = SnackBar(
                  content: Text('Field empty.'),
                  backgroundColor: primaryColor,
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
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              } else if (password != confirmPassword) {
                final snackBar = SnackBar(
                  content:
                      Text('Passwords and Confirm password need to be same.'),
                  backgroundColor: primaryColor,
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
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              } else {
                createAccount();
              }
              // if (formKey.currentState.validate()) {
              //   formKey.currentState.save();
              //   createAccount();
              // }
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
                  'Register',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 17),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  createAccount() async {
    processingDialog('Registering. please wait...');

    Map<dynamic, dynamic> sData = {
      'name': Tname.text.toString(),
      'email': TemailAddress.text.toString(),
      'phone': TphoneNumber.text,
      'password': Tpassword.text.toString(),
    };
    var res = await BarkatService.instance.register(sData);
    if (res == 'success') {
      Navigator.pop(context);
      Get.showSnackbar(GetSnackBar(
        title: 'Info',
        message: 'User Registered Successfully',
        icon: const Icon(Icons.airplane_ticket),
        duration: const Duration(seconds: 2),
        snackStyle: SnackStyle.FLOATING,
        backgroundGradient:
            LinearGradient(colors: [Colors.green, Colors.green.shade200]),
        snackPosition: SnackPosition.TOP,
      ));
     Get.offAll(LoginScreen());
    } else if (res == 'failed') {
      errorDialog('Registration Failed');
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pop(context);
        Navigator.pop(context);
      });
    } else {
      errorDialog(res);
      Future.delayed(Duration(seconds: 3), () {
        Navigator.pop(context);
        Navigator.pop(context);
      });
    }
  }

  errorDialog(message) {
    return showDialog(
        context: context,
        barrierDismissible: false,
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
                  message,
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
            title: Text('Loading...'),
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

Widget makeInput(
    {label,
    obsureText = false,
    TextEditingController? controller,
    TextInputType? keyboardType}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
            fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
      ),
      SizedBox(
        height: 5,
      ),
      TextField(
        cursorColor: primaryColor,
        controller: controller,
        obscureText: obsureText,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
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

          //cursor color

          border:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        ),
        keyboardType: keyboardType != null ? keyboardType : TextInputType.name,
      ),
      SizedBox(
        height: 20,
      )
    ],
  );
}
