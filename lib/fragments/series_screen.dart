// Screen to show the different 'series' or related videos, like the FPGA or Basic Electronics series of videos
// essentially youtube playlists... :) I suppose here is where the complete info could be useful..
//  click in to a series and then the video cards of complete videos will be green or something
// maybe have a gridview of the series, then use the drill in page transition to get to get to the video list for that series?
// https://github.com/bdlukaa/fluent_ui#page-transitions ?? Drill In

// Here's an example from main of using the navigationbody and transitionBuilder to customize the transition between navigation panes for the main app
// content: NavigationBody(
//     animationDuration: const Duration(milliseconds: 450),
//     transitionBuilder: (Widget c, Animation<double> a) =>
//         EntrancePageTransition(
//           animation: a,
//           vertical: false,
//           reverse: true,
//           startFrom: 0.15,
//           child: c,
//         ),

import 'dart:math';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:reference_library/providers/editing_provider.dart';
import 'package:reference_library/widgets/playlist_widget.dart';
import 'package:reference_library/widgets/series_card.dart';
import 'package:reference_library/providers/data_provider.dart';
import 'package:reference_library/providers/navigation_provider.dart';

import 'package:reference_library/providers/playlist_provider.dart';
import 'package:reference_library/widgets/series_edit.dart';

// All the different settings, series, tags, add new videos, edit data on existing ones?
class SeriesScreen extends StatelessWidget {
  SeriesScreen({Key? key}) : super(key: key);

  final ScrollController _sc = ScrollController();
  final int _extraScrollSpeed = 50;

  List<Widget> buildResults(List<String> seriesTitles) {
    List<Widget> r = [];
    for (String t in seriesTitles) {
      r.add(SeriesCard(t));
    }
    return r;
  }

  @override
  Widget build(BuildContext context) {
    _sc.addListener(() {
      ScrollDirection scrollDirection = _sc.position.userScrollDirection;
      if (scrollDirection != ScrollDirection.idle) {
        double scrollEnd = _sc.offset +
            (scrollDirection == ScrollDirection.reverse
                ? _extraScrollSpeed
                : -_extraScrollSpeed);
        scrollEnd = min(_sc.position.maxScrollExtent,
            max(_sc.position.minScrollExtent, scrollEnd));
        _sc.jumpTo(scrollEnd);
      }
    });

    return ScaffoldPage(
      content: Stack(
        children: [
          Row(
            children: [
              (context.watch<PlaylistProvider>().playList.isNotEmpty &&
                      context.watch<NavigationProvider>().index == 1)
                  ? SizedBox(width: 250, child: PlayListWidget())
                  : Container(),
              SizedBox(
                width: (context.watch<PlaylistProvider>().playList.isNotEmpty)
                    ? MediaQuery.of(context).size.width - 300
                    : MediaQuery.of(context).size.width - 50,
                child: GridView.count(
                    controller: _sc,
                    crossAxisCount: 5,
                    children:
                        buildResults(context.watch<DataProvider>().series)),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                onPressed: () {
                  // New Series Prompt
                  context.read<EditingProvider>().resetSeriesData();
                  showDialog(
                      context: context,
                      builder: (context) => SeriesEditDialog(
                            title: "New Series Information",
                            origName: "",
                            origVideos: const <VideoData>[],
                            newSeries: true,
                          ));
                },
                icon: const Icon(
                  FluentIcons.circle_addition,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
