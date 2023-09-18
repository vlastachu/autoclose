
import 'package:custom_lint_builder/custom_lint_builder.dart';

class LintConfig {
  final String name;
  final String problemMessage;
  final TypeChecker closableTypeChecker;
  final Uri closableSourceLib;

  LintConfig(
      {required this.name,
      required this.problemMessage,
      required this.closableTypeChecker,
      required this.closableSourceLib});
}