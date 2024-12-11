import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_router/go_router.dart';
import 'package:matka_web/app_colors.dart';
import 'package:matka_web/constants.dart';
import 'package:matka_web/global_functions.dart';
import 'package:matka_web/golbal_controller.dart';
import 'package:matka_web/models/admin_model.dart';
import 'package:matka_web/models/color_bet_market_model.dart';
import 'package:matka_web/models/star_line_market_model.dart';
import 'package:matka_web/models/user_profile_model.dart';
import 'package:matka_web/presentation/components/html_imageview.dart';
import 'package:matka_web/presentation/pages/add_bank_details_page.dart';
import 'package:matka_web/presentation/pages/add_money_page.dart';
import 'package:matka_web/presentation/pages/bet_history_page.dart';
import 'package:matka_web/presentation/pages/game_rate_page.dart';
import 'package:matka_web/presentation/pages/login_page.dart';
import 'package:matka_web/presentation/pages/manage_payment_page.dart';
import 'package:matka_web/presentation/pages/refer_earn_page.dart';
import 'package:matka_web/presentation/pages/reset_password_page.dart';
import 'package:matka_web/presentation/pages/transfer_money_page.dart';
import 'package:matka_web/presentation/pages/wallet_transaction_page.dart';
import 'package:matka_web/presentation/pages/winning_history_page.dart';
import 'package:matka_web/presentation/pages/withdraw_money_page.dart';
import 'package:matka_web/services/authentication_service.dart';
import 'package:matka_web/storage/user_info.dart';
import 'package:mj_image_slider/mj_image_slider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mj_image_slider/mj_options.dart';
import 'package:http/http.dart' as http;

