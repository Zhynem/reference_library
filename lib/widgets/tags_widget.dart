import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:reference_library/providers/data_provider.dart';
import 'package:reference_library/providers/navigation_provider.dart';
import 'package:reference_library/providers/search_provider.dart';

// ignore: must_be_immutable
class TagList extends StatefulWidget {
  TagList({Key? key, required this.selectedTags, required this.editing})
      : super(key: key);

  List<String> selectedTags;
  bool editing;

  @override
  State<TagList> createState() => TagListState();
}

class TagListState extends State<TagList> {
  List<String> _tags = [];
  // Stores the state of if a tag is selected or not for visual updating
  final Map<String, bool> _chipSelect = {};

  // Function called when a chip is selected, it updates the visual state and filter list
  void chipSelectCallback(String text, bool selected, BuildContext context) {
    setState(() {
      bool updatedVal = selected ? false : true;
      _chipSelect[text] = updatedVal;
      if (updatedVal) {
        widget.selectedTags.add(text);

        // If search screen, use search provider
        if (context.read<NavigationProvider>().isSearch) {
          context.read<SearchProvider>().addTag(text, context);
        }
      } else {
        widget.selectedTags.removeWhere((element) => element == text);

        // If search screen, use search provider
        if (context.read<NavigationProvider>().isSearch) {
          context.read<SearchProvider>().removeTag(text, context);
        }
      }
    });
  }

  // Builds the list of all tag chips
  List<Widget> buildChips(List<String> tags, BuildContext context) {
    // If there's no values saved yet set them all to unselected
    bool init = false;
    if (_chipSelect.isEmpty && !widget.editing) {
      setState(() {
        init = true;
      });
    }
    List<Widget> r = [];
    // For each tag create a chip with its text and selected state, and the function to call on a press
    for (String t in tags) {
      bool? savedVal = false;
      if (_chipSelect.containsKey(t)) {
        savedVal = _chipSelect[t];
      }
      bool selected;
      if (init) {
        if (widget.selectedTags.contains(t)) {
          selected = true;
        } else {
          selected = false;
        }
      } else {
        if (widget.selectedTags.contains(t)) {
          selected = true;
        } else {
          selected = savedVal!;
        }
      }
      setState(() {
        _chipSelect[t] = selected;
      });
      r.add(Padding(
        padding: const EdgeInsets.all(4.0),
        child: TagChip(t, selected, chipSelectCallback),
      ));
    }
    return r;
  }

  @override
  Widget build(BuildContext context) {
    _tags = context.watch<DataProvider>().tags;

    return Wrap(
      children: buildChips(_tags, context),
    );
  }
}

// Custom chip to handle displaying a selected chip
class TagChip extends StatelessWidget {
  const TagChip(this.text, this.selected, this.callback, {Key? key})
      : super(key: key);
  final String text;
  final bool selected;
  final Function callback;
  @override
  Widget build(BuildContext context) {
    return selected
        ? Chip.selected(
            text: Text(
              text,
            ),
            onPressed: () {
              callback(text, selected, context);
            },
          )
        : Chip(
            text: Text(
              text,
            ),
            onPressed: () {
              callback(text, selected, context);
            },
          );
  }
}
