import 'package:autoclose_lint/src/closable/closable_assignment_expression_lint.dart';
import 'package:autoclose_lint/src/closable/closable_expression_lint.dart';
import 'package:autoclose_lint/src/closable/closable_variable_declaration_lint.dart';
import 'package:autoclose_lint/src/closable/closable_variable_declaration_list_lint.dart';
import 'package:autoclose_lint/src/closer/closers_handler.dart';
import 'package:autoclose_lint/src/package_config.dart';
import 'package:autoclose_lint/src/subclosable/subclosable_call_lint.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class AutoCloseLinter extends PluginBase {
  final List<PackageConfig> configs;

  AutoCloseLinter(this.configs);

  late final ClosersHandler closersHandler = ClosersHandler(
    closerConfigs: configs.expand((config) => config.closerConfigs).toList(),
  );

  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => this
      .configs
      .expand(
        (config) => [
          ...config.closableConfigs.expand(
            (closableConfig) => [
              ClosableExpressionLint(closableConfig, closersHandler),
              ClosableAssignmentExpressionLint(closableConfig, closersHandler),
              // ClosableVariableDeclarationLint(closableConfig, closersHandler),
              ClosableVariableDeclarationListLint(
                closableConfig,
                closersHandler,
              ),
            ],
          ),
          ...config.subClosableConfigs.map(
            (subClosableConfig) =>
                SubclosableCallLint(subClosableConfig, closersHandler),
          ),
        ],
      )
      .toList();

  @override
  List<Assist> getAssists() => [];
}
