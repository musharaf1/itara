import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:itarashop/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../app_state.dart';
import '../../common/button_widget.dart';
import '../../common/horizontal_line.dart';
import '../../ui/auth/social_buttons.dart';
import 'header_widget.dart';

import '../../api/ApiResource.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _apiResource = ApiResource();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final dobController = TextEditingController();

  String? _dob;
  String? _firstName;
  String? _lastName;
  String? _email;
  String? _phoneNumber;
  String? _gender;
  String? _password;
  bool _acceptTerms = false;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    dobController.text = _dob ?? '';

    Future _submit(context) {
      setState(() {
        _loading = true;
      });

      return _apiResource.register({
        "firstName": _firstName,
        "lastName": _lastName,
        "email": _email,
        "phoneNumber": _phoneNumber,
        "password": _password,
        "gender": _gender,
        "platform": 0,
        "dateOfBirth": _dob
      }).then((user) async {
        // print("user $user");
        setState(() {
          _loading = false;
        });

        Provider.of<AppState>(context, listen: false).setCurrentUser(user);
        Provider.of<AppState>(context, listen: false)
            .listAddresses(notify: false);

        return Navigator.of(context)
            .pushNamedAndRemoveUntil('/app', (_) => false, arguments: {
          'activeScreen': 0,
        });
      }).catchError((onError) {
        setState(() {
          _loading = false;
        });

        _scaffoldKey.currentState!.showSnackBar(
          SnackBar(
            content: Text(onError.errorMessages[0]),
          ),
        );
      });
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        key: _scaffoldKey,
        body: LayoutBuilder(
          builder: (context, contraints) {
            return AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.light,
              child: CustomScrollView(
                slivers: <Widget>[
                  AuthHeader(
                    headline: 'Tell us about you.',
                    subhead: 'Enjoy the best shopping experience',
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Padding(
                        padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 60.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              TextFormField(
                                style: theme.textTheme.headline6,
                                decoration: InputDecoration(
                                  labelText: "First Name",
                                  enabledBorder: UnderlineInputBorder(),
                                ),
                                validator: (input) =>
                                    input == null || input.isEmpty
                                        ? 'First Name is empty'
                                        : null,
                                onSaved: (input) {
                                  _firstName = input;
                                },
                              ),
                              SizedBox(height: 10.0),
                              TextFormField(
                                style: theme.textTheme.headline6,
                                decoration: InputDecoration(
                                  labelText: "Last Name",
                                  enabledBorder: UnderlineInputBorder(),
                                ),
                                validator: (input) =>
                                    input == null || input.isEmpty
                                        ? 'Last Name is empty'
                                        : null,
                                onSaved: (input) => _lastName = input,
                              ),
                              SizedBox(height: 10.0),
                              TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                style: theme.textTheme.headline6,
                                decoration: InputDecoration(
                                  labelText: "Email",
                                  enabledBorder: UnderlineInputBorder(),
                                ),
                                validator: (input) {
                                  if (input!.isEmpty) return 'Email is empty';
                                  if (!input.contains('@')) {
                                    return 'Provide a valid email';
                                  }
                                  return null;
                                },
                                onSaved: (input) => _email = input,
                              ),
                              SizedBox(height: 10.0),
                              TextFormField(
                                keyboardType: TextInputType.phone,
                                style: theme.textTheme.headline6,
                                decoration: InputDecoration(
                                  labelText: "Phone Number",
                                  enabledBorder: UnderlineInputBorder(),
                                ),
                                validator: (input) =>
                                    input == null || input.isEmpty
                                        ? 'Phone is empty'
                                        : null,
                                onSaved: (input) =>
                                    _phoneNumber = input!.trim(),
                              ),
                              SizedBox(height: 10.0),

                              // SizedBox(height: 4.0),
                              TextFormField(
                                  controller: dobController,
                                  style: theme.textTheme.headline6,
                                  decoration: InputDecoration(
                                    labelText: 'Date of Birth',
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
                                        lastDate: DateTime.now(),
                                        fieldLabelText: 'Date of Birth');

                                    if (dateTime != null) {
                                      final DateFormat formatter =
                                          DateFormat('yyyy-MM-dd');
                                      final String formatted =
                                          formatter.format(dateTime);
                                      print(formatted);
                                      setState(() {
                                        _dob = formatted;
                                      });
                                      print(_dob);
                                    }
                                  }),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                obscureText: true,
                                style: theme.textTheme.headline6,
                                decoration: InputDecoration(
                                  hintText: ('Min. 6 Characters'),
                                  labelText: "Password",
                                  enabledBorder: UnderlineInputBorder(),
                                ),
                                validator: (input) {
                                  if (input == null || input.isEmpty)
                                    return 'Password is empty';
                                  if (input.length < 6) {
                                    return 'Password too short';
                                  }
                                  return null;
                                },
                                onSaved: (input) => _password = input!.trim(),
                              ),
                              SizedBox(height: 5),
                              InputDecorator(
                                decoration: InputDecoration(
                                  labelText: "Gender",
                                  helperText: "",
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(width: 1),
                                  ),
                                ),
                                isEmpty:
                                    _gender == null && _gender == null && true,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      style: theme.textTheme.headline6,
                                      onChanged: (String? _value) {
                                        setState(() {
                                          _gender = _value;
                                        });
                                      },
                                      value: _gender ?? _gender,
                                      isDense: true,
                                      items: ["male", "female"]
                                          .map((String value) {
                                        return DropdownMenuItem(
                                          value: value,
                                          child: Text(ucword(value)),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 30.0),
                              FittedBox(
                                child: Row(
                                  children: <Widget>[
                                    SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: Checkbox(
                                        value: _acceptTerms,
                                        activeColor: Colors.black87,
                                        tristate: false,
                                        onChanged: (input) {
                                          setState(() {
                                            _acceptTerms = input!;
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'I agree to ',
                                            style: theme.textTheme.bodyText2!
                                                .copyWith(
                                              color: Colors.black54,
                                            ),
                                          ),
                                          TextSpan(
                                            text: 'terms of service ',
                                            style: theme.textTheme.bodyText2!
                                                .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primaryVariant,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () async {
                                                final String uri =
                                                    'https://itarashop.ng/privacy-policy';

                                                bool can = await canLaunch(uri);
                                                if (can == true ||
                                                    can == false) {
                                                  await launch(
                                                    uri,
                                                    forceSafariVC: true,
                                                    forceWebView: true,
                                                    enableJavaScript: true,
                                                  );
                                                }
                                              },
                                          ),
                                          TextSpan(
                                            text: 'and ',
                                            style: theme.textTheme.bodyText1!
                                                .copyWith(
                                              color: Colors.black54,
                                            ),
                                          ),
                                          TextSpan(
                                            text: 'privacy policy',
                                            style: theme.textTheme.bodyText2!
                                                .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primaryVariant,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () async {
                                                final String uri =
                                                    'https://itarashop.ng/terms-of-service';

                                                bool can = await canLaunch(uri);
                                                if (can == true ||
                                                    can == false) {
                                                  await launch(
                                                    uri,
                                                    forceSafariVC: true,
                                                    forceWebView: true,
                                                    enableJavaScript: true,
                                                  );
                                                }
                                              },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 30.0),
                              InkWell(
                                onTap: () {
                                  // if (!_acceptTerms) {
                                  //   ScaffoldMessenger.of(context).showSnackBar(
                                  //     SnackBar(
                                  //       content: Text(
                                  //         'You must accept our terms to use our services.',
                                  //       ),
                                  //     ),
                                  //   );
                                  //   return;
                                  // }
                                  // if (_gender == null || _gender.isEmpty) {
                                  //   ScaffoldMessenger.of(context).showSnackBar(
                                  //     SnackBar(
                                  //       content: Text(
                                  //         'Please specify your gender',
                                  //       ),
                                  //     ),
                                  //   );
                                  //   return;
                                  // }

                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    if (_gender == null || _gender!.isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Please specify your gender',
                                          ),
                                        ),
                                      );
                                      return;
                                    }
                                    if (_dob == null || _dob!.isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Please specify your date of birth',
                                          ),
                                        ),
                                      );
                                      return;
                                    }
                                    if (!_acceptTerms) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'You must accept our terms to use our services.',
                                          ),
                                        ),
                                      );
                                      return;
                                    }
                                    _loading == false
                                        ? _submit(context)
                                        : print('loading');
                                  }
                                },
                                child: Button(
                                  label: 'SIGN UP',
                                  gradient: "colored",
                                  loading: _loading,
                                ),
                              ),
                              HorizontalOrLine(height: 60.0, label: "OR"),
                              Text(
                                'Sign up with your social account',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 10),
                              SocialButtons(),
                              SizedBox(height: 30.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Already have an account? ',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                    ),
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/signin');
                                    },
                                    child: Text(
                                      'Sign In',
                                      style:
                                          theme.textTheme.bodyText1!.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primaryVariant,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ]),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
