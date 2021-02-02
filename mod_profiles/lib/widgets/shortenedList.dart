import 'package:flutter/material.dart';

class ShortenedList extends StatefulWidget {
  final Widget Function(BuildContext, int) builder;
  final int maxItems;
  final int itemCount;
  final String shortenedText;
  final String expandedText;

  @override
  _ShortenedListState createState() => _ShortenedListState();

  ShortenedList(
      {@required this.builder,
      @required this.maxItems,
      @required this.itemCount,
      this.shortenedText = 'Show more',
      this.expandedText = 'Collapse'});
}

class _ShortenedListState extends State<ShortenedList> {
  bool shortened = true;
  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];
    int listLength = widget.maxItems < widget.itemCount
        ? (shortened ? widget.maxItems : widget.itemCount)
        : widget.itemCount;
    for (int i = 0; i < listLength; i++) {
      widgets.add(widget.builder(context, i));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ...widgets,
        widget.maxItems < widget.itemCount
            ? TextButton(
                onPressed: () => setState(() => shortened = !shortened),
                child: Text(
                    shortened ? widget.shortenedText : widget.expandedText),
                style: ButtonStyle(visualDensity: VisualDensity.compact),
              )
            : Container()
      ],
    );
  }
}
