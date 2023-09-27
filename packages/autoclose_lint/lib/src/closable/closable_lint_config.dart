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
  late final String name = _camelCaseToSnakeCase(targetClassName);
  late final String userFriendlyName =
      _camelCaseToFriendlyCase(targetClassName);
  late final Uri closableSourceLib = Uri.parse(closableSourceUrl);

  bool sourceLibContainsInPubspec(CustomLintContext context) =>
      context.pubspec.dependencies.keys.contains(closableSourceLib.host);

  late final TypeChecker closableTypeChecker =
      TypeChecker.fromUrl(config.closableTargetUrl);

  String _camelCaseToFriendlyCase(String camelCase) =>
      camelCase.replaceAllMapped(
          RegExp('(?<=[a-z])[A-Z]'), (m) => ' ${m.group(0)}'.toLowerCase());
  String _camelCaseToSnakeCase(String camelCase) => camelCase
      .replaceAllMapped(RegExp('(?<=[a-z])[A-Z]'), (m) => '_${m.group(0)}')
      .toLowerCase();
}
