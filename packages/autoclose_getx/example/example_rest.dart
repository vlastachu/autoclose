part of 'example.dart';

class ProfileEditingFormEvent {}

class ProfileFetchRenewedUserData extends ProfileEditingFormEvent {
  String token;
  ProfileFetchRenewedUserData({required this.token});
}

class ProfileEditingFormState {}

class UserRepository {
  Stream get userAuthTokenStream => Stream.empty();
}
