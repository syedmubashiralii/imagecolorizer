package com.example.dioldifi

import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {

}




//
//import android.annotation.SuppressLint
//import android.content.Context
//import android.content.ContextWrapper
//import android.content.Intent
//import android.content.IntentFilter
//import android.net.wifi.WifiManager
//import android.os.BatteryManager
//import android.os.Build.VERSION
//import android.os.Build.VERSION_CODES
//import androidx.annotation.NonNull
//import io.flutter.embedding.android.FlutterActivity
//import io.flutter.embedding.engine.FlutterEngine
//import io.flutter.plugin.common.MethodChannel
//
//class MainActivity: FlutterActivity() {
//  private val CHANNEL = "flutter.native/helper"
//    lateinit var wifiManager: WifiManager
//  override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
//    super.configureFlutterEngine(flutterEngine)
//     MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
//      // This method is invoked on the main thread.
//      call, result ->
//      if (call.method == "getBatteryLevel") {
//        val batteryLevel = getBatteryLevel()
//
//        if (batteryLevel != -1) {
//          result.success(batteryLevel)
//        } else {
//          result.error("UNAVAILABLE", "Battery level not available.", null)
//        }
//      }
//
//       else if (call.method == "getMyName") {
//        val name  = getName()
//         result.success(name)
//
//      }
//
//       else {
//        result.notImplemented()
//      }
//    }
//
//  }
//    private fun getBatteryLevel(): Int {
//    val batteryLevel: Int
//    if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
//      val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
//      batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
//    } else {
//      val intent = ContextWrapper(applicationContext).registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
//      batteryLevel = intent!!.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100 / intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
//    }
//
//    return batteryLevel
//  }
//
//
//  @SuppressLint("SuspiciousIndentation")
//  private fun getName(): String{
////      wifiManager = applicationContext.getSystemService(Context.WIFI_SERVICE) as WifiManager wifiManager.isWifiEnabled = false
//      val wifi = getSystemService(WIFI_SERVICE) as WifiManager
//      wifi.setWifiEnabled(true)
//      System.out.println("Status = "+wifi.isWifiEnabled);
//
//      return "True";
//
//
//
//  }
//
//}





