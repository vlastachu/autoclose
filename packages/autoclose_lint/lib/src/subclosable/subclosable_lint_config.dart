import 'package:autoclose_lint/src/utils.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class SubclosableLintConfig {
  final String closableTargetUrl;
  final String methodName;

  SubclosableLintConfig({
    required this.closableTargetUrl,
    required this.methodName,
  });
}

class SubclosableLintPackageConfig {
  final String closableSourceUrl;
  final SubclosableLintConfig config;

  SubclosableLintPackageConfig({
    required this.closableSourceUrl,
    required this.config,
  });

  String get methodName => config.methodName;
  late final targetClassName = config.closableTargetUrl.split('#')[1];
  late final String name = camelCaseToSnakeCase(targetClassName);
  late final String methodSnakeCase = camelCaseToSnakeCase(methodName);
  late final String userFriendlyName = camelCaseToFriendlyCase(targetClassName);
  late final Uri closableSourceLib = Uri.parse(closableSourceUrl);

  bool sourceLibContainsInPubspec(CustomLintContext context) =>
      context.pubspec.dependencies.keys.contains(closableSourceLib.pathSegments[0]);

  late final TypeChecker closableTypeChecker =
      TypeChecker.fromUrl(config.closableTargetUrl);
}
