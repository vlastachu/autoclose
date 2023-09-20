import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'closable_lint_config.dart';

class ClosableAssignmentLint extends DartLintRule {
  final ClosableLintConfig config;
  ClosableAssignmentLint(this.config)
      : super(
            code: LintCode(
                name: '${config.name}_assignment_unhandled',
                problemMessage:
                    '${config.userFriendlyName} assignment may be replaced by `.closeWith(this)`'));

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addVariableDeclaration((node) {
      final expressionType = node.initializer?.staticType;
      if (expressionType != null &&
          config.closableTypeChecker.isAssignableFromType(expressionType)) {
        reporter.reportErrorForNode(code, node);
      }
    });
  }

  @override
  List<Fix> getFixes() => [_HandleAssignmentFix(config)];
}

class _HandleAssignmentFix extends DartFix {
  final ClosableLintConfig config;

  _HandleAssignmentFix(this.config);

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
