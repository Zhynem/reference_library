import 'package:fluent_ui/fluent_ui.dart';
import 'package:reference_library/providers/data_provider.dart';

class EditingProvider with ChangeNotifier {
  VideoData? _videoData;
  List<TimestampData>? _timestamps;
  List<String>? _tags;
  Map<String, dynamic>? _seriesData;

  void resetSeriesData() {
    _seriesData = {};
    _seriesData!["title"] = "";
    _seriesData!["videos"] = <VideoData>[];
  }

  void setSeriesData(Map<String, dynamic> sd) {
    _seriesData = sd;
    notifyListeners();
  }

  void removeSeriesVideo(VideoData d) {
    List<VideoData> v = _seriesData!["videos"];
    v.remove(d);
    notifyListeners();
  }

  void addSeriesVideo(VideoData d) {
    List<VideoData> v = _seriesData!["videos"];
    v.add(d);
    notifyListeners();
  }

  void moveSeriesVideo(int oldPos, int newPos) {
    List<VideoData> v = _seriesData!["videos"];
    VideoData d = v.removeAt(oldPos);
    v.insert(newPos, d);
    notifyListeners();
  }

  void setVideoData(VideoData d) {
    _videoData = d;
    notifyListeners();
  }

  void setTimestamps(List<TimestampData> t) {
    _timestamps = [...t];
    notifyListeners();
  }

  void setTags(List<String> t) {
    _tags = [...t];
    notifyListeners();
  }

  void updateTimestamp(TimestampData oldT, TimestampData newT) {
    if (_timestamps != null) {
      int i = _timestamps!.indexOf(oldT);
      if (i != -1) {
        _timestamps![i] = newT;
      }
    }
    notifyListeners();
  }

  void removeTimestamp(TimestampData t) {
    if (_timestamps != null) {
      _timestamps!.remove(t);
    }
    notifyListeners();
  }

  void addTimestamp(TimestampData t) {
    if (_timestamps != null) {
      _timestamps!.add(t);
    } else {
      _timestamps = [t];
    }

    notifyListeners();
  }

  void addTag(String t) {
    if (_tags != null) {
      if (!_tags!.contains(t)) {
        _tags!.add(t);
        notifyListeners();
      }
    }
  }

  // Getters
  VideoData? get videoData => _videoData;
  List<TimestampData>? get timestamps => _timestamps;
  List<String>? get tags => _tags;
  Map<String, dynamic>? get seriesData => _seriesData;
}
