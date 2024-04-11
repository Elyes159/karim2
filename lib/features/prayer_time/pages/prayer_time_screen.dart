import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/components/shimmer_base.dart';
import 'package:quran_app/core/constant.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/widgets/ui_screen.dart';
import 'package:quran_app/features/home/widgets/next_player.dart';
import 'package:quran_app/features/prayer_time/cubit/prayer_time_cubit.dart';
import 'package:quran_app/features/prayer_time/text/teme_prayer_text.dart';
import 'package:quran_app/features/prayer_time/widgets/item_prayer.dart';
import 'package:timelines/timelines.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PrayerTimeScreen extends StatefulWidget {
  const PrayerTimeScreen({Key? key}) : super(key: key);

  @override
  _PrayerTimeScreenState createState() => _PrayerTimeScreenState();
}

class _PrayerTimeScreenState extends State<PrayerTimeScreen> {
  String selectedDateTime = "";

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BaseUiScreen(
        title: NextTimePrayerRemain(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                BlocBuilder<PrayerTimeCubit, PrayerTimeState>(
                  builder: (context, state) {
                    switch (state.prayerState) {
                      case RequestState.defaults:
                      case RequestState.loading:
                      case RequestState.error:
                        return _ShimmerEffect();

                      case RequestState.success:
                        return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            var data = prayerData[index];
                            return Row(
                              children: [
                                Column(
                                  children: [
                                    index == 0
                                        ? Container()
                                        : SizedBox(
                                            height: 20.0,
                                            child: BaseAnimateFlipList(
                                              index: index,
                                              child: SolidLineConnector(
                                                color: Colors.blue,
                                              ),
                                            ),
                                          ),
                                    nextCurrentPrayer == index
                                        ? BaseAnimateFlipList(
                                            index: index,
                                            child: DotIndicator(
                                              color: Colors.blue,
                                              size: 100,
                                            ),
                                          )
                                        : BaseAnimateFlipList(
                                            index: index,
                                            child: OutlinedDotIndicator(
                                              color: Colors.blue,
                                              size: 20,
                                            ),
                                          ),
                                    index == 4
                                        ? Container()
                                        : BaseAnimateFlipList(
                                            index: index,
                                            child: SizedBox(
                                              height: 20.0,
                                              child: SolidLineConnector(
                                                color: Colors.blue,
                                              ),
                                            ),
                                          ),
                                  ],
                                ).animate().fadeIn(),

                                //
                                Expanded(
                                  child: BaseAnimate(
                                    index: index + 2,
                                    child: ItemPrayer(
                                      nextPray: data,
                                      data: data,
                                      index: index,
                                      nextCurrent: nextCurrentPrayer,
                                    ),
                                  ),
                                )
                              ],
                            );
                          },
                          shrinkWrap: true,
                          itemCount: 6,
                        );
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ShimmerEffect extends StatelessWidget {
  const _ShimmerEffect();

  @override
  Widget build(BuildContext context) {
    return BaseShimmer(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.blue[500],
        ),
      ),
    );
  }
}
