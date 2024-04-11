part of 'prayer_time_cubit.dart';

@immutable
// ignore: must_be_immutable
class PrayerTimeState {
  RequestState prayerState;
  PrayerTimeState({this.prayerState = RequestState.defaults});
}
