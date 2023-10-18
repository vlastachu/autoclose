# AutoClose-Bloc

This is a part of [AutoClose package](https://pub.dev/packages/autoclose): You should first visit this link to 
become familiar with the key concepts of this library..

This library provides functionality of [AutoClose package](https://pub.dev/packages/autoclose) for [Bloc](https://pub.dev/packages/flutter_bloc) classes.

## Getting started

```bash
# required
flutter pub add autoclose 
# it is POSSIBLE to use without Flutter. Can't imagine why
flutter pub add autoclose_flutter
# optional, but I insist on giving it a chance
flutter pub add autoclose_lint
# this lib
flutter pub add autoclose_bloc
```

## Usage

```dart
class ProfileEditingFormBloc extends Bloc<ProfileEditingFormEvent, ProfileEditingFormState> 
  // add AutoCloseBloc mixin to your bloc either manualy
  // or by closer bloc assist (press `⌘.` in VS Code or `Alt+Enter` in IntelliJ Idea)
  with AutoCloseBloc {

  final UserRepository userRepository;

  ProfileEditingFormBloc({
    required this.userRepository,
  }) {
    on<ProfileFetchRenewedUserData>(_onProfileFetchRenewedUserData);
    // ... other events

    userRepository.userAuthTokenStream.listen((token) {
      add(ProfileFetchRenewedUserData(token: token));
    })
    // AutoCloseBloc mixin provides `closeWith` functionality for your Bloc classes
    .closeWith(this);
  }
}
```
