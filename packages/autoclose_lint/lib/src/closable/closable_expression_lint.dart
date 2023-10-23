import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:autoclose_lint/src/closer/closers_handler.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'closable_config.dart';

class ClosableExpressionLint extends DartLintRule {
  final ClosableConfig config;
  final ClosersHandler closersHandler;
  ClosableExpressionLint(this.config, this.closersHandler)
      : super(
          code: LintCode(
            name: '${config.name}_expression_unclosed',
            problemMessage: '${config.userFriendlyName} should be closed by `.closeWith(this)`',
          ),
        );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    if (!config.sourceLibContainsInPubspec(context)) {
      return;
    }
    context.registry.addExpressionStatement((node) {
      // will be handled by other lint
      if (node.expression is AssignmentExpression) return; 
      final expressionType = node.expression.staticType;
      if (expressionType != null &&
          config.closableTypeChecker.isAssignableFromType(expressionType)) {
        reporter.reportErrorForNode(code, node);
      }
    });
  }

  @override
  List<Fix> getFixes() => [_HandleExpressionFix(config, closersHandler)];
}

class _HandleExpressionFix extends DartFix {
  final ClosableConfig config;
  final ClosersHandler closersHandler;

  _HandleExpressionFix(this.config, this.closersHandler);

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
        config.tryImportSelfPackage(builder);

        builder.addSimpleInsertion(node.expression.end, '.closeWith(this)');
        closersHandler.addCloserMixin(
          node.thisOrAncestorOfType<ClassDeclaration>(),
          builder,
        );
      });
    });
  }
}
