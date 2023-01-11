import 'package:agent_demo/Models/user.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as formdata;
import 'package:get_storage/get_storage.dart';

class HomePageViewModel extends GetxController {
  User? sender, receiver;

  @override
  void onInit() {
    getVideoCallInfo();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    receiver = User(
      uid: '123',
      name: 'User',
      profilePhoto:
          'https://www.pngitem.com/pimgs/m/404-4042710_circle-profile-picture-png-transparent-png.png',
    );
    sender = User(
      uid: '124',
      name: 'Agent',
      profilePhoto:
          'https://www.nicepng.com/png/full/182-1829287_cammy-lin-ux-designer-circle-picture-profile-girl.png',
    );
  }

  Future<void> getVideoCallInfo() async {
    const String token = "50P50cDhaiYaiDmR7QL";
    const String getVideoCallToken =
        "https://ezpaystation.com/administratorPanel/api/video-call-token.php";

    try {
      final data = formdata.FormData.fromMap({
        "token": token,
      });
      var response = await Dio().post(getVideoCallToken, data: data);
      print("Response: ${response.data}");
      if (response.data["code"].toString() == "4") {
        final pref = GetStorage();
        await pref.write("appID", response.data["data"]['app_id'].toString());
        await pref.write(
            "tempToken", response.data["data"]['token_value'].toString());
        await pref.write(
            "channelName", response.data["data"]['channel_name'].toString());
      } else {
        // videos = [];
        // notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }
}
