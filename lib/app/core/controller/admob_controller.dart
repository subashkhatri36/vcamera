// import 'dart:io';

// import 'package:app_tracking_transparency/app_tracking_transparency.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:vcamera/app/constant/AdHelper.dart';
// import 'package:vcamera/app/utlis/device_info.dart';

// class AdmobController extends GetxController {
//   static AdmobController instance = Get.find();

//   String iosAdsStatus = "Unknown";
//   late InterstitialAd interstitialAd;
//   bool isInterstitialAdReady = false;

//   AdmobController() {
//     initIosTrackingPlugin();
//     initGoogleMobileAds();
//     loadInterstitialAd();
//   }
//   showInstAds() {
//     if (isInterstitialAdReady) {
//       interstitialAd.show();
//     }
//   }

//   Future<InitializationStatus> initGoogleMobileAds() {
//     return MobileAds.instance.initialize();
//   }

//   void loadInterstitialAd() {
//     InterstitialAd.load(
//       adUnitId: AdHelper.interstitialAdUnitId,
//       request: AdRequest(),
//       adLoadCallback: InterstitialAdLoadCallback(
//         onAdLoaded: (ad) {
//           this.interstitialAd = ad;

//           ad.fullScreenContentCallback = FullScreenContentCallback(
//             onAdDismissedFullScreenContent: (ad) {
//               loadInterstitialAd();
//             },
//           );

//           isInterstitialAdReady = true;
//         },
//         onAdFailedToLoad: (err) {
//           //('Failed to load an interstitial ad: ${err.message}');
//           isInterstitialAdReady = false;
//         },
//       ),
//     );
//   }

//   // initialize the ios tracking plugin if platform is ios and has IOS version > 14
//   Future<void> initIosTrackingPlugin() async {
//     if (Platform.isIOS && await DeviceInfo.isIos14andAbove())
//       initIOSTrackingPlugin();
//   }

//   // display permission popup to ask for privacy permission
//   Future<void> initIOSTrackingPlugin() async {
//     // Platform messages may fail, so we use a try/catch PlatformException.
//     try {
//       final TrackingStatus status =
//           await AppTrackingTransparency.trackingAuthorizationStatus;
//       iosAdsStatus = '$status';
//       if (status == TrackingStatus.denied) return;
//       // If the system can show an authorization request dialog
//       if (status == TrackingStatus.notDetermined) {
//         // Request system's tracking authorization dialog
//         final TrackingStatus status =
//             await AppTrackingTransparency.requestTrackingAuthorization();
//         iosAdsStatus = '$status';
//       }
//     } on PlatformException {
//       // print('PlatformException was thrown');
//     }
//   }
// }
