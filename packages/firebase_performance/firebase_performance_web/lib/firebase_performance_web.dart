import 'package:firebase/firebase.dart' as firebase;
import 'package:firebase_performance_platform_interface/firebase_performance_platform_interface.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

/// Web implementation for [FirebasePerformancePlatform]
class FirebasePerformanceWeb extends FirebasePerformancePlatform {
  /// A constructor that allows tests to override the firebase.Performance object.
  FirebasePerformanceWeb({firebase.Performance? performance})
      : _performance = performance ?? firebase.performance();

  /// Instance of Performance from the web plugin.
  final firebase.Performance _performance;

  /// Called by PluginRegistry to register this plugin for Flutter Web
  static void registerWith(Registrar registrar) {
    FirebasePerformancePlatform.instance = FirebasePerformanceWeb();
  }
}
