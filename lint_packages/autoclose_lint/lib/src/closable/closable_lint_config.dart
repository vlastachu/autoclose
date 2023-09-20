import 'package:custom_lint_builder/custom_lint_builder.dart';

class ClosableLintConfig {
  final String name;
  final String userFriendlyName;
  final String closableTargetUrl;
  final String closableSourceUrl;

  ClosableLintConfig(
      {required this.name,
      required this.userFriendlyName,
      required this.closableTargetUrl,
      required this.closableSourceUrl});

  late final Uri closableSourceLib = Uri.parse(closableSourceUrl);
  late final TypeChecker closableTypeChecker =
      TypeChecker.fromUrl(closableTargetUrl);
}
