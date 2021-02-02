import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/material.dart';
import 'package:mod_profiles/utils/consts.dart';

class FilePickerList extends StatefulWidget {
  final List<String> paths;
  final bool allowEditing;
  final void Function(List<String> paths) onChanged;
  FilePickerList({this.paths, this.onChanged, this.allowEditing = false});

  @override
  _FilePickerListState createState() => _FilePickerListState();
}

class _FilePickerListState extends State<FilePickerList> {
  List<String> paths = [];
  void showFilePicker() async {
    try {
      List<FilePickerCross> files =
          await FilePickerCross.importMultipleFromStorage(
              fileExtension: 'jar', type: FileTypeCross.custom);
      setState(() {
        paths.addAll(files.map((e) => e.path));
        paths = paths.toSet().toList();
        paths.sort();
      });
      widget.onChanged?.call(paths);
    } on FileSelectionCanceledError {}
  }

  @override
  void initState() {
    if (widget.paths != null) paths = [...widget.paths];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
    widget.allowEditing
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                  onPressed: showFilePicker, child: Text("Browse")),
              paths.isNotEmpty
                  ? ElevatedButton(
                      onPressed: () {
                        setState(() => paths.clear());
                        widget.onChanged?.call(paths);
                      },
                      child: Text("Clear all files"),
                      style: ButtonStyle(backgroundColor:
                          MaterialStateColor.resolveWith((states) {
                        if (states.contains(MaterialState.hovered))
                          return Colors.red;
                        if (states.contains(MaterialState.pressed))
                          return Colors.red[700];
                        return Colors.red[600];
                      })),
                    )
                  : Container(),
            ],
          )
        : Container(),
    SizedBox(
      height: 15,
    ),
    paths.length > 0
        ? Container(
          height: MediaQuery.of(context).size.height / 4,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(7)),
            padding: EdgeInsets.all(5),
            child: ListView.builder(
                itemCount: paths.length,
                itemBuilder: (context, i) =>
                    SelectableText(getFileName(paths[i])),
              ))
        : Container(),
        ],
      );
  }
}
