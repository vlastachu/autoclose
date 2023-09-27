library autoclose_lint;

import 'package:autoclose_lint/src/package_config.dart';
import 'package:autoclose_lint/src/closable/closable_lint_config.dart';
import 'package:autoclose_lint/src/closer/closer_assist_config.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'src/auto_close_linter.dart';

PluginBase createPlugin() => AutoCloseLinter({
      'package:autoclose/autoclose.dart': PackageConfig(closables: [
        ClosableLintConfig(
          closableTargetUrl: 'dart:async#StreamSubscription',
        ),
        ClosableLintConfig(
          closableTargetUrl: 'dart:async#Timer',
        ),
      ], closers: []),
      'package:autoclose_flutter/autoclose_flutter.dart':
          PackageConfig(closables: [
        ClosableLintConfig(
          closableTargetUrl:
              'package:flutter/src/animation/animation_controller.dart#AnimationController',
        ),
        ClosableLintConfig(
          closableTargetUrl:
              'package:flutter/src/painting/decoration.dart#BoxPainter',
        ),
        ClosableLintConfig(
          closableTargetUrl:
              'package:flutter/src/foundation/change_notifier.dart#ChangeNotifier',
        ),
        ClosableLintConfig(
          closableTargetUrl:
              'package:flutter/src/painting/decoration_image.dart#DecorationImagePainter',
        ),
        ClosableLintConfig(
          closableTargetUrl:
              'package:flutter/src/gestures/recognizer.dart#GestureRecognizer',
        ),
        ClosableLintConfig(
          closableTargetUrl:
              'package:flutter/src/material/material.dart#InkFeature',
        ),
        ClosableLintConfig(
          closableTargetUrl:
              'package:flutter/src/foundation/change_notifier.dart#Listenable',
        ),
        ClosableLintConfig(
          closableTargetUrl:
              'package:flutter/src/widgets/scroll_activity.dart#ScrollDragController',
        ),
        ClosableLintConfig(
          closableTargetUrl: 'package:flutter/src/scheduler/ticker.dart#Ticker',
        ),
      ], closers: [
        CloserAssistConfig(
          targetClassUrl: 'package:flutter/src/widgets/framework.dart#State',
          mixinName: 'CloserWidgetState',
        ),
      ]),
      'package:autoclose_bloc/autoclose_bloc.dart': PackageConfig(closables: [
        ClosableLintConfig(
            closableTargetUrl: 'package:bloc/src/bloc.dart#Closable'),
      ], closers: [
        CloserAssistConfig(
            mixinName: 'CloserBloc',
            targetClassUrl: 'package:bloc/src/bloc.dart#BlocBase'),
      ]),
    });
