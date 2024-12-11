import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:matka_web/constants.dart';
import 'package:matka_web/presentation/pages/register_page.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../alerts.dart';
import '../../app_colors.dart';
import '../../global_functions.dart';
import '../../storage/user_info.dart';
import 'home_page/screens/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController number = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    number.clear();
    password.clear();
    print("Login screen_________________________________________");
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        return GlobalFunctions.refreshPage();
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Container(
            width: 400,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    width: 200,
                    height: 200,
                    "assets/logo/logo.png",
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Text(
                    "Welcome back",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w700),
                  ),
                  const Text(
                    "Login To your account",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextField(
                    controller: number,
                    style: TextStyle(color: Colors.white),
                    maxLines: 1,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10)
                    ],
                    decoration: const InputDecoration(
                        hintText: 'Mobile Number',
                        hintStyle: TextStyle(color: Colors.white),
                        prefixIcon: Icon(
                          Icons.phone,
                          color: Colors.white,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          borderSide: BorderSide(
                            color: Colors.white
                          )
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide: BorderSide(
                                color: Colors.white
                            )
                        ),)
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextField(
                    obscureText: true,
                    controller: password,
                    style: TextStyle(color: Colors.white),
                    maxLines: 1,
                    decoration: const InputDecoration(
                        hintText: 'Password',
                        hintStyle: TextStyle(color: Colors.white),
                        prefixIcon: Icon(Icons.lock, color: Colors.white),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          borderSide: BorderSide(
                              color: Colors.white
                          )
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          borderSide: BorderSide(
                              color: Colors.white
                          )
                      ),)
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if(number.text.isEmpty || password.text.isEmpty){
                        CustomAlert.error("Alert", "Number and password cannot be empty");
                      } else{
                        userLogin();
                      }
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      minimumSize: const Size(double.infinity, 40),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.white,
                          width: 1
                        ),
                        borderRadius: BorderRadius.circular(15)
                      )
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                              builder: (context) => RegisterPage(),
                            ));
                          },
                          child: const Text(
                            "Sign Up?",
                            style: TextStyle(color: Colors.white),
                          )),
                      const Text(
                        "|",
                        style: TextStyle(color: Colors.white),
                      ),
                      TextButton(
                          onPressed: () {},
                          child: const Text(
                            "Forgot password?",
                            style: TextStyle(color: Colors.white),
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () {
                      _launchUrl("https://wa.me/917689095999");
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset("assets/whatsapp.svg",width: 30,),
                        SizedBox(
                          width: 10,
                        ),
                        const Text(
                          "7689095999",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> userLogin() async {
    print("------------------------------------------");
    final url = Uri.parse("$baseUrl/userLogin.php");

    final body = {
      "mobileNum": number.text.toString(),
      "password": password.text.toString(),
    };

    final headers = {
      "Content-Type": "application/x-www-form-urlencoded",
      // "X-Requested-With": "XMLHttpRequest",
    };
    try {
      final response = await http.post(
        url,
        body: body,
        headers: headers,
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = Map();
        // Successful request, process the response
        try {
          data = jsonDecode(response.body);
          //

          if (data['status'].toString().compareTo("success") == 0) {
            UserInfo.storeUserInfo(data['member_id'] ?? '');
            GlobalFunctions.getProfileDetails();
            Get.to(() => const HomePage());
          } else {
            CustomAlert.error("Alert", "Please Enter Valid Details!");
          }
          //   // Process data
        } catch (e) {
          CustomAlert.error("Error", "Failed to decode data");
        }
      } else {
        // Handle server errors
        CustomAlert.error("Alert", "Something went wrong");
        //
      }
    } catch (e) {
      // Handle exceptions
      print(e);
    }
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

}