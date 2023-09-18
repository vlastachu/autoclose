import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'closable_lint_config.dart';


class ClosableAssignmentLint extends DartLintRule {
  final LintConfig config;
  ClosableAssignmentLint(this.config)
      : super(
            code: LintCode(
                name: config.name, problemMessage: config.problemMessage));

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addExpressionStatement((node) {
      final expressionType = node.expression.staticType;
      if (expressionType != null &&
          config.closableTypeChecker.isAssignableFromType(expressionType)) {
        reporter.reportErrorForNode(code, node);
      }
    });
  }

  @override
  List<Fix> getFixes() => [_HandleStreamSubscriptionFix()];
}

class _HandleStreamSubscriptionFix extends DartFix {
  final LintConfig config;

  _HandleStreamSubscriptionFix(this.config);

  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    context.registry.addExpressionStatement((node) {
      if (!analysisError.sourceRange.intersects(node.sourceRange)) return;

      final changeBuilder = reporter.createChangeBuilder(
        message: 'append `.closeWith(this)`',
        priority: 80,
      );

      changeBuilder.addDartFileEdit((builder) {
        if (!builder.importsLibrary(config.closableSourceLib)) {
          builder.importLibrary(config.closableSourceLib);
        }
        builder.addSimpleInsertion(node.expression.end, '.closeWith(this)');
      });
    });
  }
}
