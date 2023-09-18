library autoclose_lint;

import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';


PluginBase createPlugin() => AutoCloseLinter();

class AutoCloseLinter extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [
        ClosableStreamExpressionLint(),
        ClosableStreamAssignmentLint(),
      ];

  @override
  List<Assist> getAssists() => [_Assist()];
}

class _Assist extends DartAssist {
  @override
  void run(CustomLintResolver resolver, ChangeReporter reporter,
      CustomLintContext context, SourceRange target) {
    context.registry.addClassDeclaration((node) {
      // Check that the visited node is under the cursor
      if (!target.intersects(node.sourceRange)) return;
      final extendsClause = node.extendsClause;
      final superClassElement = extendsClause?.superclass.element;
      // final stateChecker = TypeChecker.fromUrl('package:flutter/src/widgets/framework.dart#State');
      const stateChecker = TypeChecker.fromName('State');
      const closerChecker = TypeChecker.fromName('CloserWidgetState');
      if (extendsClause == null ||
          superClassElement == null ||
          !stateChecker.isAssignableFrom(superClassElement)) return;
      final withClause = node.withClause;
      if (withClause != null &&
          withClause.mixinTypes
              .map((e) => e.element)
              .nonNulls
              .where((element) => closerChecker.isAssignableFrom(element))
              .isNotEmpty) return;
      final changeBuilder = reporter.createChangeBuilder(
        priority: 80,
        message: 'Add corresponding Closer mixin',
      );
      changeBuilder.addDartFileEdit((builder) {
        final lib =
            Uri.parse('package:autoclose_flutter/autoclose_flutter.dart');
        if (!builder.importsLibrary(lib)) {
          builder.importLibrary(lib);
        }
        if (withClause != null) {
          builder.addSimpleInsertion(withClause.end, ', CloserWidgetState');
        } else {
          builder.addSimpleInsertion(
              extendsClause.end, ' with CloserWidgetState');
        }
      });
    });
  }
}

class ClosableStreamExpressionLint extends DartLintRule {
  ClosableStreamExpressionLint() : super(code: _code);

  static const _code = LintCode(
    name: 'stream_subscription_expression_unhandled',
    problemMessage: 'Stream subscription should be handled',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addExpressionStatement((node) {
      const subscriptionChecker = TypeChecker.fromUrl('dart:async#StreamSubscription');
      final expressionType = node.expression.staticType;
      if (expressionType != null &&
          subscriptionChecker.isAssignableFromType(expressionType)) {
        reporter.reportErrorForNode(code, node);
      }
    });
  }

  @override
  List<Fix> getFixes() => [_HandleStreamSubscriptionFix()];
}

class ClosableStreamAssignmentLint extends DartLintRule {
  ClosableStreamAssignmentLint() : super(code: _code);

  static const _code = LintCode(
    name: 'stream_subscription_assignment_unhandled',
    problemMessage:
        'Stream subscription assignment may be replaced by `.closeWith(this)`',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addVariableDeclaration((node) {
      const subscriptionChecker = TypeChecker.fromName('StreamSubscription');
      final expressionType = node.initializer?.staticType;
      if (expressionType != null &&
          subscriptionChecker.isAssignableFromType(expressionType) &&
          expressionType.element?.library?.identifier == 'dart:async') {
        reporter.reportErrorForNode(code, node);
      }
    });
  }

  @override
  List<Fix> getFixes() => [_HandleStreamSubscriptionAssignmentFix()];
}

class _HandleStreamSubscriptionAssignmentFix extends DartFix {
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
        final lib = Uri.parse('package:autoclose/autoclose.dart');
        if (!builder.importsLibrary(lib)) {
          builder.importLibrary(lib);
        }

        if (node.variables.length != 1) {
          const subscriptionChecker =
              TypeChecker.fromName('StreamSubscription');
          bool checkType(DartType? type) =>
              type != null &&
              subscriptionChecker.isAssignableFromType(type) &&
              type.element?.library?.identifier == 'dart:async';
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

class _HandleStreamSubscriptionFix extends DartFix {
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
        final lib = Uri.parse('package:autoclose/autoclose.dart');
        if (!builder.importsLibrary(lib)) {
          builder.importLibrary(lib);
        }
        builder.addSimpleInsertion(node.expression.end, '.closeWith(this)');
      });
    });
  }
}
