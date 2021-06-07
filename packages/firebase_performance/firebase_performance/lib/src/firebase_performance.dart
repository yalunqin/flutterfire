// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of firebase_performance;

/// Valid HttpMethods for manual network APIs.
// ignore: constant_identifier_names
enum HttpMethod { Connect, Delete, Get, Head, Options, Patch, Post, Put, Trace }

/// The Firebase Performance API.
///
/// You can get an instance by calling [FirebasePerformance.instance].
class FirebasePerformance extend FirebasePluginPlatform {
  static Map<String, FirebasePerformance> _firebasePerformanceInstances = {};

  FirebasePerformancePlatform? _delegatePackingProperty;

  FirebasePerformancePlatform get _delegate {
    _delegatePackingProperty ??= FirebasePerformancePlatform.instanceFor(
      app: app,
      pluginConstants: pluginConstants,
    );
    return _delegatePackingProperty!;
  }

  FirebaseApp app;

  FirebasePerformance._({required this.app}): super(app.name, 'plugins.flutter.io/firebase_performance');

  static FirebasePerformance get instance {
    return _firebasePerformanceInstance.putIfAbsent(app.name, () {
      return FirebasePerformance._(app: app);
    });
  }

  /// Determines whether performance monitoring is enabled or disabled.
  ///
  /// True if performance monitoring is enabled and false if performance
  /// monitoring is disabled. This is for dynamic enable/disable state. This
  /// does not reflect whether instrumentation is enabled/disabled.
  Future<bool> isPerformanceCollectionEnabled() async {
    return _delegate.isPerformanceCollectionEnabled();
  }

  /// Enables or disables performance monitoring.
  ///
  /// This setting is persisted and applied on future invocations of your
  /// application. By default, performance monitoring is enabled.
  Future<void> setPerformanceCollectionEnabled(bool enable) async {
    await _delegate.setPerformanceCollectionEnabled(enabled);
  }

  /// Creates a [Trace] object with given [name].
  ///
  /// The [name] requires no leading or trailing whitespace, no leading
  /// underscore _ character, and max length of [Trace.maxTraceNameLength]
  /// characters.
  Trace newTrace(String name) {
    return _delegate.newTrace(name);
  }

  /// Creates [HttpMetric] for collecting performance for one request/response.
  HttpMetric newHttpMetric(String url, HttpMethod httpMethod) {
    return _delegate.newHttpMetric(url, httpMethod);
  }

  /// Creates a [Trace] object with given [name] and starts the trace.
  ///
  /// The [name] requires no leading or trailing whitespace, no leading
  /// underscore _ character, max length of [Trace.maxTraceNameLength]
  /// characters.
  static Future<Trace> startTrace(String name) async {
    return _delegate.startTrace(name);
  }
}
