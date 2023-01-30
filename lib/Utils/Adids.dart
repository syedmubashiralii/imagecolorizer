import 'dart:io';

class AdIds {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-5238824914705486/6503668322';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-5238824914705486/1041025449';
    }
    return "";
  }

  static String get startint {
    if (Platform.isAndroid) {
      return 'ca-app-pub-5238824914705486/3884124280';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-5238824914705486/3256125247';
    }
    return "";
  }

  static String get backint {
    if (Platform.isAndroid) {
      return 'ca-app-pub-5238824914705486/3051508476';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-5238824914705486/9438390211';
    }
    return "";
  }

  static String get editorint {
    if (Platform.isAndroid) {
      return 'ca-app-pub-5238824914705486/9616916828';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-5238824914705486/5071753882';
    }
    return "";
  }

  static String get Albumint {
    if (Platform.isAndroid) {
      return 'ca-app-pub-5238824914705486/1996612952';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-5238824914705486/9629961908';
    }
    return "";
  }
}
