import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:itarashop/api/err.dart';
import 'package:itarashop/model/Category.dart';
import 'package:provider/provider.dart';
import '../../app_state.dart';
import '../../common/button_widget.dart';
import '../../common/horizontal_line.dart';
import '../../ui/auth/social_buttons.dart';
import 'forgot_password.dart';
import 'header_widget.dart';

import '../../api/ApiResource.dart';

enum FlowType { Normal, DeepLink }

class SigninScreen extends StatefulWidget {
  final FlowType flowType;
  final String? deepLinkSubCategory;
  final String? categoryTitle;

  const SigninScreen({
    Key? key,
    this.flowType = FlowType.Normal,
    this.deepLinkSubCategory,
    this.categoryTitle,
  }) : super(key: key);
  @override
  _SigninScreenState createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final _formKey = GlobalKey<FormState>();
  final _apiResource = ApiResource();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String? _email;
  String? _password;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Future _submit(context) {
      setState(() {
        _loading = true;
      });

      return _apiResource.signIn({
        "username": _email,
        "password": _password,
      }).then((user) async {
        setState(() {
          _loading = false;
        });
        Provider.of<AppState>(context, listen: false)
            .setCurrentUser(user);
         Provider.of<AppState>(context, listen: false).listAddresses(notify: false);

        if (widget.flowType == FlowType.Normal) {
          return Get.offNamedUntil('/app', (route) => false, arguments: {
            'activeScreen': 0,
          });
        } else {
          // Navigate to category screen
          return Get.offNamedUntil('/subcategory', (route) => false,
              arguments: {
                "deepLinkSubCat": widget.deepLinkSubCategory,
                "categoryTitle": widget.categoryTitle,
                "flowType": FlowType.DeepLink
              });
        }
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

    return Scaffold(
      key: _scaffoldKey,
      body: LayoutBuilder(
        builder: (rootContext, contraints) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light,
            child: CustomScrollView(
              slivers: <Widget>[
                AuthHeader(
                  headline: 'Sign in.',
                  subhead: 'Shop the best African fashion and beauty brands',
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
                              keyboardType: TextInputType.emailAddress,
                              style: theme.textTheme.headline6,
                              decoration: InputDecoration(
                                labelText: "Email",
                                enabledBorder: UnderlineInputBorder(),
                              ),
                              validator: (input) {
                                if (input == null ||input.isEmpty) {
                                  return 'Email/username is empty';
                                }
                                if (!input.contains('@')) {
                                  return 'Provide a valid email';
                                }
                                return null;
                              },
                              onSaved: (input) => _email = input,
                            ),
                            SizedBox(height: 10.0),
                            TextFormField(
                              obscureText: true,
                              style: theme.textTheme.headline6,
                              decoration: InputDecoration(
                                labelText: "Password",
                                enabledBorder: UnderlineInputBorder(),
                              ),
                              validator: (input) {
                                if (input == null || input.isEmpty) return 'Password is empty';
                                return null;
                              },
                              onSaved: (input) => _password = input!.trim(),
                            ),
                            SizedBox(height: 30.0),
                            Align(
                              alignment: Alignment.centerRight,
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Forgot password?',
                                      style: theme.textTheme.bodyText2!.copyWith(
                                        color: Colors.black54,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' Reset',
                                      style: theme.textTheme.bodyText1!.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primaryVariant,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          showDialog(
                                              context: context,
                                              barrierDismissible: true,
                                              builder: (context) {
                                                return StatefulBuilder(
                                                  builder: (context, setState) {
                                                    return ForgotPassword(
                                                      onSuccess: (resetEmail) {
                                                        return resetSuccess(
                                                            rootContext,
                                                            resetEmail);
                                                      },
                                                      onCancel: () {
                                                        Navigator.of(context)
                                                            .pop('dialog');
                                                      },
                                                    );
                                                  },
                                                );
                                              });
                                          // Navigator.pushNamed(context, '/')
                                        },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 30.0),
                            InkWell(
                              onTap: () {
                                
                                // ShowErrors.showErrors('message');
                                // if (_loading) return;

                                FocusScope.of(context).unfocus();

                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  _loading == false
                                      ? _submit(context)
                                      : print('loading');
                                }
                              },
                              child: Button(
                                label: 'SIGN IN',
                                gradient: "colored",
                                loading: _loading,
                                disabled: _loading
                              ),
                            ),
                            HorizontalOrLine(height: 60.0, label: "OR"),
                            Text(
                              'Login with your social account',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 10),
                            SocialButtons(
                              flowType: widget.flowType,
                              deepLinkSubCategory: widget.deepLinkSubCategory!,
                              categoryTitle: widget.categoryTitle!,
                              func: (bool value) {
                                setState(() {
                                  _loading = value;
                                });
                              },
                            ),
                            SizedBox(height: 30.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'New to ItaraShop? ',
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
                                    Navigator.pushNamed(context, '/register');
                                  },
                                  child: Text(
                                    'Sign Up',
                                    style: theme.textTheme.bodyText1!.copyWith(
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
    );
  }

  void resetSuccess(BuildContext context, String resetEmail) {
    Scaffold.of(context).showBottomSheet(
      (context) {
        return SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 20.0,
              horizontal: 30.0,
            ),
            child: Text(
              'Reset link has been sent to $resetEmail',
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: Colors.white),
            ),
          ),
        );
      },
      backgroundColor: Theme.of(context).colorScheme.primary,
    );
  }
}
