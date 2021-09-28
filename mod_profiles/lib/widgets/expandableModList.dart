import 'package:flutter/material.dart';

class ExpandableWidget extends StatefulWidget {
  const ExpandableWidget(
      {required this.child,
      required this.animationCurve,
      required this.animationDuration,
      required this.showText,
      Key? key})
      : super(key: key);

  final Duration animationDuration;
  final Curve animationCurve;
  final Widget child;
  final String showText;

  @override
  _ExpandableWidgetState createState() => _ExpandableWidgetState();
}

class _ExpandableWidgetState extends State<ExpandableWidget>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: widget.animationDuration);
    _animation =
        CurvedAnimation(parent: _controller, curve: widget.animationCurve);
    _runExpand();
  }

  void _runExpand() {
    if (_expanded) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  void _toggleExpand() async {
    setState(() {
      _expanded = !_expanded;
    });
    _runExpand();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton(
            style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.zero)),
            onPressed: _toggleExpand,
            child: Row(children: [
              RotationTransition(
                  turns: _animation.drive(Tween(begin: 0, end: 0.5)),
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 20,
                  )),
              Text((_expanded ? "Hide" : "Show") + " ${widget.showText}"),
            ])),
        SizeTransition(
            axis: Axis.vertical,
            axisAlignment: 1.0,
            sizeFactor: _animation,
            child: widget.child)
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
