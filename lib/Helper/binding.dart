import 'package:agent_demo/Shared/Network/Models/videoCallViewModel.dart';
import 'package:get/get.dart';

class Binding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VideoCallViewModel());
  }
}
