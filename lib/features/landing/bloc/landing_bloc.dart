import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:mycall/features/landing/model/landing_data_model.dart';
import 'package:mycall/utils/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
part 'landing_event.dart';
part 'landing_state.dart';

class LandingBloc extends Bloc<LandingEvent, LandingState> {
  List<LandingDataModel> _landingDataList = <LandingDataModel>[];
  static const channel = MethodChannel('channel-name');
  String? _networkStatus;
  UserData _selectedOption = UserData.custom;

  LandingBloc() : super(LandingInitial()) {
    on<LandingButtonColorTapEvent>(landingButtonColorTapEvent);
    on<LandingGetDataEvent>(landingGetDataEvent);
    on<LandingNavigateToCallEvent>(landingNavigateToCallEvent);
    on<LandingRadioButtonEvent>(landingRadioButtonEvent);
    on<LandingRequestPermissionEvent>(landingRequestPermissionEvent);
  }
  Future<void> makePhoneCall(String phoneNumber) async {
    try {
      final result = await channel
          .invokeMethod('makePhoneCall', {'phoneNumber': phoneNumber});
    } on PlatformException catch (e) {
      print("Failed to make phone call: ${e.message}");
    }
  }

  Future<void> getNetworkStatus() async {
    try {
      final String result = await channel.invokeMethod('getNetworkStatus');

      _networkStatus = result;

      print(result);
    } on PlatformException catch (e) {
      _networkStatus = "Failed to get network status: ${e.toString()}.";

      print(e.toString());
    }
  }

  FutureOr<void> landingButtonColorTapEvent(
      LandingButtonColorTapEvent event, Emitter<LandingState> emit) {
    final tap = !event.isTap;
    emit(LandingOnTapChangeColorState(isTap: tap));
    print("II$tap");
  }

  FutureOr<void> landingGetDataEvent(
      LandingGetDataEvent event, Emitter<LandingState> emit) async {
    try {
      _landingDataList.clear();
      final String response =
          await rootBundle.loadString('lib/localdata/data.json');
      List<dynamic> jsonData = await json.decode(response);
      List<LandingDataModel> data = jsonData.map(
        (item) {
          return LandingDataModel(
              id: item['id'],
              name: item['name'],
              called: item['called'],
              number: item['number'],
              date: item['date'],
              day: item['day'],
              img: item['img'],
              isMissed: item['isMissed']);
        },
      ).toList();
      print(data.map((e) => e.name).toList());
      emit(LandingGetDataState(data: data));
    } catch (e) {
      print("Error ${e.toString()}");
    }
  }

  Future<void> landingNavigateToCallEvent(
      LandingNavigateToCallEvent event, Emitter<LandingState> emit) async {
    if (event.number.isNotEmpty) {
      print("*********");
      print(PreferenceUtils.getString(UserData.android.name));
      if (PreferenceUtils.getString(UserData.android.name) ==
          UserData.android.name) {
        // _startCall(event.number);
        makePhoneCall(event.number);
      } else {
        if (event.number.isNotEmpty) {
          // await _startCall(event.number);
          emit(LadingNavigateToCallState(data: event.data));
        }
      }
    }
  }

  Future<void> _startCall(String phoneNumber) async {
    try {
      // final result = makePhoneCall(phoneNumber);
      await channel.invokeMethod('startCall', {'phoneNumber': phoneNumber});
    } on PlatformException catch (e) {
      print("Failed to start call: ${e.toString()}");
    }
  }

  FutureOr<void> landingRadioButtonEvent(
      LandingRadioButtonEvent event, Emitter<LandingState> emit) {
    _selectedOption = event.selectedOption;
    emit(LandingRadioButtonChangedState(selectedOption: _selectedOption));
  }

  FutureOr<void> landingRequestPermissionEvent(
      LandingRequestPermissionEvent event, Emitter<LandingState> emit) {}
}
