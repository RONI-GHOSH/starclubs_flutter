import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:matka_web/app_colors.dart';
import 'package:matka_web/constants.dart';
import 'package:http/http.dart' as http;
import 'package:matka_web/presentation/pages/home_page/screens/home_page.dart';
import 'package:matka_web/presentation/pages/login_page.dart';
import 'package:matka_web/storage/user_info.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../alerts.dart';
import '../../global_functions.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController name = TextEditingController();
  TextEditingController number = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController memberId = TextEditingController();
  TextEditingController code = TextEditingController();
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
                    "Create An Account",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextField(
                      controller: name,
                      style: TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Name',
                        hintStyle: TextStyle(color: Colors.white),
                        prefixIcon: Icon(
                          Icons.phone,
                          color: Colors.white,
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide: BorderSide(color: Colors.white)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide: BorderSide(color: Colors.white)),
                      )),
                  const SizedBox(
                    height: 8,
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
                          borderSide: BorderSide(color: Colors.white)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          borderSide: BorderSide(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextField(
                      obscureText: true,
                      controller: password,
                      style: TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Password',
                        hintStyle: TextStyle(color: Colors.white),
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Colors.white,
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide: BorderSide(color: Colors.white)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide: BorderSide(color: Colors.white)),
                      )),
                  const SizedBox(
                    height: 8,
                  ),
                  TextField(
                      controller: code,
                      style: TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Referral Code',
                        hintStyle: TextStyle(color: Colors.white),
                        prefixIcon: Icon(
                          Icons.password_sharp,
                          color: Colors.white,
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide: BorderSide(color: Colors.white)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide: BorderSide(color: Colors.white)),
                      )),
                    const SizedBox(height: 16,),
                  ElevatedButton(
                    onPressed: () {
                      if(name.text.isEmpty || password.text.isEmpty || number.text.isEmpty){
                        CustomAlert.error("Alert", "Name and Number and password cannot be empty");
                      } else{
                        createUser();
                      }
                    },
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
                    child: const Text("Register",style: TextStyle(color: Colors.white),),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account?",style: TextStyle(color: Colors.white),),
                      TextButton(
                          onPressed: () {
                            Get.to(() => const LoginPage());
                          },
                          child: const Text("Login",style: TextStyle(color: Colors.white),))
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

  Future<void> createUser() async {
    final url = Uri.parse("$baseUrl/userRegistration_wotp.php");
    final body = {
      "name": name.text.toString(),
      "mobileNum": number.text.toString(),
      "password": password.text.toString(),
      "member_passcode": memberId.text.toString(),
      "referralcode": code.text.toString() == "" ? "" : code.text.toString()
    };
    print(url);
    final headers = {
      "Content-Type":
          "application/x-www-form-urlencoded", // Replace with your token if required
    };
    try {
      final response = await http.post(url, body: body, headers: headers);
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        print(body);
        if (body['status'] == "success") {
          UserInfo.storeUserInfo(body['member_id'].toString());
          Get.to(() => const HomePage());
        } else {
          Get.snackbar("Error", "User is already exist",
              backgroundColor: Colors.redAccent);
        }
      } else {
        // Handle server errors
        Get.snackbar("Alert", "Something went wrong");
        // print('Server error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
  }
  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }
}
