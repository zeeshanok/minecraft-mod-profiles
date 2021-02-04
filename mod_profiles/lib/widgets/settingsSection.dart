import 'package:flutter/material.dart';

class SettingsSection extends StatelessWidget {
  final String heading;
  final Widget child;
  final Key key;
  SettingsSection({@required this.heading, @required this.child, this.key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      // decoration: BoxDecoration(border: Border.all(color: Colors.grey[800])),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            heading,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Divider(),
          child
        ],
      ),
    );
  }
}
