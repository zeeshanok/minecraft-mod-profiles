import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mod_profiles/models/profile.dart';
import 'package:mod_profiles/utils/consts.dart';

class ProfileEditor extends StatefulWidget {
  final void Function(Profile profile) onSubmit;
  final ProfileEditMode mode;
  final Profile profile;
  final Widget icon;
  ProfileEditor({this.onSubmit, @required this.mode, this.profile, this.icon});

  @override
  _ProfileEditorState createState() => _ProfileEditorState();
}

class _ProfileEditorState extends State<ProfileEditor> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();

  List<String> modPaths = [];

  void handleSubmit() {
    if (formKey.currentState.validate()) {
      widget.onSubmit(Profile(nameController.text, modPaths));
    }
  }

  void showFilePicker() async {
    try {
      List<FilePickerCross> files =
          await FilePickerCross.importMultipleFromStorage(
              fileExtension: 'jar', type: FileTypeCross.custom);
      setState(() {
        modPaths.addAll(files.map((e) => e.path));
        modPaths = modPaths.toSet().toList();
        modPaths.sort();
      });
    } on FileSelectionCanceledError {}
  }

  @override
  void initState() {
    if (widget.mode != ProfileEditMode.Create) {
      modPaths = [...widget.profile.mods];
      nameController.text =
          widget.mode != ProfileEditMode.Create ? widget.profile.name : "";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Name",
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: nameController,
                      maxLength: 50,
                      buildCounter: (context,
                              {currentLength, isFocused, maxLength}) =>
                          Text(
                        "$currentLength/$maxLength",
                        style: TextStyle(
                            color: isFocused
                                ? Colors.grey[500]
                                : Colors.transparent),
                      ),
                      decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                          hintText: "Name",
                          focusedBorder: defaultInputBorder.copyWith(
                              borderSide: BorderSide(
                                  color: Theme.of(context).accentColor)),
                          enabledBorder: defaultInputBorder,
                          focusedErrorBorder: defaultInputBorder.copyWith(
                              borderSide: BorderSide(color: Colors.red)),
                          errorBorder: defaultInputBorder.copyWith(
                              borderSide: BorderSide(color: Colors.red))),
                      cursorWidth: 2,
                      cursorColor: Theme.of(context).accentColor,
                      validator: (value) {
                        if (value.isEmpty) return "Name cannot be empty";
                        return null;
                      },
                    ),
                    Text(
                      "Mods",
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                            onPressed: showFilePicker, child: Text("Browse")),
                        if (modPaths.isNotEmpty)
                          OutlinedButton(
                            onPressed: () => setState(() => modPaths.clear()),
                            child: Text("Clear all files"),
                          )
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    if (modPaths.length > 0)
                      Expanded(
                        child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[800]),
                                borderRadius: BorderRadius.circular(7)),
                            padding: EdgeInsets.all(5),
                            child: Scrollbar(
                              isAlwaysShown: true,
                              thickness: 5,
                              radius: Radius.circular(7),
                                                          child: ListView.builder(
                                physics: BouncingScrollPhysics(),
                                itemCount: modPaths.length,
                                itemBuilder: (context, i) => Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      MouseRegion(
                                          cursor: SystemMouseCursors.click,
                                          child: GestureDetector(
                                            child: Icon(
                                              Icons.close,
                                              size: 20,
                                              color: Colors.red,
                                            ),
                                            onTap: () => setState(
                                                () => modPaths.removeAt(i)),
                                          )),
                                      SizedBox(width: 6),
                                      SelectableText(
                                        modPaths[i].split('\\').last,
                                      )
                                    ]),
                              ),
                            )),
                      )
                  ],
                ),
              ),
              if (widget.mode != ProfileEditMode.View) ...[
                SizedBox(
                  height: 15,
                ),
                ElevatedButton.icon(
                  onPressed: modPaths.length > 0 ? handleSubmit : null,
                  icon: SizedBox(
                      width: 30, height: 30, child: widget.icon ?? Container()),
                  label: Text(
                    (widget.mode == ProfileEditMode.Create)
                        ? "Create Profile"
                        : "Edit Profile",
                    style: TextStyle(fontSize: 18),
                  ),
                  style: ButtonStyle(
                      padding: MaterialStateProperty.resolveWith(
                          (states) => EdgeInsets.symmetric(vertical: 16))),
                )
              ]
            ],
          ),
        ));
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }
}