import '../../../../alerts.dart';
import '../../../../models/delhi_market_model.dart';
import '../../../../models/delhi_market_model.dart';
import '../../../components/market_card.dart';
import '../../chat_page.dart';
import '../data/home_page_controller.dart';
import '../widgets/color_market_card.dart';
import '../widgets/delhi_market_card.dart';
import '../widgets/mumbai_market_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    // TODO: implement initState
    HomePageController.getAdminDetails();
    super.initState();
    HomePageController.getMarketList();
    GlobalFunctions.getProfileDetails();
    HomePageController.getImages();
  }

  void refreshPage(){
    Get.to(()=>HomePage());
  }
  @override
  Widget build(BuildContext context) {
    // html.window.location.reload();

    return RefreshIndicator(
      onRefresh: () {
        return GlobalFunctions.refreshPage(); },
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          Get.back();
        },
        child: Scaffold(
          // onDrawerChanged: (isOpened) {
          //   GlobalFunctions.getProfileDetails();
          //   HomePageController.getAdminDetails();
          // },
          appBar: AppBar(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            title: const Text('Star Club'),
            actions: [
              IconButton(
                onPressed: () {
                  Get.to(() => const WalletTransactionPage());
                },
                icon: const Icon(FontAwesomeIcons.wallet),
              ),
              Obx(()=> Text("${GlobalController.walletMoney.value}")),
              const SizedBox(
                width: 10,
              )
            ],
          ),
          drawer: _buildDrawer(context),
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Obx(
                  ()=> MJImageSlider(
                      options: MjOptions(
                        height: 200,
                        aspectRatio: 16 / 9,
                        viewportFraction: 0.8,
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        autoPlayInterval: const Duration(seconds: 3),
                        autoPlayAnimationDuration: const Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        scrollDirection: Axis.horizontal,
                      ),
                      widgets:[...HomePageController.sliderImages.map((e) =>

                      //  Image(image: NetworkImage(e ?? 'https://picsum.photos/1080/720', ))
                      HtmlImageView(imageUrl: e ?? 'https://picsum.photos/1080/720')
                      )]
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Card(
                      color: AppColors.primary,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  style: const ButtonStyle(
                                      backgroundColor:
                                          WidgetStatePropertyAll(Colors.white)),
                                  onPressed: () {
                                    Get.to(() => const AddMoneyPage());
                                  },
                                  icon: const Icon(
                                    Icons.add,
                                    size: 30,
                                  ),
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                IconButton(
                                  style: const ButtonStyle(
                                      backgroundColor:
                                          WidgetStatePropertyAll(Colors.white)),
                                  onPressed: () async {
                                    final _url = Uri.parse(
                                        "https://web.whatsapp.com/send/?phone=${GlobalController.adminModel.value?.whatsappNumber}");
                                    if (!await launchUrl(_url)) {
                                      throw Exception('Could not launch $_url');
                                    }
                                  },
                                  icon: Icon(
                                      color: Colors.green,
                                      size: 30,
                                      const FaIcon(FontAwesomeIcons.whatsapp).icon),
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                IconButton(
                                    style: const ButtonStyle(
                                        backgroundColor:
                                            WidgetStatePropertyAll(Colors.white)),
                                    onPressed: () {
                                      Get.to(() => const WithdrawMoneyPage());
                                    },
                                    icon: Image.asset(
                                      "assets/wf.png",
                                      width: 30,
                                    )),
                                const SizedBox(
                                  width: 16,
                                ),
                                IconButton(
                                    style: const ButtonStyle(
                                        backgroundColor:
                                            WidgetStatePropertyAll(Colors.white)),
                                    onPressed: () {
                                      Get.to(() => const ReferEarnPage());
                                    },
                                    icon: Image.asset(
                                      "assets/drawer_icons/ic_share.png",
                                      width: 30,
                                    )),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            // Wrap(
                            //   spacing: 8.0, // Adjust spacing between items as needed
                            //   runSpacing: 8.0, // Adjust spacing between lines as needed
                            //   children: [
                            //     Card(
                            //       color: const Color.fromARGB(255, 68, 44, 0),
                            //       child: InkWell(
                            //         onTap: () {
                            //           HomePageController.marketType.value = "gali";
                            //           HomePageController.marketList();
                            //           HomePageController.getMarketList();
                            //         },
                            //         child: const Padding(
                            //           padding: EdgeInsets.all(8.0),
                            //           child: Center(
                            //             child: Text(
                            //               "Gali Disawar",
                            //               style: TextStyle(
                            //                   color: Colors.white, fontSize: 20),
                            //             ),
                            //           ),
                            //         ),
                            //       ),
                            //     ),
                            //      Card(
                            //       color: const Color.fromARGB(255, 68, 44, 0),
                            //       child: InkWell(
                            //         onTap: () {
                            //           HomePageController.marketType.value = "mumbai";
                            //           HomePageController.getStarLineMarketList();
                            //         },
                            //         child: const Padding(
                            //           padding: EdgeInsets.all(8.0),
                            //           child: Center(
                            //             child: Text(
                            //               "Mumbai market",
                            //               style: TextStyle(
                            //                   color: Colors.white, fontSize: 20),
                            //             ),
                            //           ),
                            //         ),
                            //       ),
                            //     ),
                            //      Card(
                            //       color: const Color.fromARGB(255, 68, 44, 0),
                            //       child: InkWell(
                            //         onTap: () {
                            //           HomePageController.getColorMarketList();
                            //           HomePageController.marketType.value = "other";
                            //         },
                            //         child: const Padding(
                            //           padding: EdgeInsets.all(8.0),
                            //           child: Center(
                            //             child: Text(
                            //               "Star Line Market",
                            //               style: TextStyle(
                            //                   color: Colors.white, fontSize: 20),
                            //             ),
                            //           ),
                            //         ),
                            //       ),
                            //     )
                            //   ]
                            // )
                          ],
                        ),
                      )),
                  Obx(() => HomePageController.marketList.isEmpty
                      ? const CircularProgressIndicator()
                      : _marketList())
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final name = html.window.localStorage['member_name'];

    return Drawer(
      backgroundColor: Colors.black,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text("${name}",style: TextStyle(color: Colors.black),),
            accountEmail: Text("${html.window.localStorage['member_mobile']}",style: TextStyle(color: Colors.black),),
            currentAccountPicture: CircleAvatar(
              child: Text(
                "${name?.substring(0, 1).toUpperCase()}",
                style: const TextStyle(fontSize: 30,color: Colors.black),
              ), // Replace with your image URL
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
          ),
          ListTile(
            leading: Image.asset(
              "assets/drawer_icons/ic_home.png",
              width: 30,
            ),
            title: const Text('Home',style: TextStyle(color: Colors.white),),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Image.asset(
              "assets/drawer_icons/ic_bank.png",
              width: 30,
            ),
            title: const Text('Add Bank Details',style: TextStyle(color: Colors.white),),
            onTap: () {
              // Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddBankDetailsPage(),));
              // Navigator.pop(context);
              Get.to(() => const AddBankDetailsPage());
              // GoRouter.of(context).go('/addBank');
            },
          ),
          ListTile(
            leading: Image.asset(
              "assets/drawer_icons/ic_payment_method.png",
              width: 30,
            ),
            title: const Text('Manage Payment',style: TextStyle(color: Colors.white),),
            onTap: () {
              // /Navigator.of(context).push(MaterialPageRoute(builder: (context) => ManagePaymentPage(),));
              Get.to(() => const ManagePaymentPage());
              // GoRouter.of(context).go('/managePayment');
              // Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.play_arrow),
            title: const Text('Refer & Earn',style: TextStyle(color: Colors.white),),
            onTap: () {
              // Navigator.of(context).push(MaterialPageRoute(builder: (context) => ReferEarnPage(),));
              // setState(() {
              //
              // });
              Get.to(() => const ReferEarnPage());
              // Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Image.asset(
              "assets/drawer_icons/ic_rupees.png",
              width: 30,
            ),
            title: const Text('Add Money',style: TextStyle(color: Colors.white),),
            onTap: () {
              // Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddMoneyPage(),));
              // setState(() {
              //
              // });
              Get.to(() => const AddMoneyPage());
              // GoRouter.of(context).go('/addMoney');
            },
          ),
          // ListTile(
          //   leading: Image.asset(
          //     "assets/drawer_icons/transfer_icon.png",
          //     width: 30,
          //   ),
          //   title: const Text('Transfer Money',style: TextStyle(color: Colors.white),),
          //   onTap: () {
          //     // Navigator.of(context).push(MaterialPageRoute(builder: (context) => TransferMoneyPage(),));
          //     // setState(() {
          //     //
          //     // });
          //     Get.to(() => const TransferMoneyPage());
          //     // Navigator.pop(context);
          //   },
          // ),
          ListTile(
            leading: Image.asset(
              "assets/drawer_icons/withdraw_icon.png",
              width: 30,
            ),
            title: const Text('Withdraw Money',style: TextStyle(color: Colors.white),),
            onTap: () {
              // Navigator.of(context).push(MaterialPageRoute(builder: (context) => WithdrawMoneyPage(),));
              // setState(() {
              //
              // });
              Get.to(() => const WithdrawMoneyPage());
              // GoRouter.of(context).go('/withdrawMoney');
            },
          ),
          ListTile(
            leading: Image.asset(
              "assets/drawer_icons/ic_padlock.png",
              width: 30,
            ),
            title: const Text('Reset Password',style: TextStyle(color: Colors.white),),
            onTap: () {
              // Navigator.of(context).push(MaterialPageRoute(builder: (context) => ResetPasswordPage(),));
              // setState(() {
              //
              // });
              // Get.to(() => const ResetPasswordPage());
              GoRouter.of(context).go('/resetPass');
            },
          ),
          ListTile(
            leading: Image.asset(
              "assets/drawer_icons/ic_history.png",
              width: 30,
            ),
            title: const Text('Bet History',style: TextStyle(color: Colors.white),),
            onTap: () {
              // Navigator.of(context).push(MaterialPageRoute(builder: (context) => BetHistoryPage(),));
              // setState(() {
              //
              // });
              Get.to(() => const BetHistoryPage());
            },
          ),
          ListTile(
            leading: Image.asset(
              "assets/drawer_icons/ic_history.png",
              width: 30,
            ),
            title: const Text('Wining History',style: TextStyle(color: Colors.white),),
            onTap: () {
              // Navigator.of(context).push(MaterialPageRoute(builder: (context) => WinningHistoryPage(),));
              // setState(() {
              //
              // });
              Get.to(() => const WinningHistoryPage());
            },
          ),
          ListTile(
            leading: Image.asset(
              "assets/drawer_icons/icon_wallet.png",
              width: 30,
            ),
            title: const Text('Wallet Transactions',style: TextStyle(color: Colors.white),),
            onTap: () {
              // Navigator.of(context).push(MaterialPageRoute(builder: (context) => WalletTransactionPage(),));
              // setState(() {
              //
              // });
              Get.to(() => const WalletTransactionPage());
            },
          ),
          ListTile(
            leading: const Icon(Icons.confirmation_num),
            title: const Text('Game Rate',style: TextStyle(color: Colors.white),),
            onTap: () {
              // Navigator.of(context).push(MaterialPageRoute(builder: (context) => GameRatePage(),));
              // setState(() {
              //
              // });
              Get.to(() => const GameRatePage());
            },
          ),
          // ListTile(
          //   leading: const Icon(Icons.chat),
          //   title: const Text('Chat with Us',style: TextStyle(color: Colors.white),),
          //   onTap: () {
          //     Get.to(() => const ChatPage());
          //   },
          // ),
          // ListTile(
          //   leading: Image.asset(
          //     "assets/drawer_icons/ic_share.png",
          //     width: 30,
          //   ),
          //   title: const Text('Share',style: TextStyle(color: Colors.white),),
          //   onTap: () {
          //     Navigator.pop(context);
          //   },
          // ),
          // ListTile(
          //   leading: Image.asset(
          //     "assets/drawer_icons/ic_rating.png",
          //     width: 30,
          //   ),
          //   title: const Text('Rate App',style: TextStyle(color: Colors.white),),
          //   onTap: () {
          //     Navigator.pop(context);
          //   },
          // ),
          ListTile(
            leading: Image.asset(
              "assets/drawer_icons/ic_logout.png",
              width: 30,
            ),
            title: const Text('Logout',style: TextStyle(color: Colors.white),),
            onTap: () {
              UserInfo.removeUserInfo();
              Get.to(() => const LoginPage());
            },
          ),
          // Add more ListTiles as needed
        ],
      ),
    );
  }

  Widget _marketList() {
    if(GlobalFunctions.isSuccessful(HomePageController.marketType.value, "gali")){
      print("gali market is ready");
      return Obx(
            () => Wrap(
          spacing: 8.0, // Adjust spacing between items as needed
          runSpacing: 8.0, // Adjust spacing between lines as needed
          children: List.generate(HomePageController.marketList.length, (index) {
            DelhiMarketModel item = HomePageController.marketList[index];
            return DelhiMarketCard(
              model: item,
            );
          }),
        ),
      );
      } else if(GlobalFunctions.isSuccessful(HomePageController.marketType.value, "mumbai")){
      print("mumbai market is ready");
      return Obx(
            () => Wrap(
          spacing: 8.0, // Adjust spacing between items as needed
          runSpacing: 8.0, // Adjust spacing between lines as needed
          children: List.generate(HomePageController.marketList.length, (index) {
            StarLineMarketModel item = HomePageController.marketList[index];
            return MumbaiMarketCard(
              model: item,
            );
          }),
        ),
      );
      return SizedBox();
    } else{
      print("why are you not running");
      return Obx(
            () => Wrap(
          spacing: 8.0, // Adjust spacing between items as needed
          runSpacing: 8.0, // Adjust spacing between lines as needed
          children: List.generate(HomePageController.marketList.length, (index) {
            ColorBetMarketModel item = HomePageController.marketList[index];
            return ColorMarketCard(
              model: item,
            );
          }),
        ),
      );
      return SizedBox();
    }

  }

}


