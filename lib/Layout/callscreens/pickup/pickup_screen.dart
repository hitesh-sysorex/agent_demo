import 'package:agent_demo/Helper/call_methods.dart';
import 'package:agent_demo/Layout/callscreens/call_screen.dart';
import 'package:agent_demo/Models/call.dart';
import 'package:flutter/material.dart';

class PickupScreen extends StatefulWidget {
  final Call call;

  const PickupScreen({
    required this.call,
  });

  @override
  _PickupScreenState createState() => _PickupScreenState();
}

class _PickupScreenState extends State<PickupScreen> {
  final CallMethods callMethods = CallMethods();
  // final LogRepository logRepository = LogRepository(isHive: true);
  // final LogRepository logRepository = LogRepository(isHive: false);

  bool isCallMissed = true;

  // addToLocalStorage({@required String callStatus}) {
  //   Log log = Log(
  //     callerName: widget.call.callerName,
  //     callerPic: widget.call.callerPic,
  //     receiverName: widget.call.receiverName,
  //     receiverPic: widget.call.receiverPic,
  //     timestamp: DateTime.now().toString(),
  //     callStatus: callStatus,
  //   );

  //   LogRepository.addLogs(log);
  // }

  @override
  void dispose() {
    if (isCallMissed) {
      // addToLocalStorage(callStatus: CALL_STATUS_MISSED);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "Incoming...",
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            const SizedBox(height: 50),
            Image.network(
              widget.call.callerPic!,
              // isRound: true,
              // radius: 180,
            ),
            const SizedBox(height: 15),
            Text(
              widget.call.callerName!,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 75),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.call_end),
                  color: Colors.redAccent,
                  onPressed: () async {
                    isCallMissed = false;
                    // addToLocalStorage(callStatus: CALL_STATUS_RECEIVED);
                    await callMethods.endCall(call: widget.call);
                  },
                ),
                const SizedBox(width: 25),
                IconButton(
                    icon: const Icon(Icons.call),
                    color: Colors.green,
                    onPressed: () async {
                      isCallMissed = false;
                      // addToLocalStorage(callStatus: CALL_STATUS_RECEIVED);
                      // await Permissions.cameraAndMicrophonePermissionsGranted()
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CallScreen(call: widget.call),
                        ),
                      );
                      // : {};
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
