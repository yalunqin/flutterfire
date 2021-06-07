import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';

import '../../firebase_performance_platform_interface.dart';

/// Method Channel delegate for [FirebasePerformancePlatform].
class MethodChannelFirebasePerformance extends FirebasePerformancePlatform {
  /// Creates a new instance for a given [FirebaseApp].
  MethodChannelFirebasePerformance({required FirebaseApp app})
      : super(appInstance: app);

  /// Internal stub class initializer.
  ///
  /// When the user code calls a Performance method, the real instance
  /// is initialized via the [delegateFor] method.
  MethodChannelFirebasePerformance._() : super(appInstance: null);

  /// Keeps an internal handle ID for the channel.
  static int _methodChannelHandleId = 0;

  /// Increments and returns the next channel ID handler for RemoteConfig.
  static int get nextMethodChannelHandleId => _methodChannelHandleId++;

  /// The [MethodChannelRemoteConfig] method channel.
  static const MethodChannel channel =
  MethodChannel('plugins.flutter.io/firebase_performance');

  static Map<String, MethodChannelFirebasePerformance>
  _methodChannelFirebasePerformanceInstances =
  <String, MethodChannelFirebasePerformance>{};

  /// Returns a stub instance to allow the platform interface to access
  /// the class instance statically.
  static MethodChannelFirebasePerformance get instance {
    return MethodChannelFirebasePerformance._();
  }

  // TODO(kroikie): declare any late variables

  /// Gets a [FirebasePerformancePlatform] instance for a specific
  /// [FirebaseApp].
  ///
  /// Instances are cached and reused for incoming event handlers.
  @override
  FirebasePerformancePlatform delegateFor({required FirebaseApp app}) {
    return _methodChannelFirebasePerformanceInstances.putIfAbsent(
      app.name,
          () => MethodChannelFirebasePerformance(app: app),
    );
  }

  @override
  FirebasePerformancePlatform setInitialValues({
    required Map<dynamic, dynamic> performanceValues,
  }) {
    // TODO(kroikie): set any initial values
    return this;
  }

  // TODO(kroikie): override FirebasePerformancePlatform methods
}
