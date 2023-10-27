# AutoClose

AutoClose — is a package designed to reduce the entire boilerplate from things that can be `.dispose()`d, `.close()`d or whatever!

## Table of Contents

- [What exactly does this package do?](#what-exactly-does-this-package-do-)
- [Why this is actually cool](#why-this-is-actually-cool)
  * [꙳ Reducing boilerplait](#--reducing-boilerplait)
- [Installation](#installation)
  * [AutoClose Lints installation](#autoclose-lints-installation)
- [Usage](#usage)
- [Extendability](#extendability)
- [Further works](#further-works)

## What exactly does this package do?

![It turns this into that](https://github.com/vlastachu/autoclose/raw/main/assets/it-turns-this-into-that.png "It turns this into that")

Let's take a closer look at what happened. On the left side you can see the `dispose()` block that has 
completely disappeared on the right side. And this is a definite advantage. But on the other hand, 
you may think differently. The stream subscription required three lines: variable declaration, subscription 
initialization, and subscription cancellation. Now we need a combined initialization and cancellation 
block + add a mixin to the class (and at the same time remember what the corresponding mixin is called). 
The advantages are no longer so obvious. Let me try to clear your doubts.


![lints.gif](https://github.com/vlastachu/autoclose/raw/main/assets/lints.gif "lints.gif")



What happens after applying the first fix:

![First lint zoomed](https://github.com/vlastachu/autoclose/raw/main/assets/lints-zoom.png "First lint zoomed")

You can notice the following changes:

- Added corresponding import
- Added mixin which handles closable resources when a widget's `dispose` method is called
- Added `closeWith` call which tells to Closer to handle that supscription

At this point, I hope you have formed an understanding that you definitely need this package and are ready to move on to the [How to install](#installation) chapter. If not, then let me try to explain why it's cool.

## Why this is actually cool

Let's highlight some pro's points:

- Reducing boilerplait **꙳**
- Identifying places that need your attention: when lints are enabled, you can easily spot areas in your code that may have been overlooked for resource management
- Enabling `closeWith` requires only a single fix
- Reducing the number of class fields, allowing you to focus on controlling your application logic instead of managing resources
- Ensuring the proper order of `removeListener` and `dispose` calls (see Usage section)
- Prevents you to close twice

### ꙳ Reducing boilerplaite

The problem with boilerplate code goes beyond simply reducing code volume. It manifests in various ways:

1. When you writing code, you still need to think about the specifics of resource management. This package simplifies the common cases, but you may encounter exceptions where the resource's lifetime doesn't match the widget's lifetime. In such cases, you can use the `// ignore:` comment to handle these situations deliberately.
2. When reading code, it's challenging to maintain focus when you encounter sequences of nearly identical lines. These repetitive lines require more cognitive effort to distinguish meaningful code.
3. During code refactoring or copy-pasting, the boilerplate problem becomes evident. You have to decide whether to carefully review and adjust each piece of code or dismiss it as unimportant. This approach can be problematic if there's a unique 1% case with an unusual flow in the subscription.

AutoClose consolidates the subscription flow into one place, making it simpler to read and manage. It also provides the `// ignore:` comment as a signal to handle exceptional cases with care.

## Installation

To get started with AutoClose, install the package using the following commands:

```bash
flutter pub add autoclose autoclose_flutter
```

Note: AutoClose currently only works with Flutter, not pure Dart. 

If you're using the Bloc state management library, install the corresponding package:

```bash
flutter pub add autoclose_bloc
```

If you'd like to see support for other state managers, please let me know.

### AutoClose Lints installation

AutoClose Lints were created using the custom_lint package. To install them, use the following commands:

```bash
flutter pub add dev:autoclose_lints dev:custom_lint
```

Add the following lines to your analysis_options.yaml:

```yaml
analyzer:
  plugins:
    - custom_lint
```

Additionnaly you can [configure lints for your project](https://github.com/invertase/dart_custom_lint#enablingdisabling-and-configuring-lints).
Initially, it's recommended to enable all lints to identify areas in your code that require attention for resource management.

## Usage

Once you've successfully installed AutoClose and its lints, you'll start seeing lints in your project. Fix them by applying the suggested fixes. This practical approach is the best way to learn about AutoClose and its capabilities, and it will be within the context of your familiar project.

Additionally to this you have `onCLose` optional parameter. 

```dart
stream.listen(listener).closeWith(this, onClose: () {
  print('Stream was closed');
});
```

You can use the onClose parameter for any relevant closing operations, such as logging or metrics. It's important to note that closing operations have a return type of  `FutureOr<void>` in general case. For example stream subscription describes this:

```dart
  /// The stream may need to shut down the source of events and clean up after
  /// the subscription is canceled.
  ///
  /// Returns a future that is completed once the stream has finished
  /// its cleanup.
```

It is very rare case, but it has own place. So you may be need to execute something after resouce was closed.

One more datail which wasn't mentioned before: you have `addListenerWithCloser` instead of raw `addListener`. 
This method promises to call `removeListener` when closers will close. I wrote [an article](https://medium.com/@vlastachu/flutter-that-rare-case-when-you-need-to-remove-listener-even-if-you-call-dispose-63193790e5c3) about the case when it's important.

## Extendability

AutoClose may not cover every possible use case, but you can extend it in the following ways:

- If you're using a different state management solution (e.g., MobX, Riverpod), and AutoClose doesn't support it, [submit an issue with an example of how you typically manage resources with your state manager](https://github.com/vlastachu/autoclose/issues/new).
- If you need to manage resources that aren't covered by AutoClose, you have two options. 
  - If the resource comes from a Dart or Flutter built-in package, [file an issue with the entity's name](https://github.com/vlastachu/autoclose/issues/new).
  - For external resources, you can handle closure operations with `doOnClose`, a method available in the closer context. This approach ensures that you manage resource closure in the same place where you initialize it.

For example project depends on [mobile_scanner package](https://pub.dev/packages/mobile_scanner), which haw own `MobileScannerController`, which doesn't extend any class but have dispose [method](https://github.com/juliansteenbakker/mobile_scanner/blob/30b037c695178ac1c8f859ab4d4f80d6b443bbd3/lib/src/mobile_scanner_controller.dart#L397). 

```dart
  final controller = MobileScannerController();
  doOnClose(() => controller.dispose());
```

In the future it is planned to develop a guide and utilities for extending the AutoClose package along with lints and `closeWith` method.

## Further works

- Support for scope-bound closures, similar to Go's deferred
- Expanding support for more state management libraries
- Enhancing extendability and customization options

