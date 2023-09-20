import 'package:custom_lint_builder/custom_lint_builder.dart';

class CloserAssistConfig {
  final String targetClassUrl;
  final String closerSourceUrl;
  final String mixinName;

  CloserAssistConfig(
      {required this.closerSourceUrl,
      required this.mixinName,
      required this.targetClassUrl});

  late final closerMixinTypeChecker =
      TypeChecker.fromUrl('$closerSourceLib#$mixinName');
  get assistMessage => 'Add corresponding Closer mixin';

  late final Uri closerSourceLib = Uri.parse(closerSourceUrl);
  late final TypeChecker targetClassTypeChecker =
      TypeChecker.fromUrl(targetClassUrl);
}
