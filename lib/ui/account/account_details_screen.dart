import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:itarashop/common/progressbar_circular.dart';
import 'package:itarashop/model/User.dart';
import 'package:itarashop/utils/utils.dart';
import 'package:provider/provider.dart';
import '../../app_state.dart';
import '../../app_theme.dart';
import '../../common/profile_avatar.dart';

class AccountDetailsScreen extends StatefulWidget {
  @override
  _AccountDetailsScreenState createState() => _AccountDetailsScreenState();
}

class _AccountDetailsScreenState extends State<AccountDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    bool isUploading = false;
    String uploadStatus;
    final picker = ImagePicker();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Account Details',
          style: Theme.of(context).textTheme.headline6!.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),

        actions: [
          InkWell(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: Text(
                  'Edit',
                  style: TextStyle(
                    color: colorScheme.primaryVariant,
                  ),
                ),
              ),
            ),
            onTap: () async {
              await Navigator.pushNamed(context, '/account/edit-profile');
            },
          ),
        ],
        brightness: Brightness.light,
        // centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Consumer<AppState>(builder: (context, appstate, child) {
        final User? user = appstate.authenticatedUser;
        final Map userJson = user!.toMap();
        DateTime dateTime = DateTime.parse(userJson['dateOfBirth']);

        final DateFormat formatter = DateFormat('yyyy-MM-dd');
        userJson['dateOfBirth'] = formatter.format(dateTime);
        print(User.editables.entries);

        return StatefulBuilder(builder: (context, setState) {
          return ListView(
            padding: EdgeInsets.only(bottom: 56.0),
            children: [
              Divider(height: 1),
              SizedBox(height: 24),
              InkWell(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ProfileAvatar(profilePictureUrl: user.profilePictureUrl),
                    SizedBox(height: 16),
                    if (isUploading)
                      SizedBox(
                        height: 18,
                        width: 18,
                        child: ProgressbarCircular(),
                      )
                    else
                      Text(
                        'Tap to change picture',
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                      )
                  ],
                ),
                onTap: () async {
                  try {
                    PickedFile? image = await picker.getImage(
                      source: ImageSource.gallery,
                    );

                    if (image != null) {
                      isUploading = true;
                      uploadStatus = "Tap to change picture";
                      setState(() {});

                      String base64Image =
                          await base64ImageFromPath(image.path, image);

                      await Provider.of<AppState>(context, listen: false)
                          .updateProfilePictureUrl(base64Image);

                      isUploading = false;
                      uploadStatus = "Tap to change picture";
                      setState(() {});
                    }
                  } catch (e) {
                    // TODO: handle error
                    isUploading = false;
                    uploadStatus = e.toString();
                    setState(() {});
                  }

                  //
                },
              ),
              SizedBox(height: 40.0),
              Divider(height: 0),
              for (MapEntry field in User.editables.entries)
                if (field.key == "Password" && !user.isSocialSignUp!)
                  Container()
                else if (field.key == "Address Book")
                  Column(
                    children: [
                      ListTile(
                        onTap: () async {
                          await Navigator.pushNamed(
                            context,
                            '/account/address-book',
                            arguments: {'userId': user.id},
                          );
                        },
                        contentPadding:
                            EdgeInsets.only(left: 24.0, right: 18.0),
                        title: Text(
                          field.key,
                          style: textTheme.bodyText1,
                        ),
                        trailing: FittedBox(
                          child: Row(
                            children: [
                              Text(
                                'View all',
                                style: textTheme.bodyText2!.copyWith(
                                  color: AppTheme.accents['textMuted'],
                                ),
                              ),
                              Icon(
                                Icons.chevron_right,
                                size: 24,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 24.0),
                        title: Text(
                          field.key,
                          style: textTheme.bodyText1,
                        ),
                        trailing: Text(
                          userJson[field.value] ?? formatHiddenFields(field),
                          style: textTheme.bodyText2!.copyWith(
                            color: AppTheme.accents['textMuted'],
                          ),
                        ),
                      ),
                      Divider(height: 1),
                    ],
                  ),
              if (user.isSocialSignUp!)
                Column(
                  children: [
                    Divider(height: 1),
                    SizedBox(height: 24),
                    InkWell(
                      child: Center(
                        child: Text(
                          'Change Password',
                          style: TextStyle(
                            color: colorScheme.primaryVariant,
                          ),
                        ),
                      ),
                      onTap: () async {
                        await Navigator.pushNamed(
                          context,
                          '/account/change-password',
                        );
                      },
                    ),
                  ],
                )
            ],
          );
        });
      }),
    );
  }
}
