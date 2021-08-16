import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app_theme.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  buildHeader(constraints, theme),
                  Padding(
                    padding: EdgeInsets.all(30.0),
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: "Jide",
                            labelText: "First Name",
                          ),
                        ),
                        SizedBox(height: 40.0),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: "Taiwo",
                            labelText: "Last Name",
                          ),
                        ),
                        SizedBox(height: 40.0),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: "Jide",
                            labelText: "First Name",
                          ),
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: "Jide",
                            labelText: "First Name",
                          ),
                        ),
                        SizedBox(height: 40.0),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: "Taiwo",
                            labelText: "Last Name",
                          ),
                        ),
                        SizedBox(height: 40.0),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: "Jide",
                            labelText: "First Name",
                          ),
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: "Jide",
                            labelText: "First Name",
                          ),
                        ),
                        SizedBox(height: 40.0),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: "Taiwo",
                            labelText: "Last Name",
                          ),
                        ),
                        SizedBox(height: 40.0),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: "Jide",
                            labelText: "First Name",
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildHeader(BoxConstraints constraints, ThemeData theme) {
    return Container(
      height: constraints.maxHeight * 0.3,
      padding: EdgeInsets.only(top: 40, left: 20, right: 20),
      decoration: BoxDecoration(
        gradient: AppTheme.gradients["colored-inverse"],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 22,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  'Back',
                  style: theme.textTheme.bodyText1!.copyWith(
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Tell us about you.',
                  style: theme.textTheme.headline5!.copyWith(
                    fontFamily: "Roboto",
                  ),
                ),
                SizedBox(height: 5.0),
                Text(
                  'Let\'s make your shopping easy.',
                  style: theme.textTheme.bodyText2!.copyWith(
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
