import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:mycall/features/landing/model/landing_data_model.dart';

part 'landing_event.dart';
part 'landing_state.dart';

class LandingBloc extends Bloc<LandingEvent, LandingState> {
  List<LandingDataModel> _landingDataList = <LandingDataModel>[];
  LandingBloc() : super(LandingInitial()) {
    on<LandingButtonColorTapEvent>(landingButtonColorTapEvent);
    on<LandingGetDataEvent>(landingGetDataEvent);
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
}
