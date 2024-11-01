part of 'landing_bloc.dart';

@immutable
sealed class LandingState {}

sealed class LandingActionState extends LandingState {}

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

final class LadingNavigateToCallState extends LandingActionState {
  LandingDataModel data;
  LadingNavigateToCallState({required this.data});
}

final class LandingRadioButtonChangedState extends LandingState {
  final UserData selectedOption;
  LandingRadioButtonChangedState({required this.selectedOption});
}

