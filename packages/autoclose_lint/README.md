# AutoClose-Lint

This is a part of [AutoClose package](https://pub.dev/packages/autoclose): You should first visit this link to 
become familiar with the key concepts of this package.


## Installation

AutoClose-Lint were created using the custom_lint package. To install them, use the following commands:

```bash
flutter pub add dev:autoclose_lint dev:custom_lint
```

Add the following lines to your analysis_options.yaml:

```yaml
analyzer:
  plugins:
    - custom_lint
```

Additionnaly you can [configure lints for your project](https://github.com/invertase/dart_custom_lint#enablingdisabling-and-configuring-lints).
Initially, it's recommended to enable all lints to identify areas in your code that require attention for resource management.
