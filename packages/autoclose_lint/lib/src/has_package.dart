import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class HasPackage {
  final Uri sourcePackage;
  HasPackage(this.sourcePackage);

  void tryImportSelfPackage(DartFileEditBuilder builder) {
    if (!builder.importsLibrary(sourcePackage)) {
      builder.importLibrary(sourcePackage);
    }
  }

  bool sourceLibContainsInPubspec(CustomLintContext context) =>
      context.pubspec.dependencies.keys
          .contains(sourcePackage.pathSegments[0]);
}
