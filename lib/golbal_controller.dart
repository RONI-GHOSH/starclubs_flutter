import 'package:get/get.dart';

import 'models/admin_model.dart';

class GlobalController extends GetxController{
   // final adminDetails = Rxn<AdminModel>();
  static Rx<AdminModel?> adminModel = (null as AdminModel?).obs;
  static RxDouble walletMoney = 0.0.obs;
  static void updateAdminModel(AdminModel model) {
    adminModel.value = model;
  }
}