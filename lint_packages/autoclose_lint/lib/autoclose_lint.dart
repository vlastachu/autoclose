library autoclose_lint;

import 'package:autoclose_lint/src/closable/closable_assignment_lint.dart';
import 'package:autoclose_lint/src/closable/closable_expression_lint.dart';
import 'package:autoclose_lint/src/closable/closable_lint_config.dart';
import 'package:autoclose_lint/src/closer/add_closer_mixin_assist.dart';
import 'package:autoclose_lint/src/closer/closer_assist_config.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

PluginBase createPlugin() => AutoCloseLinter();

final streamClosableConfig = ClosableLintConfig(
  closableSourceUrl: 'package:autoclose_flutter/autoclose_flutter.dart',
  name: 'stream_subscription',
  userFriendlyName: 'Stream subscription',
  closableTargetUrl: 'dart:async#StreamSubscription',
);

final blocCloserConfig = CloserAssistConfig(
  closerSourceUrl: 'package:autoclose_flutter/autoclose_flutter.dart',
  targetClassUrl: 'package:flutter/src/widgets/framework.dart#State',
  mixinName: 'CloserWidgetState',
);

List<LintRule> getClosableLints(ClosableLintConfig config) => [
      ClosableExpressionLint(config),
      ClosableAssignmentLint(config),
    ];

class AutoCloseLinter extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [
        streamClosableConfig,
      ].expand(getClosableLints).toList();

  @override
  List<Assist> getAssists() => [
        AddCloserMixinAssist(config: blocCloserConfig),
      ];
}
