import 'package:autoclose_bloc/closer/closer_bloc.dart';
import 'package:bloc/bloc.dart';

class ProfileEditingFormBloc
    extends Bloc<ProfileEditingFormEvent, ProfileEditingFormState>
    with CloserBloc {
  final UserRepository userRepository;

  ProfileEditingFormBloc({
    required this.userRepository,
  }) {
    on<ProfileFetchRenewedUserData>(_onProfileFetchRenewedUserData);
    // ... other events

    userRepository.userAuthTokenStream.listen((token) {
      add(ProfileFetchRenewedUserData(token: token));
    }).closeWith(this);
  }
}
