class AdminModel {
  final String name;
  final String mobile;
  final String whatsappNumber;
  final String upiId;
  final String qrStatus;
  final String qrCode;
  final String paytmUpiId;
  final String phonePeUpiId;
  final String googlePayUpiId;
  final String otherUpiId;
  final String paytmUpiNote;
  final String phonePeUpiNote;
  final String googlePayNote;
  final String otherPayNote;
  final String sliderStatus;
  final String notificationStatus;
  final String callStatus;
  final String whatsappStatus;
  final String gameMode;
  final String starLineStatus;
  final String frontGameStatus;
  final String secondGameStatus;
  final String thirdGameStatus;
  final String fourthGameStatus;
  final String otpStatus;
  final String jantriStatus;
  final String withdrawalStartTime;
  final String withdrawalEndTime;
  final String maximumBidAnk;
  final String maximumBidJodi;
  final String maximumBidPanna;
  final String maximumBidSangam;
  final String holdAmountRequest;
  final String merchantCode;
  final String contactEmail;
  final String appUrl;
  final String offerDescription;
  final String minBettingRate;
  final String minDepositRate;
  final String minWithdrawalRate;
  final String maxDepositRate;
  final String maxWithdrawalRate;
  final String minimumTransfer;
  final String maximumTransfer;
  final String minimumBidMoney;
  final String maximumBidAmount;
  final String welcomeBonus;
  final String youtubeLink;
  final String youtubeDescription;
  final String referDescription;
  final String referAmount;
  final String welcomeTitle;
  final String welcomeDescription;
  final String homeTitleMessage1;
  final String homeTitleMessage2;
  final String pendingAccountMessage;

  AdminModel({
    required this.name,
    required this.mobile,
    required this.whatsappNumber,
    required this.upiId,
    required this.qrStatus,
    required this.qrCode,
    required this.paytmUpiId,
    required this.phonePeUpiId,
    required this.googlePayUpiId,
    required this.otherUpiId,
    required this.paytmUpiNote,
    required this.phonePeUpiNote,
    required this.googlePayNote,
    required this.otherPayNote,
    required this.sliderStatus,
    required this.notificationStatus,
    required this.callStatus,
    required this.whatsappStatus,
    required this.gameMode,
    required this.starLineStatus,
    required this.frontGameStatus,
    required this.secondGameStatus,
    required this.thirdGameStatus,
    required this.fourthGameStatus,
    required this.otpStatus,
    required this.jantriStatus,
    required this.withdrawalStartTime,
    required this.withdrawalEndTime,
    required this.maximumBidAnk,
    required this.maximumBidJodi,
    required this.maximumBidPanna,
    required this.maximumBidSangam,
    required this.holdAmountRequest,
    required this.merchantCode,
    required this.contactEmail,
    required this.appUrl,
    required this.offerDescription,
    required this.minBettingRate,
    required this.minDepositRate,
    required this.minWithdrawalRate,
    required this.maxDepositRate,
    required this.maxWithdrawalRate,
    required this.minimumTransfer,
    required this.maximumTransfer,
    required this.minimumBidMoney,
    required this.maximumBidAmount,
    required this.welcomeBonus,
    required this.youtubeLink,
    required this.youtubeDescription,
    required this.referDescription,
    required this.referAmount,
    required this.welcomeTitle,
    required this.welcomeDescription,
    required this.homeTitleMessage1,
    required this.homeTitleMessage2,
    required this.pendingAccountMessage,
  });

