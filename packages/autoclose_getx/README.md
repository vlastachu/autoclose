# AutoClose-GetX

This is a part of [AutoClose package](https://pub.dev/packages/autoclose): You should first visit this link to 
become familiar with the key concepts of this library..

This library provides functionality of [AutoClose package](https://pub.dev/packages/autoclose) for [GetX](https://pub.dev/packages/get#state-management) classes.

## Getting started

```bash
flutter pub add autoclose_getx
# optional, but I insist on giving it a chance
flutter pub add autoclose_lint
```

## Usage

```dart
class ProfileEditingController extends GetxController with CloserGetx {
  final UserRepository userRepository;

  ProfileEditingController({
    required this.userRepository,
  });

  @override
  void onInit() {
    super.onInit();

    userRepository.userAuthTokenStream.listen((token) {
      // ... handle token update
    })
    // CloserGetx mixin provides `closeWith` functionality
    // so subscriptions/resources get canceled in onClose().
    .closeWith(this);
  }
}
```
