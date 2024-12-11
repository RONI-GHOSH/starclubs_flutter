import 'dart:html' as html;

import '../golbal_controller.dart';

class UserProfileModel {
  final String status;
  final String transferStatus;
  final String bettingStatus;
  final String name;
  final String number;
  final String balance;

  UserProfileModel({
    required this.status,
    required this.transferStatus,
    required this.bettingStatus,
    required this.name,
    required this.number,
    required this.balance,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
        status: json['member_status'],
        transferStatus: json['member_transferstatus'],
        bettingStatus: json['member_bettingstatus'],
        name: json['member_name'],
        number: json['member_mobile'],
        balance: json['member_wallet_balance']);
  }

  void  updateUserDetails() async {
    html.window.localStorage['member_name'] = name;
    html.window.localStorage['member_status'] = status;
    html.window.localStorage['member_transferstatus'] = transferStatus;
    html.window.localStorage['member_bettingstatus'] = bettingStatus;
    html.window.localStorage['member_mobile'] = number;
    html.window.localStorage['member_wallet_balance'] = balance;
    GlobalController.walletMoney.value = double.parse(
        html.window.localStorage['member_wallet_balance'] ?? '0.0');
    print(GlobalController.walletMoney.value);
  }
}
