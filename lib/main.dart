import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:dioldifi/Controllers/CoinsController.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import '/UI/LandingPage.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Controllers/Ads_Controller.dart';
import 'Controllers/AlbumController.dart';
import 'Controllers/ImagesController.dart';
import 'Controllers/LoginSignUpController.dart';
import 'UI/LoginPage.dart';
import 'Utils/Constants.dart';
import 'Utils/Functions.dart';
import 'Utils/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await MobileAds.instance.initialize();
  if (kDebugMode) {
    MobileAds.instance.initialize().then((initializationStatus) {
      initializationStatus.adapterStatuses.forEach((key, value) {
        debugPrint('Adapter status for $key: ${value.description}');
      });
    });
    await MobileAds.instance
        .updateRequestConfiguration(RequestConfiguration(testDeviceIds: [
      '207F634965BDB8A1770F48FCBDCC687E',
      '608354B9C20C9712E0DDD21BF1B87519',
      '259B8E84159393A011811CF8414D3001'
    ]));
  }

  configLoading();
  if (Platform.isAndroid) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } else {
    await Firebase.initializeApp();
  }
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
//for test crash
  //FirebaseCrashlytics.instance.crash();
  await EasyLocalization.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: ((context) => ImagesController()),
        ),
        ChangeNotifierProvider(
          create: ((context) => MyAlbumController()),
        ),
        ChangeNotifierProvider(
          create: ((context) => coinsController()),
        ),
        ChangeNotifierProvider(create: ((context) => GetAds()))
      ],
      child: EasyLocalization(
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('hi', 'IN'),
          Locale('pt', 'BR'),
          Locale('ar', 'AR'),
          Locale('de', 'DE'),
          Locale('fr', 'FR'),
          Locale('ur', 'PK'),
          Locale('es', 'ES')
        ],
        path: 'assets/translations',
        fallbackLocale: const Locale('en', 'US'),
        child: const MyApp(),
      ),
    ),
  );
}

void configLoading() {
  EasyLoading.instance.toastPosition = EasyLoadingToastPosition.bottom;
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);
  bool isloggedin = false;
  @override
  void initState() {
    super.initState();
    user = LoginSignup().CurrentUser();
    if (user == null) {
      isloggedin = false;
      setState(() {});
    } else {
      isloggedin = true;
      setState(() {});
      getcoins(context);
      getadsstatuts(context);
    }
    if (kDebugMode) {
      log(isloggedin.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      title: 'Color Magic Pro',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      builder: EasyLoading.init(),
      // home: LandingPage(
      //   locale: context.locale,
      // )
      navigatorObservers: <NavigatorObserver>[observer],
      home: !isloggedin
          ? Login()
          : LandingPage(
              locale: context.locale,
              analytics: analytics,
              observer: observer,
            ),
    );
  }
}
















//method channel

//
//
//
//
// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'package:flutter/services.dart';

// void main() => runApp(new MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return new MaterialApp(
//       home: new HomePage(),
//     );
//   }
// }

// class HomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return new Scaffold(
//       appBar: new AppBar(
//         title: const Text('Native Code from Dart'),
//       ),
//       body: new MyHomePage(title: ""),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key? key, this.title}) : super(key: key);
//   final String? title;
//   @override
//   _MyHomePageState createState() => new _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   static const platform = const MethodChannel('flutter.native/helper');
//   String _responseFromNativeCode = 'Waiting for Response...';


//   Future<void> responseFromNativeCode() async {
//     String response = "";
//     try {
//        int result1 = await platform.invokeMethod('getBatteryLevel');
//        print("answer = ${result1}");
//       // String result = result1+"";
//       response = "result = ${result1.toString()}";
//     } on PlatformException catch (e) {
//       response = "Failed to Invoke: '${e.message}'.";
//     }
//     setState(() {
//       _responseFromNativeCode = response;
//     });
//   }

  
//   Future<void> getMyNamee() async {
//     String response = "";
//     try {
//       String result1 = await platform.invokeMethod('getMyName');
//       print("answer = ${result1}");
//       // String result = result1+"";
//       response = "result = ${result1.toString()}";
//     } on PlatformException catch (e) {
//       response = "Failed to Invoke: '${e.message}'.";
//     }
//     setState(() {
//       _responseFromNativeCode = response;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       child: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             ElevatedButton(
//               child: Text('Call Native Method'),
//               onPressed: responseFromNativeCode,
//             ),
//              ElevatedButton(
//               child: Text('Call Name Method'),
//               onPressed: getMyNamee,
//             ),
//             Text(_responseFromNativeCode),
//           ],
//         ),
//       ),
//     );
//   }
// }
