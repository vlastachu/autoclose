import 'package:analyzer/dart/ast/ast.dart';
import 'package:autoclose_lint/src/closable/closable_assignment_lint.dart';
import 'package:autoclose_lint/src/closable/closable_config.dart';
import 'package:autoclose_lint/src/closer/closers_handler.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class _VariableDeclarationLookup
    extends AssignmentExpressionLookup<VariableDeclaration> {
  @override
  void addSourceElementListener(
    LintRuleNodeRegistry registry,
    void Function(VariableDeclaration node) listener,
  ) =>
      registry.addVariableDeclaration(listener);

  @override
  Expression? getExpressionElement(VariableDeclaration sourceElement) =>
      sourceElement.initializer;
}

class ClosableVariableDeclarationLint
    extends ClosableAssignmentLint<VariableDeclaration> {
  ClosableVariableDeclarationLint(
    ClosableConfig config,
    ClosersHandler closersHandler,
  ) : super(
          config,
          closersHandler,
          _VariableDeclarationLookup(),
          'variable_declaration',
        );
}
