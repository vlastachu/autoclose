import 'package:autoclose_lint/src/closable/closable_lint_config.dart';
import 'package:autoclose_lint/src/closer/closer_assist_config.dart';
import 'package:autoclose_lint/src/subclosable/subclosable_lint_config.dart';

class PackageConfig {
  final List<ClosableLintConfig> closables;
  final List<SubclosableLintConfig> subClosables;
  final List<CloserAssistConfig> closers;

  PackageConfig({
    this.closables = const [],
    this.closers = const [],
    this.subClosables = const [],
  });
}
