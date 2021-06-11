// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of firebase_performance;

/// The Firebase Performance API.
///
/// You can get an instance by calling [FirebasePerformance.instance].
class FirebasePerformance {
  FirebasePerformance._();

  static final FirebasePerformance instance = FirebasePerformance._();

  static late final _delegate = FirebasePerformancePlatform.instance;

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
  Future<void> setPerformanceCollectionEnabled(bool enabled) {
    return _delegate.setPerformanceCollectionEnabled(enabled);
  }

  /// Creates a [Trace] object with given [name].
  ///
  /// The [name] requires no leading or trailing whitespace, no leading
  /// underscore _ character, and max length of [Trace.maxTraceNameLength]
  /// characters.
  Trace newTrace(String name) {
    return Trace(_delegate.newTrace(name));
  }

  /// Creates [HttpMetric] for collecting performance for one request/response.
  HttpMetric newHttpMetric(String url, HttpMethod httpMethod) {
    return HttpMetric(_delegate.newHttpMetric(url, httpMethod));
  }

  /// Creates a [Trace] object with given [name] and starts the trace.
  ///
  /// The [name] requires no leading or trailing whitespace, no leading
  /// underscore _ character, max length of [Trace.maxTraceNameLength]
  /// characters.
  static Future<Trace> startTrace(String name) async {
    return Trace(await _delegate.startTrace(name));
  }
}
