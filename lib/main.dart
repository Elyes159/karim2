import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/core/Home/state.dart';
import 'package:quran_app/core/bloc/base_bloc.dart';
import 'package:quran_app/core/helper/db/sqflite.dart';
import 'package:quran_app/core/helper/dio/dio_helper.dart';
import 'package:quran_app/core/services/permission_service.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/core/services/services_location.dart';
import 'package:quran_app/features/bookmark/presentation/bloc/bookmark_bloc.dart';
import 'package:quran_app/features/prayer_time/cubit/prayer_time_cubit.dart';
import 'package:quran_app/features/quran_audio/ui/cubit/audio_cubit.dart';

import 'package:quran_app/core/BlocObserver/BlocObserver.dart';
import 'package:quran_app/core/Home/cubit.dart';
import 'package:quran_app/features/read_quran/data/data_source/data_client.dart';
import 'package:quran_app/features/read_quran/presentation/bloc/read_quran_bloc.dart';
import 'package:quran_app/firebase_options.dart';
import 'package:quran_app/starting/signin.dart';
import 'package:sqflite/sqflite.dart';
import 'features/my_adia/core/db/db_helper_note.dart';
import 'main_view.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

Logger logger = Logger();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } else if (Platform.isIOS) {
    await Firebase.initializeApp();
  }
  await FlutterDownloader.initialize();
  Bloc.observer = MyBlocObserver();
  await DBHelperDou.initDb();
  await DioHelper.init();
  DBHelper.initDb();
  await CashHelper.init();
  lastPageRead = CashHelper.getInt(key: 'lastPageRead') ?? 0;
  currentThemeType = CashHelper.getInt(key: 'currentThemeType') ?? 0;
  setupServiceLocator();
  serviceEnabled = await PermissionService.locationEnabled();

  // Vérification et demande de permission de localisation
  final permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    await Geolocator.requestPermission();
  }

  // Gestion des notifications
  await PermissionService.handelNotification();

  // Vérification de l'utilisateur actuel
  User? user = FirebaseAuth.instance.currentUser;

  // Configuration des blocs
  final providers = [
    Provider<PrayerTimeCubit>(create: (_) => PrayerTimeCubit()),
    BlocProvider(create: (context) => AudioCubit()..initAudioPlayer()),
    BlocProvider(create: (context) => HomeCubit()..checkConnection()),
    BlocProvider(create: (context) => BaseBloc()),
    BlocProvider(create: (context) => BookmarkBloc()),
    BlocProvider(
        lazy: false,
        create: (context) => ReadQuranBloc()..add(LoadQuranEvent())),
  ];

  // Sélection du widget racine en fonction de la présence de l'utilisateur
  Widget app;
  if (user == null) {
    app = Login();
  } else {
    app = BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) => MyApp(),
    );
  }

  // Exécution de l'application avec les blocs configurés
  runApp(
    MultiBlocProvider(
      providers: providers,
      child: MaterialApp(
          // localizationsDelegates: AppLocalizations.localizationsDelegates,
          // supportedLocales: AppLocalizations.supportedLocales,
          // locale: _locale,
          home: app),
    ),
  );
}

Future<Database?> getDatabase() async {
  try {
    return await sl<DataBaseClient>().database;
  } catch (e) {
    logger.e(e);
  }
  return null;
}
//https://raw.githubusercontent.com/islamic-network/cdn/master/info/cdn_surah_audio.json

//https://api.alquran.cloud/v1/edition/format/audio

//ai:https://islam-ai-api.p.rapidapi.com/api/bot?question="اهميه الصلاة"
//ai:https://islam-ai-api.p.rapidapi.com/api/chat?question="اهميه الصلاة"

class RestartWidget extends StatefulWidget {
  const RestartWidget({super.key, required this.child});

  final Widget child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>()!.restartApp();
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}
