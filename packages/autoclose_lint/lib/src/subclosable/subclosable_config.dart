import 'package:autoclose_lint/src/has_package.dart';
import 'package:autoclose_lint/src/utils.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class SubclosableConfig extends HasPackage {
  final String closableTargetUrl;
  final String methodName;

  SubclosableConfig(
    super.sourcePackage, {
    required this.closableTargetUrl,
    required this.methodName,
  });

  late final targetClassName = closableTargetUrl.split('#')[1];
  late final String name = camelCaseToSnakeCase(targetClassName);
  late final String methodSnakeCase = camelCaseToSnakeCase(methodName);
  late final String userFriendlyName = camelCaseToFriendlyCase(targetClassName);

  late final TypeChecker closableTypeChecker =
      TypeChecker.fromUrl(closableTargetUrl);
}
