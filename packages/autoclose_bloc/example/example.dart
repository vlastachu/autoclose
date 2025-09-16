import 'dart:async';

import 'package:autoclose_bloc/autoclose_bloc.dart';
import 'package:bloc/bloc.dart';

part 'example_rest.dart';

class ProfileEditingFormBloc
    extends Bloc<ProfileEditingFormEvent, ProfileEditingFormState>
    with CloserBloc {
  final UserRepository userRepository;

  ProfileEditingFormBloc(
    super.initialState, {
    required this.userRepository,
  }) {
    on<ProfileFetchRenewedUserData>((event, emit) => {
          // ...
        });
    // ... other events

    userRepository.userAuthTokenStream.listen((token) {
      add(ProfileFetchRenewedUserData(token: token));
    }).closeWith(this);
  }
}
