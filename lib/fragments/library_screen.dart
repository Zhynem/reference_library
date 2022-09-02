import 'dart:math';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:reference_library/widgets/playlist_widget.dart';
import 'package:reference_library/widgets/video_card.dart';
import 'package:reference_library/providers/data_provider.dart';
import 'package:reference_library/providers/navigation_provider.dart';

import 'package:reference_library/providers/playlist_provider.dart';

// I think this can be stateless, it'll just rebuild a grid like view of videos based on the data provider
// If a video is clicked then it'll just throw it on the playlist and jump to the playing pane
// ignore: must_be_immutable
class LibraryScreen extends StatelessWidget {
  LibraryScreen({Key? key, required this.videoList}) : super(key: key);

  final ScrollController _sc = ScrollController();
  final int _extraScrollSpeed = 50;

  Map<String, VideoData> videoList;

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
      content: Row(
        children: [
          (context.watch<PlaylistProvider>().playList.isNotEmpty &&
                  context.watch<NavigationProvider>().index == 0)
              ? SizedBox(width: 250, child: PlayListWidget())
              : Container(),
          SizedBox(
            width: (context.watch<PlaylistProvider>().playList.isNotEmpty)
                ? MediaQuery.of(context).size.width - 300
                : MediaQuery.of(context).size.width - 50,
            child: GridView.count(
                controller: _sc,
                crossAxisCount: 5,
                children: videoList.values.map((e) => VideoCard(e)).toList()),
          ),
        ],
      ),
    );
  }
}
