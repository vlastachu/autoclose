AutoClose — is a package designed to reduce the entire boilerplate from things that can be `.dispose()`d, `.close()`d or whatever!

## What exactly does this package do?

![It turns this into that](assets/it-turns-this-into-that.png "It turns this into that")

Let's take a closer look at what happened. On the left side you can see the `dispose()` block that has 
completely disappeared on the right side. And this is a definite advantage. But on the other hand, 
you may think differently. The stream subscription required three lines: variable declaration, subscription 
initialization, and subscription cancellation. Now we need a combined initialization and cancellation 
block + add a mixin to the class (and at the same time remember what the corresponding mixin is called). 
The advantages are no longer so obvious. Let me try to clear your doubts.


https://github.com/vlastachu/autoclose/assets/527307/dfb9c12a-6367-4ad0-bbfb-640049d0418d


## Installation

First of all you need to install this package

```
flutter pub add autoclose
flutter pub add autoclose_flutter
```

For now this package is useless for pure dart without flutter. But I hope sometime it will be changed.

If you are using the Bloc state manager you also should install corresponding package

```
flutter pub add autoclose_bloc
```

If you would like to see other state managers then let me know.

And I highly recommend you to install lint package

### AutoClose_Lints installation

Lints were created using custom_lint package (thank to guys from Invertase to that help in my dream setup). 
So that the installation is accompanied by corresponding and somewhat specific installation requirements of custom_lint:

```
flutter pub add dev:autoclose_lints dev:custom_lint
```

Add the following lines to your analysis_options.yaml:

```
analyzer:
  plugins:
    - custom_lint
```

Additionnaly you can [configure lints for your project](https://github.com/invertase/dart_custom_lint#enablingdisabling-and-configuring-lints).
For first time I recommend to enable all lints (this is default) to review all places which needs to your attention with closable things.

## Usage

## Additional information
