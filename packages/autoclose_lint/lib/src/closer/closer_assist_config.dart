import 'package:custom_lint_builder/custom_lint_builder.dart';

class CloserAssistConfig {
  final String mixinName;
  final String targetClassUrl;

  CloserAssistConfig({
    required this.mixinName,
    required this.targetClassUrl,
  });
}

class CloserAssistPackageConfig {
  final String closerSourceUrl;
  final CloserAssistConfig config;

  CloserAssistPackageConfig({
    required this.closerSourceUrl,
    required this.config,
  });

  String get mixinName => config.mixinName;
  late final closerMixinTypeChecker =
      TypeChecker.fromUrl('$closerSourceLib#${config.mixinName}');
  get assistMessage => 'Add corresponding Closer mixin';

  late final Uri closerSourceLib = Uri.parse(closerSourceUrl);
  bool sourceLibContainsInPubspec(CustomLintContext context) =>
      context.pubspec.dependencies.keys
          .contains(closerSourceLib.pathSegments[0]);
  late final TypeChecker targetClassTypeChecker =
      TypeChecker.fromUrl(config.targetClassUrl);
}
