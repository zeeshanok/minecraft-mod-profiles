import 'package:flutter/material.dart';
import 'package:mod_profiles/models/profile.dart';
import 'package:mod_profiles/models/profileModel.dart';
import 'package:mod_profiles/pages/editProfile.dart';
import 'package:mod_profiles/utils/consts.dart';
import 'package:mod_profiles/widgets/confirmDialog.dart';
import 'package:mod_profiles/widgets/shortenedList.dart';
import 'package:provider/provider.dart';

class ProfileWidget extends StatelessWidget {
  final Profile profile;
  final int index;
  final void Function(BuildContext context) onActivate;

  ProfileWidget(this.profile, this.index, {this.onActivate});

  void handleActivate(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => ConfirmDialog(
              onSubmit: (response) {
                if (response) onActivate(context);
              },
              title: Text("Are you sure you want to activate this profile?"),
              content: Text(
                  "This will clear your mods folder and copy your profile's mods into your mods folder."),
            ));
  }

  void handleDelete(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => ConfirmDialog(
              onSubmit: (response) {
                if (response)
                  Provider.of<ProfileModel>(context, listen: false)
                      .removeProfile(index);
              },
              title: Text("Are you sure you want to delete this profile?"),
              content: SizedBox.shrink(),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            border:
                Border.all(color: Theme.of(context).accentColor, width: 1.5),
            borderRadius: BorderRadius.circular(7)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  profile.name,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                ),
                // SizedBox.expand(),
                ShortenedList(
                  builder: (context, i) {
                    var mods = profile.modsSorted;
                    return Text(
                      getFileName(mods[i]
                          .substring(0, mods[i].length - 4)
                          .replaceAll(RegExp(r"[-_]+"), " ")),
                      style: TextStyle(color: Colors.grey[300]),
                    );
                  },
                  itemCount: profile.mods.length,
                  maxItems: 0,
                  shortenedText: 'Show mods',
                  expandedText: 'Hide',
                )
              ],
            ),
            Column(
              children: [
                ElevatedButton(
                    onPressed: () => handleActivate(context),
                    child: Text("Activate")),
                SizedBox(
                  height: 2,
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: Colors.grey[100],
                        size: 20,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(createRoute(EditProfilePage(
                          profile: profile,
                          index: index,
                        )));
                      },
                      splashRadius: 16,
                      visualDensity: VisualDensity.compact,
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Colors.grey[100],
                          size: 20,
                        ),
                        onPressed: () {
                          handleDelete(context);
                        },
                        splashRadius: 16,
                        visualDensity: VisualDensity.compact)
                  ],
                )
              ],
            )
          ],
        ));
  }
}
