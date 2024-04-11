import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_app/FontSizeParam/settingFont.dart';
import 'package:quran_app/core/components/location_enable_screen.dart';
import 'package:quran_app/core/components/shimmer_base.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/features/prayer_time/cubit/prayer_time_cubit.dart';
import 'package:quran_app/features/prayer_time/model/time_prayer_model.dart';
import 'package:quran_app/features/prayer_time/pages/prayer_time_screen.dart';
import 'package:quran_app/features/prayer_time/text/teme_prayer_text.dart';
import 'package:quran_app/languages/languages_constants.dart';
import 'package:quran_app/localizations/app_localizations.dart';
import 'package:quran_app/starting/signin.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/services/services_location.dart';

class ItemPrayerHome extends StatefulWidget {
  const ItemPrayerHome({Key? key}) : super(key: key);

  @override
  _ItemPrayerHomeState createState() => _ItemPrayerHomeState();
}

class _ItemPrayerHomeState extends State<ItemPrayerHome> {
  late double _fontSize = 16.0;
  @override
  void initState() {
    super.initState();
    loadFontSize();
  }

  @override
  void dispose() {
    // Annuler l'abonnement pour éviter les fuites de mémoire
    super.dispose();
  }

  double fontSize = 16.0; // Valeur par défaut

  void loadFontSize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _fontSize = prefs.getDouble('fontSize') ?? _fontSize;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrayerTimeCubit, PrayerTimeState>(
      builder: (context, state) {
        return !serviceEnabled
            ? const LocationEnableScreen()
            : Padding(
                padding: const EdgeInsets.only(
                    right: 8.0, left: 8, bottom: 8, top: 8),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 15),
                          child: SizedBox(
                            height: context.getHight(4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: double.infinity,
                                  width: context.getWidth(1),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  AppLocalizations.of(context)!
                                      .translate("salet"),
                                  // translation(context).salet,
                                  // Utilisation de ?? '' pour éviter les erreurs si la localisation est null
                                  style: GoogleFonts.poppins(
                                    fontSize: fontSize,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await FirebaseAuth.instance.signOut();
                            navigateTo(
                              SettingsPage(initialFontSize: _fontSize),
                              context,
                            );
                          },
                          child: Icon(
                            Icons.settings,
                            color: Colors.blue[500],
                          ),
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              await FirebaseAuth.instance.signOut();
                              navigateTo(Login(), context);
                            },
                            child: Icon(
                              Icons.logout,
                              color: Colors.blue[500],
                            )),
                      ],
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: context.getHight(15),
                      child: BlocBuilder<PrayerTimeCubit, PrayerTimeState>(
                        builder: (context, state) {
                          switch (state.prayerState) {
                            case RequestState.defaults:
                              return const _Loading();

                            case RequestState.loading:
                              return const _Loading();

                            case RequestState.error:
                              return const _Loading();

                            case RequestState.success:
                              return ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  var data = prayerData[index];
                                  return BaseAnimate(
                                    index: index,
                                    child: _ItemPrayer(
                                      nextPray: data,
                                      data: data,
                                      index: index,
                                      nextCurrent: nextCurrentPrayer,
                                    ),
                                  );
                                },
                                shrinkWrap: true,
                                itemCount: 6,
                              );
                          }
                        },
                      ),
                    ),
                  ],
                ).animate().fade(),
              );
      },
    );
  }
}

class _ItemPrayer extends StatefulWidget {
  const _ItemPrayer({
    required this.data,
    required this.nextCurrent,
    required this.index,
    required this.nextPray,
  });

  final TimePrayerModel data;
  final TimePrayerModel nextPray;
  final int index;
  final int nextCurrent;

  @override
  State<_ItemPrayer> createState() => _ItemPrayerState();
}

class _ItemPrayerState extends State<_ItemPrayer> {
  bool isMaxLine = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.blue,
        border: widget.nextCurrent == widget.index
            ? Border.all(color: Colors.white)
            : null,
      ),
      child: Material(
        child: InkWell(
          onTap: () {
            context.push(const PrayerTimeScreen());
            isMaxLine = !isMaxLine;
            setState(() {});
          },
          child: Container(
            decoration: const BoxDecoration(color: Colors.blue),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      widget.data.image,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.data.title,
                ),
                const SizedBox(height: 5),
                Text(
                  widget.data.time,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < 4; i++)
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context).primaryColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: BaseShimmer(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  BaseShimmer(
                    child: Container(
                      height: context.getWidth(2),
                      width: double.infinity,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                      ),
                      child: const Text("sfsfs"),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
