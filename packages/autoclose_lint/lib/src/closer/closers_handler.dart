import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:autoclose_lint/src/closer/closer_config.dart';

class ClosersHandler {
  final List<CloserConfig> closerConfigs;

  ClosersHandler({required this.closerConfigs});

  void addCloserMixin(
    ClassDeclaration? classDecl,
    DartFileEditBuilder builder,
  ) {
    if (classDecl == null) return;
    final extendsClause = classDecl.extendsClause;
    final superClassElement = extendsClause?.superclass.element;

    if (extendsClause == null || superClassElement == null) return;

    final closerConfig = closerConfigs
        .where(
          (closerConfig) => closerConfig.targetClassTypeChecker
              .isAssignableFrom(superClassElement),
        )
        .firstOrNull;

    if (closerConfig == null) return;

    final withClause = classDecl.withClause;
    if (withClause != null &&
        withClause.mixinTypes.map((e) => e.element).nonNulls.any(
              (element) =>
                  closerConfig.closerMixinTypeChecker.isAssignableFrom(element),
            )) {
      return;
    }

    closerConfig.tryImportSelfPackage(builder);
    if (withClause != null) {
      builder.addSimpleInsertion(withClause.end, ', ${closerConfig.mixinName}');
    } else {
      builder.addSimpleInsertion(
        extendsClause.end,
        ' with ${closerConfig.mixinName}',
      );
    }
  }
}
