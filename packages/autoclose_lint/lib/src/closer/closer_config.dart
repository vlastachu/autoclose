import 'package:autoclose_lint/src/has_package.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class CloserConfig extends HasPackage {
  final String targetClassUrl;
  final String mixinUrl;

  CloserConfig(
    super.sourcePackage, {
    required this.mixinUrl,
    required this.targetClassUrl,
  });

  late final closerMixinTypeChecker = TypeChecker.fromUrl(mixinUrl);

  late final TypeChecker targetClassTypeChecker =
      TypeChecker.fromUrl(targetClassUrl);

  late final mixinName = mixinUrl.split('#')[1];
}
