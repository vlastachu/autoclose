import 'package:analyzer/source/source_range.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'closer_assist_config.dart';

class AddCloserMixinAssist extends DartAssist {
  final CloserAssistPackageConfig config;

  AddCloserMixinAssist(this.config);

  @override
  void run(CustomLintResolver resolver, ChangeReporter reporter,
      CustomLintContext context, SourceRange target) {
    context.registry.addClassDeclaration((node) {
      if (!config.sourceLibContainsInPubspec(context)) {
        return;
      }
      // Check that the visited node is under the cursor
      if (!target.intersects(node.sourceRange)) return;

      final extendsClause = node.extendsClause;
      final superClassElement = extendsClause?.superclass.element;
      if (extendsClause == null ||
          superClassElement == null ||
          !config.targetClassTypeChecker.isAssignableFrom(superClassElement)) {
        return;
      }

      final withClause = node.withClause;
      if (withClause != null &&
          withClause.mixinTypes.map((e) => e.element).nonNulls.any((element) =>
              config.closerMixinTypeChecker.isAssignableFrom(element))) {
        return;
      }

      final changeBuilder = reporter.createChangeBuilder(
        priority: 80,
        message: config.assistMessage,
      );
      changeBuilder.addDartFileEdit((builder) {
        if (!builder.importsLibrary(config.closerSourceLib)) {
          builder.importLibrary(config.closerSourceLib);
        }
        if (withClause != null) {
          builder.addSimpleInsertion(withClause.end, ', ${config.mixinName}');
        } else {
          builder.addSimpleInsertion(
              extendsClause.end, ' with ${config.mixinName}');
        }
      });
    });
  }
}
