import 'package:agent_demo/Helper/call_methods.dart';
import 'package:agent_demo/Layout/callscreens/call_screen.dart';
import 'package:agent_demo/Models/call.dart';
import 'package:agent_demo/Models/user.dart';
import 'package:agent_demo/Shared/Components/constant.dart';
import 'package:flutter/material.dart';

class CallUtils {
  static final CallMethods callMethods = CallMethods();

  static dial({User? from, User? to, context}) async {
    Call call = Call(
      callerId: from!.uid,
      callerName: from.name,
      callerPic: from.profilePhoto,
      receiverId: to!.uid,
      receiverName: to.name,
      receiverPic: to.profilePhoto,
      // channelId: Random().nextInt(1000).toString(),
      channelId: channel,
    );

    // Log log = Log(
    //   callerName: from.name,
    //   callerPic: from.profilePhoto,
    //   callStatus: CALL_STATUS_DIALLED,
    //   receiverName: to.name,
    //   receiverPic: to.profilePhoto,
    //   timestamp: DateTime.now().toString(),
    // );

    bool callMade = await callMethods.makeCall(call: call);

    call.hasDialled = true;

    if (callMade) {
      // enter log
      // LogRepository.addLogs(log);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallScreen(call: call),
        ),
      );
    }
  }
}
