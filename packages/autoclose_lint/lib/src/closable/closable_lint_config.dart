import 'package:autoclose_lint/src/utils.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class ClosableLintConfig {
  final String closableTargetUrl;

  ClosableLintConfig({
    required this.closableTargetUrl,
  });
}

class ClosableLintPackageConfig {
  final String closableSourceUrl;
  final ClosableLintConfig config;

  ClosableLintPackageConfig({
    required this.closableSourceUrl,
    required this.config,
  });

  late final targetClassName = config.closableTargetUrl.split('#')[1];
  late final String name = camelCaseToSnakeCase(targetClassName);
  late final String userFriendlyName = camelCaseToFriendlyCase(targetClassName);
  late final Uri closableSourceLib = Uri.parse(closableSourceUrl);

  bool sourceLibContainsInPubspec(CustomLintContext context) =>
      context.pubspec.dependencies.keys
          .contains(closableSourceLib.pathSegments[0]);

  late final TypeChecker closableTypeChecker =
      TypeChecker.fromUrl(config.closableTargetUrl);
}