  factory AdminModel.fromJson(Map<String, dynamic> json) {
    return AdminModel(
      name: json['name'],
      mobile: json['mobile'],
      whatsappNumber: json['whatsapp_number'],
      upiId: json['upi_id'],
      qrStatus: json['qr_status'],
      qrCode: json['qr_code'],
      paytmUpiId: json['paytm_upiid'] ?? "",
      phonePeUpiId: json['phonpe_upiid'] ?? "",
      googlePayUpiId: json['googlepay_upiid'] ?? "",
      otherUpiId: json['otherupi_id'] ?? "",
      paytmUpiNote: json['paytm_upinote'],
      phonePeUpiNote: json['phonepe_upinote'],
      googlePayNote: json['google_paynote'],
      otherPayNote: json['other_paynote'],
      sliderStatus: json['slider_status'],
      notificationStatus: json['notification_status'],
      callStatus: json['call_status'],
      whatsappStatus: json['whatsapp_status'],
      gameMode: json['game_mode'],
      starLineStatus: json['starline_status'],
      frontGameStatus: json['front_game_status'],
      secondGameStatus: json['second_game_status'],
      thirdGameStatus: json['third_game_status'],
      fourthGameStatus: json['fourth_game_status'],
      otpStatus: json['OTP_status'],
      jantriStatus: json['jantri_status'],
      withdrawalStartTime: json['withdrawal_start_time'],
      withdrawalEndTime: json['withdrawal_end_time'],
      maximumBidAnk: json['maximum_bid_ank'],
      maximumBidJodi: json['maximum_bid_jodi'],
      maximumBidPanna: json['maximum_bid_panna'],
      maximumBidSangam: json['maximum_bid_sangam'],
      holdAmountRequest: json['hold_amount_request'],
      merchantCode: json['marchant_code'],
      contactEmail: json['contact_email'],
      appUrl: json['app_url'],
      offerDescription: json['offer_description'],
      minBettingRate: json['min_betting_rate'],
      minDepositRate: json['min_deposit_rate'],
      minWithdrawalRate: json['min_withdreal_rate'],
      maxDepositRate: json['max_deposite_rate'],
      maxWithdrawalRate: json['max_withdrawal_rate'],
      minimumTransfer: json['minimum_transfer'],
      maximumTransfer: json['maximum_transfer'],
      minimumBidMoney: json['minimum_bid_money'],
      maximumBidAmount: json['maximum_bid_amount'],
      welcomeBonus: json['welcome_bonus'],
      youtubeLink: json['youtube_link'] ?? "",
      youtubeDescription: json['youtube_description'],
      referDescription: json['refer_description'],
      referAmount: json['refer_amount'],
      welcomeTitle: json['welcome_title'] ?? "",
      welcomeDescription: json['welcome_description'] ?? "",
      homeTitleMessage1: json['home_title_message1'],
      homeTitleMessage2: json['home_title_message2'],
      pendingAccountMessage: json['pending_account_message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'mobile': mobile,
      'whatsapp_number': whatsappNumber,
      'upi_id': upiId,
      'qr_status': qrStatus,
      'qr_code': qrCode,
      'paytm_upiid': paytmUpiId,
      'phonpe_upiid': phonePeUpiId,
      'googlepay_upiid': googlePayUpiId,
      'otherupi_id': otherUpiId,
      'paytm_upinote': paytmUpiNote,
      'phonepe_upinote': phonePeUpiNote,
      'google_paynote': googlePayNote,
      'other_paynote': otherPayNote,
      'slider_status': sliderStatus,
      'notification_status': notificationStatus,
      'call_status': callStatus,
      'whatsapp_status': whatsappStatus,
      'game_mode': gameMode,
      'starline_status': starLineStatus,
      'front_game_status': frontGameStatus,
      'second_game_status': secondGameStatus,
      'third_game_status': thirdGameStatus,
      'fourth_game_status': fourthGameStatus,
      'OTP_status': otpStatus,
      'jantri_status': jantriStatus,
      'withdrawal_start_time': withdrawalStartTime,
      'withdrawal_end_time': withdrawalEndTime,
      'maximum_bid_ank': maximumBidAnk,
      'maximum_bid_jodi': maximumBidJodi,
      'maximum_bid_panna': maximumBidPanna,
      'maximum_bid_sangam': maximumBidSangam,
      'hold_amount_request': holdAmountRequest,
      'marchant_code': merchantCode,
      'contact_email': contactEmail,
      'app_url': appUrl,
      'offer_description': offerDescription,
      'min_betting_rate': minBettingRate,
      'min_deposit_rate': minDepositRate,
      'min_withdreal_rate': minWithdrawalRate,
      'max_deposite_rate': maxDepositRate,
      'max_withdrawal_rate': maxWithdrawalRate,
      'minimum_transfer': minimumTransfer,
      'maximum_transfer': maximumTransfer,
      'minimum_bid_money': minimumBidMoney,
      'maximum_bid_amount': maximumBidAmount,
      'welcome_bonus': welcomeBonus,
      'youtube_link': youtubeLink,
      'youtube_description': youtubeDescription,
      'refer_description': referDescription,
      'refer_amount': referAmount,
      'welcome_title': welcomeTitle,
      'welcome_description': welcomeDescription,
      'home_title_message1': homeTitleMessage1,
      'home_title_message2': homeTitleMessage2,
      'pending_account_message': pendingAccountMessage,
    };
  }
}
