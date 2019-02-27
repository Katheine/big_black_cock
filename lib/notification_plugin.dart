import 'dart:async';

import 'package:flutter/services.dart';

abstract class NotificationPlugin {
  static final _mc = MethodChannel("notification_plugin");
  static setNotification(DateTime time, String name) =>
    _mc.invokeMethod("set_notification", {
      "time": time.millisecondsSinceEpoch,
      "name": name
    });
}