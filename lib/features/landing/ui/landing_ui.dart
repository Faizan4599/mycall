import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mycall/constant/constant.dart';
import 'package:mycall/features/call/call_ui.dart';
import 'package:mycall/features/landing/bloc/landing_bloc.dart';
import 'package:mycall/features/landing/model/landing_data_model.dart';
import 'package:mycall/mixins/common_mixin.dart';
import 'package:mycall/utils/shared_preferences.dart';
import 'package:mycall/widget/round_button.dart';
import 'package:permission_handler/permission_handler.dart';

class LandingUi extends StatelessWidget with CommonMixin {
  final _bloc = LandingBloc();
  UserData _selectedOption = UserData.android;
  LandingUi({super.key}) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        _requestPermission();
        _bloc.add(LandingGetDataEvent());
      },
    );
  }
  final TextEditingController numberTxt = TextEditingController();
  void _requestPermission() async {
    final status = await Permission.phone.status;
    if (!status.isGranted) {
      await Permission.phone.request();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: BlocProvider(
        create: (context) => LandingBloc(),
        child: Scaffold(
          backgroundColor: Colors.black87,
          // appBar: AppBar(
          //   title: const Text("My call"),
          // ),
          body: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              BlocBuilder<LandingBloc, LandingState>(
                builder: (context, state) {
                  bool isAllTap = true;
                  if (state is LandingOnTapChangeColorState) {
                    isAllTap = state.isTap;
                  }

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RoundButton(
                        data: "All",
                        onTap: () {
                          // _bloc.add(LandingButtonColorTapEvent(isTap: true));
                          context
                              .read<LandingBloc>()
                              .add(LandingButtonColorTapEvent(isTap: false));
                        },
                        istap: isAllTap,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      RoundButton(
                        data: "Missed",
                        onTap: () {
                          // _bloc.add(LandingButtonColorTapEvent(isTap: false));
                          context
                              .read<LandingBloc>()
                              .add(LandingButtonColorTapEvent(isTap: true));
                        },
                        istap: !isAllTap,
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Recents",
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.border_color_outlined,
                        size: 20,
                        color: Colors.white,
                      ))
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                style: TextStyle(color: Colors.white),
                controller: numberTxt,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search_outlined),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    // borderRadius: BorderRadius.circular(50.0),
                  ),
                  filled: true,
                  hintText: "Search",
                  fillColor: Colors.black87,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide:
                        const BorderSide(color: Colors.white, width: 0.50),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 0.50),
                  ),
                ),
              ),
              BlocBuilder<LandingBloc, LandingState>(
                  bloc: _bloc,
                  buildWhen: (previous, current) =>
                      current is LandingGetDataState,
                  builder: (context, state) {
                    print("State is $state ");
                    if (state is LandingGetDataState) {
                      if (PreferenceUtils.getString(UserData.android.name) ==
                              "" &&
                          PreferenceUtils.getString(UserData.custom.name) ==
                              "") {
                        WidgetsBinding.instance.addPostFrameCallback(
                          (_) {
                            _showCallOptionDialog(context);
                          },
                        );
                      }

                      return Expanded(
                        child: BlocListener<LandingBloc, LandingState>(
                          bloc: _bloc,
                          listener: (context, state) {
                            if (state is LadingNavigateToCallState) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CallUi(data: state.data),
                                ),
                              );
                            }
                          },
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: state.data.length,
                            itemBuilder: (BuildContext context, int index) {
                              final data = state.data[index];
                              return Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Container(
                                  decoration: const BoxDecoration(
                                      // border: Border.all(color: Colors.white),
                                      ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              height: 55,
                                              width: 55,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.white,
                                                    width: 0.50),
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                      data.img.toString(),
                                                    ),
                                                    fit: BoxFit.fitWidth),
                                                // color: Colors.amber,
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  data.name.toString(),
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15),
                                                ),
                                                Text(
                                                  masknumbers(
                                                      data.number.toString()),
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                                const Text(
                                                  "mobile",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Column(
                                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            IconButton(
                                              onPressed: () async {
                                                final status = await Permission
                                                    .phone.status;
                                                if (!status.isGranted) {
                                                  await Permission.phone
                                                      .request();
                                                } else if (status
                                                    .isPermanentlyDenied) {
                                                  openAppSettings();
                                                } else {
                                                  _bloc.add(
                                                    LandingNavigateToCallEvent(
                                                      data: data,
                                                      number: data.number
                                                          .toString(),
                                                    ),
                                                  );
                                                }
                                              },
                                              icon: Icon(
                                                (data.isMissed == false)
                                                    ? Icons.call
                                                    : Icons
                                                        .call_missed_outlined,
                                                size: 20,
                                                color: (data.isMissed == false)
                                                    ? Colors.white
                                                    : Colors.red,
                                              ),
                                            ),
                                            // (data.isMissed == false)
                                            //     ? IconButton(
                                            //         onPressed: () {
                                            //           print("Tap...1");
                                            //           _bloc.add(
                                            //               LandingNavigateToCallEvent(
                                            //                   data: data,
                                            //                   number:
                                            //                       data.number ??
                                            //                           ""));
                                            //         },
                                            //         icon: const Icon(
                                            //           Icons.call,
                                            //           color: Colors.white,
                                            //           size: 20,
                                            //         ),
                                            //       )
                                            //     : IconButton(
                                            //         onPressed: () {
                                            //           print("Tap...2");

                                            //           _bloc.add(
                                            //               LandingNavigateToCallEvent(
                                            //                   data: data,
                                            //                   number:
                                            //                       data.number ??
                                            //                           ""));
                                            //         },
                                            //         icon: const Icon(
                                            //           Icons.call_missed,
                                            //           color: Colors.red,
                                            //           size: 20,
                                            //         ),
                                            //       ),

                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              data.day.toString(),
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }

  void _showCallOptionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return BlocProvider(
          create: (context) => LandingBloc(),
          child: BlocBuilder<LandingBloc, LandingState>(
            builder: (context, state) {
              UserData selectedOption =
                  (state is LandingRadioButtonChangedState)
                      ? state.selectedOption
                      : _selectedOption;

              return AlertDialog(
                titlePadding: const EdgeInsets.all(16),
                contentPadding:
                    const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                title: const Text(
                  "Default phone app",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RadioListTile(
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      title: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Phone", style: TextStyle(fontSize: 14)),
                          Text("(System default)",
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                      value: UserData.android,
                      groupValue: selectedOption,
                      onChanged: (value) {
                        context.read<LandingBloc>().add(
                              LandingRadioButtonEvent(
                                  selectedOption: UserData.android),
                            );
                        setUserData(UserData.android.name);
                        Navigator.pop(context);
                      },
                    ),
                    RadioListTile(
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      title: const Text(
                        Constant.appName,
                        style: TextStyle(fontSize: 14),
                      ),
                      value: UserData.custom,
                      groupValue: selectedOption,
                      onChanged: (value) {
                        context.read<LandingBloc>().add(
                              LandingRadioButtonEvent(
                                  selectedOption: UserData.custom),
                            );
                        setUserData(UserData.custom.name);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  // // Navigate to custom call screen
  // void _navigateToCall(BuildContext context, LandingDataModel data) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => CallUi(data: data),
  //     ),
  //   );
  // }

  // // Invoke Android Dialer using platform channel
  // void _navigateToAndroidDialer(String phoneNumber) {
  //   _bloc.makePhoneCall(phoneNumber);
  // }

  setUserData(String val) {
    PreferenceUtils.setString(UserData.android.key, val);
    PreferenceUtils.setString(UserData.custom.key, val);
  }
}
