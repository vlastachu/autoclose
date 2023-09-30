import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'closable_lint_config.dart';

class ClosableAssignmentLint extends DartLintRule {
  final ClosableLintPackageConfig config;
  ClosableAssignmentLint(this.config)
      : super(
            code: LintCode(
                name: '${config.name}_assignment_unhandled',
                problemMessage:
                    '${config.userFriendlyName} assignment should be handled by `..closeWith(this)`'));

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    if (!config.sourceLibContainsInPubspec(context)) {
      return;
    }
    context.registry.addVariableDeclaration((node) {
      final expressionType = node.initializer?.staticType;
      if (expressionType != null &&
          config.closableTypeChecker.isAssignableFromType(expressionType) &&
          !containsCloseInMethodCascade(node.initializer!)) {
        reporter.reportErrorForNode(code, node);
      }
    });
  }

  /// Checks whether user already invokes `closeWith` call in method cascade
  bool containsCloseInMethodCascade(Expression expression) {
    // for example we have such expression:
    // stream.listen((event) {})..some()..closeWith(this)
    // expression.childEntities will contain:
    // [0] stream.listen((event) {}) // skip this child as it may contain inner closable expressions
    // [1] ..some()
    // [2] ..closeWith(this)
    final cascadeChilds = expression.childEntities.skip(1);
    return cascadeChilds.any((element) =>
        element is MethodInvocation &&
        element.isCascaded &&
        element.methodName.name == 'closeWith');
  }

  @override
  List<Fix> getFixes() => [
        _AddCascadeCallAssignmentFix(config),
        _ReplaceAssignmentFix(config),
      ];
}

class _AddCascadeCallAssignmentFix extends DartFix {
  final ClosableLintPackageConfig config;

  _AddCascadeCallAssignmentFix(this.config);

  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    context.registry.addVariableDeclaration((node) {
      if (!analysisError.sourceRange.intersects(node.sourceRange)) return;

      final changeBuilder = reporter.createChangeBuilder(
        message: 'add `..closeWith(this)`',
        priority: 81,
      );

      changeBuilder.addDartFileEdit((builder) {
        if (!builder.importsLibrary(config.closableSourceLib)) {
          builder.importLibrary(config.closableSourceLib);
        }
        builder.addSimpleInsertion(node.end, '..closeWith(this)');
      });
    });
  }
}

class _ReplaceAssignmentFix extends DartFix {
  final ClosableLintPackageConfig config;

  _ReplaceAssignmentFix(this.config);

  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    context.registry.addVariableDeclarationList((node) {
      if (!analysisError.sourceRange.intersects(node.sourceRange)) return;

      final changeBuilder = reporter.createChangeBuilder(
        message: 'replace with `.closeWith(this)`',
        priority: 80,
      );

      changeBuilder.addDartFileEdit((builder) {
        if (!builder.importsLibrary(config.closableSourceLib)) {
          builder.importLibrary(config.closableSourceLib);
        }

        if (node.variables.length != 1) {
          bool checkType(DartType? type) =>
              type != null &&
              config.closableTypeChecker.isAssignableFromType(type);
          builder.addReplacement(SourceRange(node.offset, node.length),
              (builder) {
            for (final variable in node.variables) {
              String? initializer = variable.initializer?.toSource();
              if (checkType(variable.initializer?.staticType)) {
                builder.write('${initializer!}.closeWith(this);');
              } else {
                builder.writeLocalVariableDeclaration(
                  variable.name.lexeme,
                  isConst: node.isConst,
                  isFinal: node.isFinal,
                  type: node.type?.type,
                  initializerWriter: initializer == null
                      ? null
                      : () => builder.write(initializer),
                );
              }
              builder.write('\n');
            }
          });
        } else {
          final initializer = node.variables[0].initializer;
          if (initializer == null) return;

          builder.addSimpleInsertion(initializer.end, '.closeWith(this)');
          builder.addDeletion(
              SourceRange(node.offset, initializer.offset - node.offset));
        }
      });
    });
  }
}