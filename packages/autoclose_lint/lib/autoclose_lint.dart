import 'package:autoclose_lint/src/package_config.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'src/auto_close_linter.dart';

PluginBase createPlugin() => AutoCloseLinter([
      PackageConfig(
        'package:autoclose/autoclose.dart',
        closableTargetUrls: [
          'dart:async#StreamSubscription',
          'dart:async#Timer',
        ],
      ),
      PackageConfig(
        'package:autoclose_flutter/autoclose_flutter.dart',
        closableTargetUrls: [
          'package:flutter/src/animation/animation_controller.dart#AnimationController',
          'package:flutter/src/painting/decoration.dart#BoxPainter',
          'package:flutter/src/foundation/change_notifier.dart#ChangeNotifier',
          'package:flutter/src/painting/decoration_image.dart#DecorationImagePainter',
          'package:flutter/src/gestures/recognizer.dart#GestureRecognizer',
          'package:flutter/src/material/material.dart#InkFeature',
          'package:flutter/src/widgets/scroll_activity.dart#ScrollDragController',
          'package:flutter/src/scheduler/ticker.dart#Ticker',
        ],
        closers: [
          (
            targetClassUrl: 'package:flutter/src/widgets/framework.dart#State',
            mixinUrl:
                'package:autoclose_flutter/closer/closer_widget_state.dart#CloserWidgetState',
          ),
          (
            targetClassUrl:
                'package:flutter/src/foundation/change_notifier.dart#ChangeNotifier',
            mixinUrl:
                'package:autoclose_flutter/closer/closer_change_notifier.dart#CloserChangeNotifier',
          ),
        ],
        subClosables: [
          (
            closableTargetUrl:
                'package:flutter/src/foundation/change_notifier.dart#Listenable',
            methodName: 'addListener'
          ),
          (
            closableTargetUrl:
                'package:flutter/src/widgets/binding.dart#WidgetsBinding',
            methodName: 'addObserver'
          ),
        ],
      ),
      PackageConfig(
        'package:autoclose_bloc/autoclose_bloc.dart',
        closableTargetUrls: ['package:bloc/src/bloc.dart#Closable'],
        closers: [
          (
            mixinUrl:
                'package:autoclose_bloc/closer/closer_bloc.dart#CloserBloc',
            targetClassUrl: 'package:bloc/src/bloc.dart#BlocBase'
          ),
        ],
      ),
    ]);
