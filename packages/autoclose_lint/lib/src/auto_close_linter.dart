import 'package:autoclose_lint/src/package_config.dart';
import 'package:autoclose_lint/src/closable/closable_assignment_lint.dart';
import 'package:autoclose_lint/src/closable/closable_expression_lint.dart';
import 'package:autoclose_lint/src/closable/closable_lint_config.dart';
import 'package:autoclose_lint/src/closer/add_closer_mixin_assist.dart';
import 'package:autoclose_lint/src/closer/closer_assist_config.dart';
import 'package:autoclose_lint/src/subclosable/subclosable_call_lint.dart';
import 'package:autoclose_lint/src/subclosable/subclosable_lint_config.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class AutoCloseLinter extends PluginBase {
  final Map<String, PackageConfig> configsWithPackages;

  AutoCloseLinter(this.configsWithPackages);

  List<LintRule> _getClosableLints(ClosableLintPackageConfig config) => [
        ClosableExpressionLint(config),
        ClosableAssignmentLint(config),
      ];

  List<LintRule> _getSubclosableLints(SubclosableLintPackageConfig config) => [
        SubclosableCallLint(config),
      ];

  List<Assist> _getCloserAssists(CloserAssistPackageConfig config) =>
      [AddCloserMixinAssist(config)];

  Iterable<LintRule> _getLintRules(CustomLintConfigs configs) sync* {
    for (final MapEntry(key: package, value: packageConfig)
        in configsWithPackages.entries) {
      for (final config in packageConfig.closables) {
        yield* _getClosableLints(ClosableLintPackageConfig(
          closableSourceUrl: package,
          config: config,
        ));
      }
      for (final config in packageConfig.subClosables) {
        yield* _getSubclosableLints(SubclosableLintPackageConfig(
          closableSourceUrl: package,
          config: config,
        ));
      }
    }
  }

  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) =>
      _getLintRules(configs).toList();

  Iterable<Assist> _getAssistRules() sync* {
    for (final MapEntry(key: package, value: packageConfig)
        in configsWithPackages.entries) {
      for (final config in packageConfig.closers) {
        yield* _getCloserAssists(CloserAssistPackageConfig(
          closerSourceUrl: package,
          config: config,
        ));
      }
    }
  }

  @override
  List<Assist> getAssists() => _getAssistRules().toList();
}
