import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../Utils/Adids.dart';
import '../Utils/Constants.dart';

class GetAds extends ChangeNotifier {
  // banner at imagepicker page
  late BannerAd imagepickerpage;
  bool isimagepickerpagebannerloaded = false;
  // banner at videopicker page
  late BannerAd videopickerpage;
  bool isvideopickerpagebannerloaded = false;
  // banner at home page
  late BannerAd homePage;
  bool ishomepagebannerloaded = false;
  // banner at editor page
  late BannerAd editorpage;
  bool iseditorpagebannerloaded = false;
  //album page
  late BannerAd albumpage;
  bool isalbumpagebannerloaded = false;

//  createAnchoredBanner(BuildContext context) async {
//     final AnchoredAdaptiveBannerAdSize? size =
//         await AdSize.getAnchoredAdaptiveBannerAdSize(
//       Orientation.portrait,
//       MediaQuery.of(context).size.width.truncate(),
//     );

//     if (size == null) {
//       print('Unable to get height of anchored banner.');
//       return;
//     }

//     homePage = BannerAd(
//       size: size,
//       request: request,
//       adUnitId: AdIds.bannerAdUnitId,
//       listener: BannerAdListener(
//         onAdLoaded: (Ad ad) {
//           debugPrint("Successfully Load A Banner Ad");
//           ishomepagebannerloaded = true;
//           notifyListeners();
//         },
//         onAdFailedToLoad: (Ad ad, LoadAdError error) {
//           debugPrint("Failed to Load A Banner Ad = ${error}");
//           ishomepagebannerloaded = false;
//           notifyListeners();
//           ad.dispose();
//         },
//       ),
//     );
//     homePage.load();
//   }

  HomePageBanner() async {
    homePage = BannerAd(
      // Change Banner Size According to Ur Need
      size: AdSize.banner,
      adUnitId: AdIds.bannerAdUnitId,
      request: request,
      listener: BannerAdListener(onAdLoaded: (_) {
        debugPrint("Successfully Load A Banner Ad");
        ishomepagebannerloaded = true;
        notifyListeners();
      }, onAdFailedToLoad: (ad, LoadAdError error) {
        debugPrint("Failed to Load A Banner Ad = ${error}");
        ishomepagebannerloaded = false;
        notifyListeners();
        ad.dispose();
      }),
    );
    homePage.load();
  }

  AlbumPageBanner() {
    albumpage = BannerAd(
      // Change Banner Size According to Ur Need
      size: AdSize.banner,
      adUnitId: AdIds.bannerAdUnitId,
      request: request,
      listener: BannerAdListener(onAdLoaded: (_) {
        debugPrint("Successfully Load A Banner Ad");
        isalbumpagebannerloaded = true;
        notifyListeners();
      }, onAdFailedToLoad: (ad, LoadAdError error) {
        debugPrint("Failed to Load A Banner Ad = ${error}");
        isalbumpagebannerloaded = false;
        notifyListeners();
        ad.dispose();
      }),
    );
    albumpage.load();
  }

  EditorPageBanner() async {
    editorpage = BannerAd(
      // Change Banner Size According to Ur Need
      size: AdSize.banner,
      adUnitId: AdIds.bannerAdUnitId,
      request: request,
      listener: BannerAdListener(onAdLoaded: (_) {
        debugPrint("Successfully Load A Banner Ad");
        iseditorpagebannerloaded = true;
        notifyListeners();
      }, onAdFailedToLoad: (ad, LoadAdError error) {
        debugPrint("Failed to Load A Banner Ad = ${error}");
        iseditorpagebannerloaded = false;
        notifyListeners();
        ad.dispose();
      }),
    );
    editorpage.load();
  }

  ImagePickerPageBanner() {
    imagepickerpage = BannerAd(
      // Change Banner Size According to Ur Need
      size: AdSize.banner,
      adUnitId: AdIds.bannerAdUnitId,
      request: request,
      listener: BannerAdListener(onAdLoaded: (_) {
        debugPrint("Successfully Load A Banner Ad");
        isimagepickerpagebannerloaded = true;
        notifyListeners();
      }, onAdFailedToLoad: (ad, LoadAdError error) {
        debugPrint("Failed to Load A Banner Ad = ${error}");
        isimagepickerpagebannerloaded = false;
        notifyListeners();
        ad.dispose();
      }),
    );
    imagepickerpage.load();
  }

