/*
    Created by Shitab Mir on 18 October 2021
 */

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class UIUtil {

  static UIUtil instance = UIUtil();

  /// Loader Behavior
  void showLoading() {
    EasyLoading.show(status: 'Loading',
        dismissOnTap: false,
        maskType: EasyLoadingMaskType.black);
  }

  void stopLoading() {
    EasyLoading.dismiss(animation: true);
  }

  void onNoInternet() {
    EasyLoading.show(status: "No Internet!",
        indicator: const Icon(Icons.signal_cellular_connected_no_internet_4_bar,
          color: Colors.white70,),
        dismissOnTap: true,
        maskType: EasyLoadingMaskType.black).then((value) {
      Timer(const Duration(seconds: 3), () => EasyLoading.dismiss());
    });

  }

  void onFailed(String failedMsg) {
    EasyLoading.show(status: failedMsg,
        indicator: const Icon(Icons.sms_failed_outlined, color: Colors.white70,),
        dismissOnTap: true,
        maskType: EasyLoadingMaskType.black).then((value) {
      Timer(const Duration(seconds: 3), () => EasyLoading.dismiss());
    });
  }
}