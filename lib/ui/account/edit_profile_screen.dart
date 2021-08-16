import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:itarashop/api/ApiResource.dart';
import 'package:itarashop/common/button_widget.dart';
import '../../app_state.dart';
import '../../app_theme.dart';
import '../../utils/utils.dart';
import 'package:provider/provider.dart';
import '../../model/User.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final List<String> ignoreFields = ["Password", "Address Book"];
  final List<String> dropdownFields = ["male", "female"];
  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  var formData = <String, dynamic>{};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      setState(() {
        var userJson = Provider.of<AppState>(context, listen: false)
            .authenticatedUser!
            .toMap() as Map<String, dynamic>;
        DateTime dateTime = DateTime.parse(userJson['dateOfBirth']);

        final DateFormat formatter = DateFormat('yyyy-MM-dd');
        userJson['dateOfBirth'] = formatter.format(dateTime);

        formData = userJson;
      });
    });
  }

  Future updateUser(Map attributes, String userId) async {
    print('object');
    final ApiResource apiResource = ApiResource();

    setState(() {
      isLoading = true;
    });

    try {
      final user = await apiResource.updateUser(formData, userId);
      setState(() {
        isLoading = false;
      });

      Provider.of<AppState>(context, listen: false).setCurrentUser(user);

      _scaffoldKey.currentState!.showSnackBar(SnackBar(
        content: Text('Profile updated successful'),
      ));

      Future.delayed(Duration(seconds: 2));

      // await Navigator.pop(context);
    } catch (e) {
      // print(e.toString());
      setState(() {
        isLoading = false;
      });
      _scaffoldKey.currentState!.showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    }

    setState(() {
      isLoading = false;
    });
  }

  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    // controller.text = userJson['dateOfBirth'];
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        brightness: Brightness.light,
        title: Text(
          'Edit Account',
          style: Theme.of(context).textTheme.headline6!.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Consumer<AppState>(builder: (context, appState, child) {
        final Map userJson = appState.authenticatedUser!.toMap();
        print(userJson);

        final String? userId = appState.authenticatedUser!.id;
        controller.text = formData['dateOfBirth'] ?? userJson['dateOfBirth'];

        return ListView(
          children: [
            Divider(height: 1),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    for (MapEntry field in User.editables.entries.where(
                      (f) => !ignoreFields.contains(f.key),
                    ))
                      if (field.key == "Gender")
                        SizedBox.shrink()
                      else if (field.key == 'DOB')
                        SizedBox.shrink()
                      else
                        TextFormField(
                          style: textTheme.headline6,
                          keyboardType: field.key == "Phone Number"
                              ? TextInputType.phone
                              : TextInputType.text,
                          initialValue: userJson[field.value],
                          decoration: InputDecoration(
                            labelText: field.key,
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                            hintText: field.key == "Phone Number"
                                ? "e.g 08012345678"
                                : null,
                            contentPadding:
                                EdgeInsets.only(top: 10.0, bottom: 10.0),
                          ),
                          validator: (input) {
                            if (input == null || input.isEmpty) {
                              return field.key + " is required";
                            }

                            if (field.value == "email" &&
                                !input.contains('@')) {
                              return "Invalid email";
                            }
                            return null;
                          },
                          onSaved: (input) => formData[field.value] = input,
                        ),
                    SizedBox(height: 5),
                    TextFormField(
                        controller: controller,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Field cannot be empty';
                          } else {
                            return null;
                          }
                        },
                        style: Theme.of(context).textTheme.headline6,
                        decoration: InputDecoration(
                          labelText: 'Date of Birth',
                          labelStyle: textTheme.headline6!
                              .copyWith(fontWeight: FontWeight.bold),
                          enabledBorder: UnderlineInputBorder(),
                        ),
                        onTap: () async {
                          FocusScope.of(context).unfocus();
                          DateTime? dateTime = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now().subtract(
                              Duration(days: 200000),
                            ),
                            helpText: '',
                            fieldHintText: '',
                            lastDate: DateTime.now(),
                            fieldLabelText: 'Date of Birth',
                            builder: (BuildContext context, Widget? child) {
                              return Theme(
                                data: AppTheme.lightTheme.copyWith(
                                    colorScheme: Theme.of(context)
                                        .colorScheme
                                        .copyWith(),
                                    textTheme: TextTheme(
                                      subtitle1: Theme.of(context)
                                          .textTheme
                                          .headline1!
                                          .copyWith(
                                              color: Colors.black,
                                              fontSize: 20),
                                    )),
                                // data: ThemeData.light().copyWith(
                                //     // primarySwatch:
                                //     //     buttonTextColor, //OK/Cancel button text color
                                //     primaryColor: const Color(
                                //         0xFF4A5BF6), //Head background
                                //     accentColor: const Color(
                                //         0xFF4A5BF6) //selection color
                                //     //dialogBackgroundColor: Colors.white,//Background color
                                //     ),
                                child: child!,
                              );
                            },
                          );

                          if (dateTime != null) {
                            final DateFormat formatter =
                                DateFormat('yyyy-MM-dd');
                            final String formatted = formatter.format(dateTime);

                            print(formatted);
                            setState(() {
                              userJson['dateOfBirth'] = formatted;
                              formData['dateOfBirth'] = formatted;
                              // _dob = formatted;
                            });
                          }
                          // print(_dob);
                        }),
                    SizedBox(
                      height: 5,
                    ),
                    for (MapEntry field in User.editables.entries.where(
                      (f) => !ignoreFields.contains(f.key),
                    ))
                      if (field.key == 'Gender')
                        InputDecorator(
                          decoration: InputDecoration(
                            // contentPadding: EdgeInsets.zero,
                            labelText: field.key,
                            labelStyle: textTheme.headline6!
                                .copyWith(fontWeight: FontWeight.bold),
                            helperText: "",
                          ),
                          isEmpty: userJson[field.value] == null &&
                              formData[field.value] == null &&
                              true,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                style: textTheme.headline6,
                                onChanged: (String? _value) {
                                  formData[field.value] = _value;
                                  setState(() {});
                                },
                                value: formData[field.value] ??
                                    userJson[field.value],
                                isDense: true,
                                items: dropdownFields.map((String value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: Text(ucword(value)),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                    SizedBox(height: 24),
                    InkWell(
                      child: Button(
                        label: 'Apply changes',
                        gradient: "colored",
                        loading: isLoading,
                      ),
                      onTap: () async {
                        // print(formData);
                        // print('Here');
                        FocusScope.of(context).unfocus();

                        if (isLoading == false) {
                          if (_formKey.currentState!
                                  .validate() /*_formKey.currentState.validate() &&
                              formData['Gender'] != null &&
                              formData['Gender'].toString().isEmpty*/
                              ) {
                            _formKey.currentState!.save();
                            print('Here');
                            // setState(() {
                            //   isLoading = true;
                            // });

                            await updateUser(formData, userId!);
                          } else {
                            print('Not here');
                          }
                        }
                      },
                    ),
                    SizedBox(height: 30),
                    InkWell(
                      child: Button(
                        label: 'Change Password',
                        gradient: "colored",
                        // loading: isLoading,
                      ),
                      onTap: () async {
                        await Navigator.pushNamed(
                            context, '/account/change-password');
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
