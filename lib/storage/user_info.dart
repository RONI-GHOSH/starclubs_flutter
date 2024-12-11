import 'package:shared_preferences/shared_preferences.dart';
import 'dart:html' as html;
class UserInfo{
  static Future<void> storeUserInfo(String uId ) async {
    print(uId);
    html.window.localStorage['member_id'] = uId;
    final id = html.window.localStorage['member_id'];
    print(id.toString());
  }
  static Future<String> getUserInfo() async {
    final id = html.window.localStorage['member_id'];
    print(id);
    return id ?? '';
  }
  static Future<void> removeUserInfo() async {
    html.window.localStorage.remove('member_id');
    html.window.localStorage.remove('member_name');
    html.window.localStorage.remove('member_mobile');
    final id = html.window.localStorage['member_id'];
    print(id);
  }

}