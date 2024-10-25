part of 'landing_bloc.dart';

@immutable
sealed class LandingState {}

final class LandingInitial extends LandingState {}

final class LandingLoadingState extends LandingState {}

final class LandingErrorState extends LandingState {}

final class LandingOnTapChangeColorState extends LandingState {
  bool isTap;
  LandingOnTapChangeColorState({required this.isTap});
}

final class LandingGetDataState extends LandingState {
  List<LandingDataModel> data;
  LandingGetDataState({required this.data});
}
