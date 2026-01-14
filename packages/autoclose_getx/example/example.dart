import 'dart:async';

import 'package:get/get.dart';

part 'example_rest.dart';

class ProfileController extends GetxController {
  final UserRepository userRepository;

  ProfileController(this.userRepository);

  @override
  void onInit() {
    super.onInit();

    userRepository.userAuthTokenStream.listen((token) {
      // handle token
    });
  }
}
