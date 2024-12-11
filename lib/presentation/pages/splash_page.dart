import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:matka_web/presentation/pages/home_page/screens/home_page.dart';
import 'package:matka_web/presentation/pages/login_page.dart';
import 'package:matka_web/storage/user_info.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("splash screen_________________________________________");
    Future.delayed(Duration(milliseconds: 800),() => checkCurrUser(),);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
          child: Center(
        child: Container(
          width: 400,
          child: Image.asset(
            "assets/logo/logo.png",
            width: 300,
          ),
        ),
      )),
    );
  }

  Future<void> checkCurrUser() async {
    final id = await UserInfo.getUserInfo();
    print(id);
    print(" this is ________________________________${id.isNotEmpty}");
    if (id.isNotEmpty) {
      print("Navigating to HomePage");
      Get.off(() => const HomePage());
    } else {
      print("Navigating to LoginPage");
      Get.off(() => const LoginPage());
    }
  }

}
