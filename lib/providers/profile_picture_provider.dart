import 'package:flutter/widgets.dart';
import 'package:quickparked/controllers/authentication_controller.dart';

class ProfilePictureProvider with ChangeNotifier {
  static const defaultPicture = AssetImage("assets/icons/user.png");
  ImageProvider<Object> _profilePicture = defaultPicture;
  ImageProvider<Object> get profilePicture => _profilePicture;

  void updateProfilePicture() async {
    try {
      var profileData =
          await AuthenticationController.instance.getProfilePicture();
      _profilePicture = MemoryImage(profileData!);
    } catch (e) {
      _profilePicture = defaultPicture;
    } finally {
      notifyListeners();
    }
  }
}
