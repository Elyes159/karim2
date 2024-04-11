import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/features/home/widgets/custom_bottom_navigation_bar2.dart';

part 'base_event.dart';
part 'base_state.dart';

class BaseBloc extends Bloc<BaseEvent, BaseState> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  BaseBloc() : super(BaseState()) {
    // try {
    //   // InUpdateServes.checkUpdate();
    // } catch (e) {
    //   // Gestion de l'erreur, par exemple:
    //   logger.e(e);
    // }

    // Définition des gestionnaires d'événements
    on<SetStateBaseBlocEvent>(_setState);
    on<ChangeScreenEvent>(_changeScreen);
  }

  // Gestionnaire d'événements pour SetStateBaseBlocEvent
  void _setState(SetStateBaseBlocEvent event, Emitter<BaseState> emit) {
    emit(BaseState());
  }

  // Gestionnaire d'événements pour ChangeScreenEvent
  void _changeScreen(ChangeScreenEvent event, Emitter<BaseState> emit) {
    currentPage = event.current;
    emit(BaseState());
  }

  // Méthode statique pour récupérer l'instance du Bloc
  static BaseBloc get(context) => BlocProvider.of(context);
}
