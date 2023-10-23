import 'package:analyzer/dart/ast/ast.dart';
import 'package:autoclose_lint/src/closable/closable_assignment_lint.dart';
import 'package:autoclose_lint/src/closable/closable_config.dart';
import 'package:autoclose_lint/src/closer/closers_handler.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class _AssignmentExpressionLookup
    extends AssignmentExpressionLookup<AssignmentExpression> {
  @override
  void addSourceElementListener(
    LintRuleNodeRegistry registry,
    void Function(AssignmentExpression node) listener,
  ) =>
      registry.addAssignmentExpression(listener);

  @override
  Expression? getExpressionElement(AssignmentExpression sourceElement) =>
      sourceElement.rightHandSide;
}

class ClosableAssignmentExpressionLint
    extends ClosableAssignmentLint<AssignmentExpression> {
  ClosableAssignmentExpressionLint(
    ClosableConfig config,
    ClosersHandler closersHandler,
  ) : super(
          config,
          closersHandler,
          _AssignmentExpressionLookup(),
          'assignment_expression',
        );
}
