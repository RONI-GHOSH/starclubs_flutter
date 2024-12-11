import 'package:go_router/go_router.dart';
import 'package:matka_web/presentation/pages/add_bank_details_page.dart';
import 'package:matka_web/presentation/pages/add_money_page.dart';
import 'package:matka_web/presentation/pages/bet_history_page.dart';
import 'package:matka_web/presentation/pages/home_page/screens/home_page.dart';
import 'package:matka_web/presentation/pages/login_page.dart';
import 'package:matka_web/presentation/pages/manage_payment_page.dart';
import 'package:matka_web/presentation/pages/register_page.dart';
import 'package:matka_web/presentation/pages/reset_password_page.dart';
import 'package:matka_web/presentation/pages/splash_page.dart';
import 'package:matka_web/presentation/pages/transfer_money_page.dart';
import 'package:matka_web/presentation/pages/wallet_transaction_page.dart';
import 'package:matka_web/presentation/pages/winning_history_page.dart';
import 'package:matka_web/presentation/pages/withdraw_money_page.dart';
import 'package:matka_web/storage/user_info.dart';

import 'main.dart';

// GoRouter configuration
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => MyApp(),
      redirect: (context, state) async {
        final id = await UserInfo.getUserInfo();
        print("User ID: $id");
        // Check if user ID is not empty, meaning the user is logged in
        if (id.isNotEmpty) {
          return '/home'; // Redirect to home if logged in
        } else {
          return '/login'; // Redirect to login if not logged in
        }
      },
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => HomePage(),
    ),GoRoute(
      path: '/login',
      builder: (context, state) => LoginPage(),
      redirect: (context, state) async {
        final id = await UserInfo.getUserInfo();
        if (id.isNotEmpty) {
          return '/home'; // Prevent going back to login page if already logged in
        }
        return null;
      },
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => RegisterPage(),
    ),
    GoRoute(
      path: '/addBank',
      builder: (context, state) => AddBankDetailsPage(),
    ),
    GoRoute(
      path: '/addMoney',
      builder: (context, state) => AddMoneyPage(),
    ),
    GoRoute(
      path: '/betHistory',
      builder: (context, state) => BetHistoryPage(),
    ),
    GoRoute(
      path: '/managePayment',
      builder: (context, state) => ManagePaymentPage(),
    ),
    GoRoute(
      path: '/resetPass',
      builder: (context, state) => ResetPasswordPage(),
    ),
    GoRoute(
      path: '/transferMoney',
      builder: (context, state) => TransferMoneyPage(),
    ),
    GoRoute(
      path: '/walletTransaction',
      builder: (context, state) => WalletTransactionPage(),
    ),
    GoRoute(
      path: '/winningHistory',
      builder: (context, state) => WinningHistoryPage(),
    ),
    GoRoute(
      path: '/withdrawMoney',
      builder: (context, state) => WithdrawMoneyPage(),
    ),
  ],
);