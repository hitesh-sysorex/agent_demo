import 'package:agent_demo/Models/user.dart';
import 'package:get/get.dart';

class HomePageViewModel extends GetxController {
  User? sender, receiver;

  @override
  void onReady() {
    super.onReady();

    sender = User(
      uid: '123',
      name: 'User',
      profilePhoto:
          'https://www.pngitem.com/pimgs/m/404-4042710_circle-profile-picture-png-transparent-png.png',
    );
    receiver = User(
      uid: '124',
      name: 'Agent',
      profilePhoto:
          'https://www.nicepng.com/png/full/182-1829287_cammy-lin-ux-designer-circle-picture-profile-girl.png',
    );
  }
}
