import 'package:custom_lint_builder/custom_lint_builder.dart';

class ClosableLintConfig {
  final String name;
  final String userFriendlyName;
  final String closableTargetUrl;
  final String closableSourceUrl;

  /// if our closable entity is designed only to close something (like `StreamSubscription`),
  /// then we set `preferedAssignment = false`, which generates code fixes without assignment as we already handle closing
  /// 
  /// Opposite case `TextEditingController` which probably should be assigned to user's variable 
  /// and also closed by autoclose lib
  final bool preferredAssignment;

  ClosableLintConfig({
    required this.name,
    required this.userFriendlyName,
    required this.closableTargetUrl,
    required this.closableSourceUrl,
    this.preferredAssignment = true,
  });

  late final Uri closableSourceLib = Uri.parse(closableSourceUrl);
  late final TypeChecker closableTypeChecker =
      TypeChecker.fromUrl(closableTargetUrl);
}
