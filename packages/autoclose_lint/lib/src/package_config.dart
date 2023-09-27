import 'package:autoclose_lint/src/closable/closable_lint_config.dart';
import 'package:autoclose_lint/src/closer/closer_assist_config.dart';

class PackageConfig {
  final List<ClosableLintConfig> closables;
  final List<CloserAssistConfig> closers;

  PackageConfig({required this.closables, required this.closers});
}
