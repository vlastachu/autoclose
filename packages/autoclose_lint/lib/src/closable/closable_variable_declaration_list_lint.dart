import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:autoclose_lint/src/closable/closable_assignment_lint.dart';
import 'package:autoclose_lint/src/closable/closable_config.dart';
import 'package:autoclose_lint/src/closer/closers_handler.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

bool Function(Expression?) _checkExpression(ClosableConfig config) =>
    (Expression? expression) {
      if (expression == null) return false;
      final type = expression.staticType;
      if (type == null) return false;
      return config.closableTypeChecker.isAssignableFromType(type) &&
          !containsCloseInMethodCascade(expression);
    };

class ClosableVariableDeclarationListLint extends DartLintRule {
  final ClosableConfig config;
  final ClosersHandler closersHandler;
  ClosableVariableDeclarationListLint(
    this.config,
    this.closersHandler,
  ) : super(
          code: LintCode(
            name: '${config.name}_variable_declaration_list_unclosed',
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
    context.registry.addVariableDeclarationList((node) {
      final expression = node.variables
          .map((e) => e.initializer)
          .firstWhere(_checkExpression(config), orElse: () => null);
      if (expression != null) {
        reporter.reportErrorForNode(code, node);
      }
    });
  }

  @override
  List<Fix> getFixes() => [
        _AddCascadeCallAssignmentFix(config, closersHandler),
        _ReplaceAssignmentFix(config, closersHandler),
      ];
}

class _AddCascadeCallAssignmentFix extends DartFix {
  final ClosableConfig config;
  final ClosersHandler closersHandler;

  _AddCascadeCallAssignmentFix(this.config, this.closersHandler);

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
        message: 'add `..closeWith(this)`',
        priority: 81,
      );

      changeBuilder.addDartFileEdit((builder) {
        config.tryImportSelfPackage(builder);
        closersHandler.addCloserMixin(
          node.thisOrAncestorOfType<ClassDeclaration>(),
          builder,
        );

        final initializers = node.variables
            .map((e) => e.initializer)
            .where(_checkExpression(config))
            .nonNulls;
        for (final initializer in initializers) {
          builder.addSimpleInsertion(initializer.end, '..closeWith(this)');
        }
      });
    });
  }
}

class _ReplaceAssignmentFix extends DartFix {
  final ClosableConfig config;
  final ClosersHandler closersHandler;

  _ReplaceAssignmentFix(this.config, this.closersHandler);

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
        config.tryImportSelfPackage(builder);
        closersHandler.addCloserMixin(
          node.thisOrAncestorOfType<ClassDeclaration>(),
          builder,
        );

        builder.addReplacement(SourceRange(node.offset, node.length),
            (builder) {
          for (final variable in node.variables) {
            final initializer = variable.initializer?.toSource();
            if (_checkExpression(config)(variable.initializer)) {
              final divider = node.variables.length > 1 ? ';\n' : '';
              builder.write('${initializer!}.closeWith(this)$divider');
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
              builder.write('\n');
            }
          }
        });
      });
    });
  }
}
