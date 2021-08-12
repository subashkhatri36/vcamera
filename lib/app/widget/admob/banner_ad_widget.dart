// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:vcamera/app/constant/AdHelper.dart';
// import 'package:vcamera/app/constant/controller.dart';
// import 'package:vcamera/app/utlis/device_info.dart';

// /// returns the admob banner ad widget if it is ready
// class AdmobBannerAdWidget extends StatefulWidget {
//   AdmobBannerAdWidget({Key? key}) : super(key: key);

//   @override
//   _AdmobBannerAdWidgetState createState() => _AdmobBannerAdWidgetState();
// }

// class _AdmobBannerAdWidgetState extends State<AdmobBannerAdWidget> {
//   /// check if the ads is loading or not
//   bool loadingAnchoredBanner = false;

//   ///banner ad variable
//   BannerAd? anchoredBanner;

//   /// adrequest object
//   static final AdRequest request = AdRequest(
//     keywords: <String>[
//       'nepal',
//       'driving',
//       'license',
//       'quiz',
//       'best',
//       'snepali',
//       'sdriving',
//       'slicense',
//       'squiz',
//       'sbest',
//       'bnepal',
//       'bdriving',
//       'blicense',
//       'bquiz',
//       'bbest',
//       'pnepal',
//       'pdriving',
//       'plicense',
//       'pquiz',
//       'pbest'
//     ],
//     nonPersonalizedAds: true,
//   );

//   @override
//   void initState() {
//     super.initState();
//   }

//   // /// Load admob ads
//   Future<void> loadAd() async {
//     loadingAnchoredBanner = true;
//     if (Platform.isIOS) {
//       if (await DeviceInfo.isIos14andAbove()) {
//         if (admobController.iosAdsStatus == "TrackingStatus.authorized") {
//           createAnchoredBanner(context);
//         }
//       } else {
//         createAnchoredBanner(context);
//       }
//     }
//     if (Platform.isAndroid) createAnchoredBanner(context);
//   }

//   /// create banner ad
//   Future<void> createAnchoredBanner(BuildContext context) async {
//     final AnchoredAdaptiveBannerAdSize? size = appController.islandscape.value
//         ? await AdSize.getAnchoredAdaptiveBannerAdSize(
//             Orientation.landscape,
//             MediaQuery.of(context).size.height.truncate(),
//           )
//         : await AdSize.getAnchoredAdaptiveBannerAdSize(
//             Orientation.portrait,
//             MediaQuery.of(context).size.width.truncate(),
//           );

//     if (size == null) {
//       // print('Unable to get height of anchored banner.');
//       return;
//     }

//     final BannerAd banner = BannerAd(
//       size: size,
//       request: request,
//       adUnitId: Platform.isAndroid
//           ? AdHelper.bannerAdUnitId
//           : AdHelper.bannerAdUnitId,
//       listener: BannerAdListener(
//         onAdLoaded: (Ad ad) {
//           //   print('$BannerAd loaded.');
//           setState(() {
//             anchoredBanner = ad as BannerAd?;
//           });
//         },
//         onAdFailedToLoad: (Ad ad, LoadAdError error) {
//           //   print('$BannerAd failedToLoad: $error');
//           ad.dispose();
//         },
//         onAdOpened: (Ad ad) => print('$BannerAd onAdOpened.'),
//         onAdClosed: (Ad ad) => print('$BannerAd onAdClosed.'),
//       ),
//     );
//     return banner.load();
//   }

//   @override
//   void dispose() {
//     anchoredBanner?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Builder(builder: (BuildContext context) {
//       if (!loadingAnchoredBanner) {
//         loadAd();
//         loadingAnchoredBanner = true;
//       }
//       return Container(
//         child: (anchoredBanner != null)
//             ? Container(
//                 color: Colors.white,
//                 width: anchoredBanner?.size.width.toDouble(),
//                 height: anchoredBanner?.size.height.toDouble(),
//                 child: AdWidget(ad: anchoredBanner!),
//               )
//             : Container(),
//       );
//     });
//   }
// }
