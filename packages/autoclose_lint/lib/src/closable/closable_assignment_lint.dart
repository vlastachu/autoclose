import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:autoclose_lint/src/closer/closers_handler.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'closable_config.dart';

/// Checks whether user already invokes `closeWith` call in method cascade
bool containsCloseInMethodCascade(Expression expression) {
  // for example we have such expression:
  // stream.listen((event) {})..some()..closeWith(this)
  // expression.childEntities will contain:
  // [0] stream.listen((event) {}) // skip this child as it may contain inner closable expressions
  // [1] ..some()
  // [2] ..closeWith(this)
  final cascadeChilds = expression.childEntities.skip(1);
  return cascadeChilds.any(
    (element) =>
        element is MethodInvocation &&
        element.isCascaded &&
        element.methodName.name == 'closeWith',
  );
}

abstract class AssignmentExpressionLookup<SourceElement extends AstNode> {
  Expression? getExpressionElement(SourceElement sourceElement);

  void addSourceElementListener(
    LintRuleNodeRegistry registry,
    void Function(SourceElement node) listener,
  );

  void useBuilderAfterFixes(DartFileEditBuilder builder, SourceElement node) {}
}

abstract class ClosableAssignmentLint<SourceElement extends AstNode>
    extends DartLintRule {
  final ClosableConfig config;
  final ClosersHandler closersHandler;
  final AssignmentExpressionLookup<SourceElement> lookup;
  ClosableAssignmentLint(
    this.config,
    this.closersHandler,
    this.lookup,
    String name,
  ) : super(
          code: LintCode(
            name: '${config.name}_${name}_unclosed',
            problemMessage:
                '${config.userFriendlyName} assignment should be closed by `..closeWith(this)`',
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
    lookup.addSourceElementListener(context.registry, (node) {
      final expression = lookup.getExpressionElement(node);
      if (expression == null) return;
      final expressionType = expression.staticType;
      if (expressionType != null &&
          config.closableTypeChecker.isAssignableFromType(expressionType) &&
          !containsCloseInMethodCascade(expression)) {
        reporter.reportErrorForNode(code, node);
      }
    });
  }

  @override
  List<Fix> getFixes() => [
        _AddCascadeCallAssignmentFix(config, closersHandler, lookup),
        _ReplaceAssignmentFix(config, closersHandler, lookup),
      ];
}

class _AddCascadeCallAssignmentFix<SourceElement extends AstNode>
    extends DartFix {
  final ClosableConfig config;
  final ClosersHandler closersHandler;
  final AssignmentExpressionLookup<SourceElement> lookup;

  _AddCascadeCallAssignmentFix(this.config, this.closersHandler, this.lookup);

  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    lookup.addSourceElementListener(context.registry, (node) {
      if (!analysisError.sourceRange.intersects(node.sourceRange)) return;

      final changeBuilder = reporter.createChangeBuilder(
        message: 'add `..closeWith(this)`',
        priority: 81,
      );

      changeBuilder.addDartFileEdit((builder) {
        config.tryImportSelfPackage(builder);
        builder.addSimpleInsertion(node.end, '..closeWith(this)');
        closersHandler.addCloserMixin(
          node.thisOrAncestorOfType<ClassDeclaration>(),
          builder,
        );
        lookup.useBuilderAfterFixes(builder, node);
      });
    });
  }
}

class _ReplaceAssignmentFix<SourceElement extends AstNode> extends DartFix {
  final ClosableConfig config;
  final ClosersHandler closersHandler;
  final AssignmentExpressionLookup<SourceElement> lookup;

  _ReplaceAssignmentFix(this.config, this.closersHandler, this.lookup);

  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    lookup.addSourceElementListener(context.registry, (node) {
      if (!analysisError.sourceRange.intersects(node.sourceRange)) return;
      final expression = lookup.getExpressionElement(node);
      if (expression == null) return;

      final changeBuilder = reporter.createChangeBuilder(
        message: 'replace with `.closeWith(this)`',
        priority: 80,
      );

      changeBuilder.addDartFileEdit((builder) {
        config.tryImportSelfPackage(builder);
        builder.addSimpleInsertion(node.end, '.closeWith(this)');
        builder.addDeletion(
          SourceRange(node.offset, expression.offset - node.offset),
        );

        closersHandler.addCloserMixin(
          node.thisOrAncestorOfType<ClassDeclaration>(),
          builder,
        );
        lookup.useBuilderAfterFixes(builder, node);
      });
    });
  }
}
