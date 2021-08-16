import 'package:flutter/material.dart';
import 'package:itarashop/api/ApiResource.dart';
import 'package:itarashop/api/err.dart';
import 'package:itarashop/common/button_widget.dart';

class AccountChangePassword extends StatefulWidget {
  @override
  _AccountChangePasswordState createState() => _AccountChangePasswordState();
}

class _AccountChangePasswordState extends State<AccountChangePassword> {
  bool isLoading = false;
  final oldPassword = TextEditingController();
  final newPassword = TextEditingController();
  final newPassword2 = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool _obscure1 = true;
  bool _obscure2 = true;
  bool _obscure3 = true;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          title: Text(
            'Change Password',
            style: Theme.of(context).textTheme.headline6!.copyWith(
                fontWeight: FontWeight.w500,
              ),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Form(
          key: formKey,
          child: ListView(
            children: [
              Divider(height: 2),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28.0),
                child: TextFormField(
                  obscureText: _obscure1,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                    color: Colors.black87,
                  ),
                  controller: oldPassword,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Field cannot be empty';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: _obscure1 == true
                            ? Icon(Icons.visibility)
                            : Icon(Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _obscure1 = !_obscure1;
                          });
                        },
                      ),
                      contentPadding: EdgeInsets.only(left: 8),
                      hintText: 'Old Password',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange),
                      ),
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(),
                      disabledBorder: OutlineInputBorder(),
                      errorBorder: OutlineInputBorder()),
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28.0),
                child: TextFormField(
                  obscureText: _obscure2,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                    color: Colors.black87,
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Field cannot be empty';
                    }
                    return null;
                  },
                  controller: newPassword,
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: _obscure2 == true
                            ? Icon(Icons.visibility)
                            : Icon(Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _obscure2 = !_obscure2;
                          });
                        },
                      ),
                      contentPadding: EdgeInsets.only(left: 8),
                      hintText: 'New Password',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange),
                      ),
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(),
                      disabledBorder: OutlineInputBorder(),
                      errorBorder: OutlineInputBorder()),
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28.0),
                child: TextFormField(
                  obscureText: _obscure3,
                  controller: newPassword2,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                    color: Colors.black87,
                  ),
                  validator: (String? value) {
                    if (value == null ||
                        value.toString().toLowerCase() !=
                            newPassword.text.toLowerCase()) {
                      return 'Passwords does not match';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: _obscure3 == true
                            ? Icon(Icons.visibility)
                            : Icon(Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _obscure3 = !_obscure3;
                          });
                        },
                      ),
                      contentPadding: EdgeInsets.only(left: 8),
                      hintText: 'Re-enter New Password',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange),
                      ),
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(),
                      disabledBorder: OutlineInputBorder(),
                      errorBorder: OutlineInputBorder()),
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28.0),
                child: InkWell(
                  child: Button(
                    label: 'Apply changes',
                    gradient: "colored",
                    loading: isLoading,
                  ),
                  onTap: () async {
                    FocusScope.of(context).unfocus();
                    final _formKey = formKey.currentState;

                    if (isLoading == false) {
                      if (_formKey!.validate()) {
                        _formKey.save();
                        setState(() {
                          isLoading = true;
                        });

                        try {
                          var data = await ApiResource()
                              .changePassword(
                                  oldPassword.text, newPassword.text)
                              .then((value) {
                            setState(() {
                              isLoading = false;
                            });
                          });

                          ShowErrors.showErrors(
                              'Your password was updated successfully');
                          oldPassword.clear();
                          newPassword.clear();
                          newPassword2.clear();
                        } catch (e) {
                          setState(() {
                            isLoading = false;
                          });
                        }
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
