import 'package:autoclose_lint/src/closable/closable_config.dart';
import 'package:autoclose_lint/src/closer/closer_config.dart';
import 'package:autoclose_lint/src/subclosable/subclosable_config.dart';

class PackageConfig {
  final String package;
  final List<String> closableTargetUrls;
  final List<({String closableTargetUrl, String methodName})> subClosables;
  final List<({String targetClassUrl, String mixinName})> closers;

  PackageConfig(
    this.package, {
    this.closableTargetUrls = const [],
    this.closers = const [],
    this.subClosables = const [],
  });

  late final Uri packageUri = Uri.parse(package);

  late final List<ClosableConfig> closableConfigs = closableTargetUrls
      .map(
        (closableTargetUrl) => ClosableConfig(
          packageUri,
          closableTargetUrl: closableTargetUrl,
        ),
      )
      .toList();

  late final List<SubclosableConfig> subClosableConfigs = subClosables
      .map(
        (subClosable) => SubclosableConfig(
          packageUri,
          closableTargetUrl: subClosable.closableTargetUrl,
          methodName: subClosable.methodName,
        ),
      )
      .toList();

  late final List<CloserConfig> closerConfigs = closers
      .map(
        (closer) => CloserConfig(
          packageUri,
          targetClassUrl: closer.targetClassUrl,
          mixinName: closer.mixinName,
        ),
      )
      .toList();
}
