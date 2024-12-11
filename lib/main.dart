import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:matka_web/app_colors.dart';
import 'package:matka_web/presentation/pages/add_bank_details_page.dart';
import 'package:matka_web/presentation/pages/home_page/screens/home_page.dart';
import 'package:matka_web/presentation/pages/login_page.dart';
import 'package:matka_web/presentation/pages/splash_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:matka_web/router.dart';
import 'package:matka_web/storage/user_info.dart';

import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkCurrUser();
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Star Club',
      debugShowCheckedModeBanner: false,
      // routerDelegate: router.routerDelegate,
      // routeInformationParser: router.routeInformationParser,
      // routeInformationProvider: router.routeInformationProvider,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
      ),
      // initialRoute: '/', // Define the initial route
      // getPages: [
      //   GetPage(name: '/', page: () => HomePage()), // Your home page
      //   GetPage(name: '/AddBankDetailsPage', page: () => AddBankDetailsPage()), // The missing route
      // ],
      themeMode: ThemeMode.dark,
      home: const LoginPage(),
    );

  }
  Future<void> checkCurrUser() async {
    final id = await UserInfo.getUserInfo();
    print(id);
    print(" this is ________________________________${id.isNotEmpty}");
    if (id.isNotEmpty) {
      print("Navigating to HomePage");
      Get.off(() => const HomePage());
      // GoRouter.of(context).go('/home');
    } else {
      print("Navigating to LoginPage");
      Get.off(() => const LoginPage());
      // GoRouter.of(context).go('/login');

    }
  }
}
