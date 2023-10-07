import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:autoclose_lint/src/subclosable/subclosable_lint_config.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class SubclosableCallLint extends DartLintRule {
  final SubclosableLintPackageConfig config;
  SubclosableCallLint(this.config)
      : super(
            code: LintCode(
                name: '${config.name}_${config.methodSnakeCase}_unhandled',
                problemMessage:
                    '${config.methodName} should be replaced with ${config.methodName}WithCloser'));

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    if (!config.sourceLibContainsInPubspec(context)) {
      return;
    }
    context.registry.addMethodInvocation((MethodInvocation node) {
      // node.realTarget is equals null if method implicytly call this.
      // but thats not my case
      final expressionType = node.realTarget?.staticType;
      if (expressionType != null &&
          config.closableTypeChecker.isAssignableFromType(expressionType) &&
          node.methodName.name == config.methodName) {
        reporter.reportErrorForNode(code, node);
      }
    });
  }

  @override
  List<Fix> getFixes() => [_ReplaceWithSafeCall(config)];
}

class _ReplaceWithSafeCall extends DartFix {
  final SubclosableLintPackageConfig config;

  _ReplaceWithSafeCall(this.config);

  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    context.registry.addMethodInvocation((MethodInvocation node) {
      if (!analysisError.sourceRange.intersects(node.sourceRange)) return;

      final changeBuilder = reporter.createChangeBuilder(
        message: 'replace with ${config.methodName}WithCloser',
        priority: 80,
      );

      changeBuilder.addDartFileEdit((builder) {
        if (!builder.importsLibrary(config.closableSourceLib)) {
          builder.importLibrary(config.closableSourceLib);
        }
        builder.addSimpleReplacement(
            SourceRange(
                node.methodName.end,
                node.argumentList.leftParenthesis.offset +
                    1 -
                    node.methodName.end),
            'WithCloser(this, ');
      });
    });
  }
}
