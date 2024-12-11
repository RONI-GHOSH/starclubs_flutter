import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:matka_web/constants.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app_colors.dart';
import '../../global_functions.dart';
import '../../golbal_controller.dart';
import '../../storage/user_info.dart';

class ReferEarnPage extends StatefulWidget {
  const ReferEarnPage({super.key});

  @override
  State<ReferEarnPage> createState() => _ReferEarnPageState();
}

class _ReferEarnPageState extends State<ReferEarnPage> {
  @override
  void initState() {
   
    super.initState();
    getReferralDetails();
  }
  Future<void> _launchUrl() async {
    if (!await launchUrl(Uri.parse("https://wa.me/?text= Download the Most Trusted Matka App - ROYAL SATTA MATKA %0A%0A Benefits:%0A✔ Earn 6% lifetime commission by sharing the app with your friends.%0A✔ Trusted platform for secure gaming.%0A%0A Download Now: royalsattamatka.in %0A Start your journey today and maximize your rewards!%0A%0A Referral code:${_ReferralDetails.code.value}%0Ahttp://starclubs.in"))) {
      throw Exception('Could not launch ');
    }}
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        return GlobalFunctions.refreshPage();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: const Text("Refer & Earn"),
        ),
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            alignment: Alignment.center,
            child: Container(
              width: 400,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    color: Colors.black,
                    child: Container(

                        child: Column(
                          children: [
                            const SizedBox(
                              height: 16,
                            ),
                            Obx(
                              () => Text(
                                "Refer Code :   ${_ReferralDetails.code.value}",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22),
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Html(
                              style: {
                                // Change the text color to white for all text
                                "p": Style(
                                  color: Colors.white, // Set text color to white
                                ),
                                "a": Style(
                                  color: Colors.blue, // Change link color if needed
                                ),
                              },
                              data: GlobalController.adminModel.value?.referDescription,
                            ),
                            TextButton(
                                onPressed: () {},
                                child: const Text(
                                  "Share",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22),
                                )),
                            const SizedBox(
                              height: 8,
                            ),
                             Text(
                              "Refer & Earn upto ${GlobalController.adminModel.value?.referAmount}% on every Bet.",
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: ElevatedButton(
                                  style: const ButtonStyle(
                                      backgroundColor:
                                          WidgetStatePropertyAll(Colors.red)),
                                  onPressed: _launchUrl,
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.share,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 10,),
                                      Text(
                                        "Share Your Link",
                                        style: TextStyle(color: Colors.white),
                                      )
                                    ],
                                  )),
                            ),
                          ],
                        )),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Text(
                    "Referral List",
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Obx(
                    () => _ReferralDetails.memberList.isEmpty
                        ? const Center(
                            child: Text("No Referrals"),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _ReferralDetails.memberList.length,
                            itemBuilder: (context, index) {
                              MemberList member =
                                  _ReferralDetails.memberList[index];
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text(member.referrerId),
                                  Text(member.referrerName),
                                ],
                              );
                            },
                          ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getReferralDetails() async {
    _ReferralDetails.code.value = "";
    _ReferralDetails.memberList.clear();

    final url = Uri.parse("$baseUrl/memberReferralDetails.php");
    final id = await UserInfo.getUserInfo() ?? '';
    final body = {"member_id": id};
    print(url);
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
          print(data);
          _ReferralDetails.code.value = data['referreralcode'].toString();
          final list = data['member_details'] as List;
          _ReferralDetails.memberList.value = list
              .map(
                (e) => MemberList.fromJson(e),
              )
              .toList();
          // Process data
        } catch (e) {
          print('Error decoding JSON: $e');
          // Get.snackbar('Error', 'Failed to decode data');
        }
      } else {
        // Handle server errors
        Get.snackbar("Alert", "Something went wrong");
        // print('Server error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      // Handle exceptions
      print('Request failed with error: $e');
    }
  }
}

class _ReferralDetails extends GetxController {
  static RxString code = "".obs;
  static RxList memberList = [].obs;
}

class MemberList {
  final String referrerId;
  final String referrerName;

  MemberList({
    required this.referrerId,
    required this.referrerName,
  });

  // Factory method to create a Referrer instance from a JSON map
  factory MemberList.fromJson(Map<String, dynamic> json) {
    return MemberList(
      referrerId: json['referrer_id'],
      referrerName: json['referrer_name'],
    );
  }

  // Method to convert a Referrer instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'referrer_id': referrerId,
      'referrer_name': referrerName,
    };
  }
}
