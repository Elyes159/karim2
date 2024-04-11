import 'package:flutter/material.dart';
import 'package:quran_app/core/components/base_header.dart';
import 'package:quran_app/core/components/base_home.dart';
import 'package:quran_app/features/another_screen/widgets/another_featuers.dart';
import 'package:quran_app/features/prayer_time/widgets/item_prayer_home.dart';
import 'package:quran_app/features/quran_audio/ui/widgets/surah_audio_only.dart';

class HomeScreenNew extends StatefulWidget {
  const HomeScreenNew({Key? key}) : super(key: key);

  @override
  State<HomeScreenNew> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreenNew> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const BaseHome(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ItemPrayerHome(),
              SurahAudioOnly(),
              BaseHeder(text: "المميزات"),
              AnotherFeatures(),
            ],
          ),
        ),
      ),
    );
  }
}
