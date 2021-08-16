import 'package:flutter/material.dart';
import 'package:itarashop/api/Client.dart';
import 'package:itarashop/common/profile_avatar.dart';
import '../model/User.dart';
import 'small_button.dart';

class ProfileMeta extends StatelessWidget {
  final User? user;

  ProfileMeta({@required this.user});
  @override
  Widget build(BuildContext context) {
    final ThemeData t = Theme.of(context);

    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ProfileAvatar(profilePictureUrl: user!.profilePictureUrl),
          SizedBox(
            width: 16.0,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  user!.fullname ?? '',
                  style: t.textTheme.headline6!.copyWith(
                    fontSize: 20.0,
                    height: 1.5,
                  ),
                ),
                Text(user!.email ??''),
                SizedBox(height: 10.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).colorScheme.primaryVariant,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)
                    )
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/account/edit-profile');
                    // final Client client = Client();
                    // client.getToken();
                  },
                  child: Text('EDIT ACCOUNT'),
                )
                // SizedBox(
                //   width: 150,
                //   child: SmallButton(
                //     title: 'EDIT ACCOUNT',
                //     color: Theme.of(context).colorScheme.primaryVariant,
                //     borderRadius: 6.0,
                //     onTap: () {
                //       Navigator.pushNamed(context, '/account/edit-profile');
                //     },
                //   ),
                // ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
