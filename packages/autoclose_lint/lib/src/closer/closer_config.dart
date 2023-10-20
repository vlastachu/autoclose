import 'package:autoclose_lint/src/has_package.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class CloserConfig extends HasPackage {
  final String targetClassUrl;
  final String mixinName;

  CloserConfig(
    super.sourcePackage, {
    required this.mixinName,
    required this.targetClassUrl,
  });

  late final closerMixinTypeChecker =
      TypeChecker.fromUrl('$sourcePackage#$mixinName');

  String get assistMessage => 'Add corresponding Closer mixin';

  late final TypeChecker targetClassTypeChecker =
      TypeChecker.fromUrl(targetClassUrl);
}
