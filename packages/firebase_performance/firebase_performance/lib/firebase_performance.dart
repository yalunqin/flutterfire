// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

library firebase_performance;

import 'dart:async';

import 'package:firebase_performance_platform_interface/firebase_performance_platform_interface.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart'
    show FirebasePluginPlatform;
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

part 'src/firebase_performance.dart';
part 'src/http_metric.dart';
part 'src/performance_attributes.dart';
part 'src/trace.dart';
