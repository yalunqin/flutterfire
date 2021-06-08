// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// @dart=2.9

import 'dart:async';

import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:pedantic/pedantic.dart';

import 'package:firebase_performance/firebase_performance.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MetricHttpClient extends BaseClient {
  _MetricHttpClient(this._inner);

  final Client _inner;

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    final HttpMetric metric = FirebasePerformance.instance
        .newHttpMetric(request.url.toString(), HttpMethod.Get);

    await metric.start();

    StreamedResponse response;
    try {
      response = await _inner.send(request);
      metric
        ..responsePayloadSize = response.contentLength
        ..responseContentType = response.headers['Content-Type']
        ..requestPayloadSize = request.contentLength
        ..httpResponseCode = response.statusCode;
    } finally {
      await metric.stop();
    }

    return response;
  }
}

class _MyAppState extends State<MyApp> {
  FirebasePerformance _performance = FirebasePerformance.instance;
  bool _isPerformanceCollectionEnabled = false;
  String _performanceCollectionMessage =
      'Unknown status of performance collection.';
  bool _traceHasRan = false;
  bool _httpMetricHasRan = false;

  Future<Response> facebookResponse;

  @override
  void initState() {
    super.initState();
    _togglePerformanceCollection();

    facebookResponse = getFacebookResponse();
  }

  Future<Response> getFacebookResponse() async {
    print('Begin calling facebook');
    Response response = await get(Uri.parse('https://www.facebook.com'));
    print('Done calling facebook!');
    return response;
  }

  Future<void> _togglePerformanceCollection() async {
    await _performance
        .setPerformanceCollectionEnabled(!_isPerformanceCollectionEnabled);

    final bool isEnabled = await _performance.isPerformanceCollectionEnabled();
    setState(() {
      _isPerformanceCollectionEnabled = isEnabled;
      _performanceCollectionMessage = _isPerformanceCollectionEnabled
          ? 'Performance collection is enabled.'
          : 'Performance collection is disabled.';
    });
  }

  Future<void> _testTrace() async {
    setState(() {
      _traceHasRan = false;
    });

    final Trace trace = _performance.newTrace('test');
    unawaited(trace.incrementMetric('metric1', 16));
    unawaited(trace.putAttribute('favorite_color', 'blue'));

    await trace.start();

    int sum = 0;
    for (int i = 0; i < 10000000; i++) {
      sum += i;
    }
    print(sum);

    await trace.stop();

    setState(() {
      _traceHasRan = true;
    });
  }

  Future<void> _testHttpMetric() async {
    setState(() {
      _httpMetricHasRan = false;
    });

    final _MetricHttpClient metricHttpClient = _MetricHttpClient(Client());

    final Request request = Request(
      'SEND',
      Uri.parse('https://www.google.com'),
    );

    unawaited(metricHttpClient.send(request));

    setState(() {
      _httpMetricHasRan = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(color: Colors.lightGreenAccent, fontSize: 25);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Firebase Performance Example'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Text(_performanceCollectionMessage),
              ElevatedButton(
                onPressed: _togglePerformanceCollection,
                child: const Text('Toggle Data Collection'),
              ),
              ElevatedButton(
                onPressed: _testTrace,
                child: const Text('Run Trace'),
              ),
              Text(
                _traceHasRan ? 'Trace Ran!' : '',
                style: textStyle,
              ),
              ElevatedButton(
                onPressed: _testHttpMetric,
                child: const Text('Run HttpMetric'),
              ),
              Text(
                _httpMetricHasRan ? 'HttpMetric Ran!' : '',
                style: textStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
