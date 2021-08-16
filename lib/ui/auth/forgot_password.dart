import 'package:flutter/material.dart';
import '../../common/button_widget.dart';
import '../../model/ApiError.dart';
import '../../api/ApiResource.dart';

class ForgotPassword extends StatefulWidget {
  final bool? loading;
  final Function? onSuccess;
  final Function? onCancel;

  ForgotPassword({
    this.loading,
    this.onSuccess,
    this.onCancel,
  });

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String? _email;
  bool _loading = false;
  ApiError? _errorText;

  final _formKey = GlobalKey<FormState>();
  final _apiResource = ApiResource();

  @override
  Widget build(BuildContext context) {
    bool isKeyboardShown = MediaQuery.of(context).viewInsets.bottom > 0;

    Future _submit() async {
      if (_loading) return;

      FocusScope.of(context).unfocus();

      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();

        setState(() {
          _loading = true;
          _errorText = null;
        });

        return _apiResource
            .forgotPassword({'userName': _email, "platform": 0}).then((data) {
          Navigator.of(context).pop('dialog');
          widget.onSuccess!(_email);
        }).catchError((onError) {
          setState(() {
            _loading = false;
            // _errorText = onError;
          });
        });
      }
    }

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.symmetric(horizontal: 30.0),
      title: Stack(
        children: <Widget>[
          Positioned(
            right: 0,
            top: 0,
            child: IconButton(
              onPressed: () => widget.onCancel!(),
              iconSize: 28,
              icon: Icon(Icons.close, color: Colors.black87),
            ),
          ),
          Align(
            alignment: FractionalOffset.center,
            child: Padding(
              padding: EdgeInsets.only(
                top: isKeyboardShown ? 30 : 60,
                left: 30,
                right: 30,
                bottom: isKeyboardShown ? 30 : 50,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      'Forgot password?',
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(color: Color(0xFF5C5C5C), fontSize: 18),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Please enter your ItaraShop registered email address.',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(color: Colors.black45),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      style: Theme.of(context).textTheme.headline6,
                      autofocus: true,
                      decoration: InputDecoration(
                        labelText: "Email",
                        enabledBorder: UnderlineInputBorder(),
                        helperText: _errorText != null
                            ? _errorText!.errorMessages![0]
                            : '',
                        helperStyle: TextStyle(color: Colors.red),
                      ),
                      validator: (input) {
                        if (input== null || input.isEmpty) {
                          return 'Email/username is empty';
                        }
                        if (!input.contains('@')) {
                          return 'Invalid email address';
                        }
                        return null;
                      },
                      onSaved: (input) => _email = input,
                    ),
                    SizedBox(height: 30),
                    InkWell(
                      onTap: () {
                        if (_loading == false) {
                          _submit();
                        }
                      },
                      child: Button(
                        label: 'RESET MY PASSWORD',
                        gradient: "colored",
                        loading: _loading,
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