  VideoPickerPageBanner() {
    videopickerpage = BannerAd(
      // Change Banner Size According to Ur Need
      size: AdSize.banner,
      adUnitId: AdIds.bannerAdUnitId,
      request: request,
      listener: BannerAdListener(onAdLoaded: (_) {
        debugPrint("Successfully Load A Banner Ad");
        isvideopickerpagebannerloaded = true;
        notifyListeners();
      }, onAdFailedToLoad: (ad, LoadAdError error) {
        debugPrint("Failed to Load A Banner Ad = ${error}");
        isvideopickerpagebannerloaded = false;
        notifyListeners();
        ad.dispose();
      }),
    );
    videopickerpage.load();
  }

  bool loading = true;

  onloading() async {
    loading = true;
    await Future.delayed(const Duration(milliseconds: 6000));
    loading = false;
    notifyListeners();
  }

  static AdRequest request = const AdRequest(
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );

  InterstitialAd? startint;
  InterstitialAd? editorint;
  InterstitialAd? backint;
  InterstitialAd? albumint;
  int _numInterstitialLoadAttempts = 0;
  int maxFailedLoadAttempts = 3;

  createstartint() {
    InterstitialAd.load(
        adUnitId: AdIds.startint,
        request: request,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            startint = ad;
            _numInterstitialLoadAttempts = 0;
            startint!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            _numInterstitialLoadAttempts += 1;
            startint = null;
            if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
              createstartint();
            }
          },
        ));
  }

  createeditorint() {
    InterstitialAd.load(
        adUnitId: AdIds.editorint,
        request: request,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            editorint = ad;
            _numInterstitialLoadAttempts = 0;
            editorint!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            _numInterstitialLoadAttempts += 1;
            editorint = null;
            if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
              createeditorint();
            }
          },
        ));
  }

  createBackInterstitialad() {
    InterstitialAd.load(
        adUnitId: AdIds.backint,
        request: request,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            backint = ad;
            _numInterstitialLoadAttempts = 0;
            backint!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            _numInterstitialLoadAttempts += 1;
            backint = null;
            if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
              createBackInterstitialad();
            }
          },
        ));
  }

  Createalbuminiterstitial() {
    InterstitialAd.load(
        adUnitId: AdIds.Albumint,
        request: request,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            albumint = ad;
            _numInterstitialLoadAttempts = 0;
            albumint!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            _numInterstitialLoadAttempts += 1;
            albumint = null;
            if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
              Createalbuminiterstitial();
            }
          },
        ));
  }

  showeditorint() {
    if (editorint == null) {
      return;
    }
    editorint!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          debugPrint('\nad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
        createeditorint();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        ad.dispose();
        createeditorint();
      },
    );
    editorint!.show();
    editorint = null;
  }

  showstartint() {
    if (startint == null) {
      istartadshown = false;
      return;
    }
    startint!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) {
        debugPrint('\nad onAdShowedFullScreenContent.');
        istartadshown = true;
      },
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
        istartadshown = true;
        createstartint();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        ad.dispose();
        istartadshown = false;
        createstartint();
      },
    );
    startint!.show();
    startint = null;
  }

  showbackinterstitial() {
    if (backint == null) {
      isbackadshown = false;
      return;
    }
    backint!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) {
        debugPrint('\nad onAdShowedFullScreenContent.');
        isbackadshown = true;
      },
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
        isbackadshown = true;
        createBackInterstitialad();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        isbackadshown = false;
        ad.dispose();
        createBackInterstitialad();
      },
    );
    backint!.show();
    backint = null;
  }

  showalbumint() {
    if (albumint == null) {
      return;
    }
    albumint!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          debugPrint('\nad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
        Createalbuminiterstitial();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        ad.dispose();
        Createalbuminiterstitial();
      },
    );
    albumint!.show();
    albumint = null;
  }
}
