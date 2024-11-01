import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mycall/features/call/model/icons_and_names_model.dart';
import 'package:mycall/features/landing/model/landing_data_model.dart';

class CallUi extends StatefulWidget {
  LandingDataModel data;
  CallUi({Key? key, required this.data}) : super(key: key);

  @override
  State<CallUi> createState() => _CallUiState();
}

class _CallUiState extends State<CallUi> {
  List<IconsAndNamesModel> iconDataList = [
    IconsAndNamesModel(heading: "Dial Pad", iconName: Icons.dialpad_outlined),
    IconsAndNamesModel(
        heading: "Mic Off", iconName: Icons.mic_external_off_outlined),
    IconsAndNamesModel(heading: "Speaker", iconName: Icons.volume_up_outlined),
    IconsAndNamesModel(heading: "More", iconName: Icons.more_vert),
  ];

  // final MethodChannel _platformChannel = const MethodChannel('channel-name');
  late final MethodChannel _platformChannel;

  Future<void> _startCall() async {
    try {
      await _platformChannel
          .invokeMethod('startCall', {'phoneNumber': widget.data.number});
    } on PlatformException catch (e) {
      print("Failed to start call: '${e.message}'.");
    }
  }

  Future<void> _endCall(BuildContext context) async {
    try {
      await _platformChannel.invokeMethod('endCall');
      Navigator.pop(context); // Close the Call UI when call ends
    } on PlatformException catch (e) {
      print("Failed to end call: '${e.message}'.");
    }
  }

  @override
  void initState() {
    super.initState();
    _platformChannel = const MethodChannel('channel-name');
    _startCall();
  }

  @override
  Widget build(BuildContext context) {
    // _startCall();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Center(
                  child: Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 0.50),
                      image: DecorationImage(
                          image: AssetImage(
                            widget.data.img.toString(),
                          ),
                          fit: BoxFit.fitWidth),
                      // color: Colors.amber,
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
                const Text(
                  "Calling via SIM 2",
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  widget.data.name ?? "NA",
                  style: TextStyle(fontSize: 30),
                ),
                Text(
                  widget.data.number ?? "NA",
                  style: TextStyle(fontSize: 18),
                )
              ],
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.3,
              decoration: const BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (int i = 0; i < iconDataList.length; i++)
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            children: [
                              Container(
                                height: 45,
                                width: 45,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Icon(iconDataList[i].iconName),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                iconDataList[i].heading,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 13),
                              )
                            ],
                          ),
                        )
                    ],
                  ),
                  InkWell(
                    onTap: () async {
                      _endCall(context);
                    },
                    child: Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Icon(
                        Icons.call_end,
                        size: 35,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
