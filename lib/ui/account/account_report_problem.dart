import 'package:flutter/material.dart';
import 'package:itarashop/api/ApiResource.dart';
import 'package:itarashop/common/button_widget.dart';
import 'package:itarashop/common/custom_alert.dart';

class AccountReportProblemScreen extends StatefulWidget {
  @override
  _AccountReportProblemScreenState createState() =>
      _AccountReportProblemScreenState();
}

class _AccountReportProblemScreenState
    extends State<AccountReportProblemScreen> {
  final ApiResource _apiResource = ApiResource();
  String? _chosenValue;

  GlobalKey<FormState>? _formKey;
  Map<String, dynamic> data = {};
  List<String> fields = ["Name", "Email", "Message"];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
  }

  Future<void> submit() async {
    if (_formKey!.currentState!.validate()) {
      _formKey!.currentState!.save();

      try {
        this.setState(() {
          loading = true;
        });

        // call api endpoint
        final doc = await _apiResource.submitComplaint(
          title: 'App Support',
          body: data['message'],
          fullname: data['name'],
          email: data['email'],
        );

        // close
        this.setState(() {
          loading = false;
        });

        // notify
        await showDialog(
          context: context,
          builder: (context) => CustomAlert(
            title: 'Report Submitted',
            desc: doc['data'],
            onCancel: () {
              Navigator.pop(context);
            },
          ),
        );
      } catch (e) {
        print(e);
        this.setState(() {
          loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('Report a problem', style: Theme.of(context).textTheme.headline6!.copyWith(
                fontWeight: FontWeight.w500,
              ),),
      ),
      body: Column(
        children: [
          Divider(height: 1.0),
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Text(
                    'Kindly fill in the form below with the issues you experienced.',
                    style: theme.subtitle2,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  ...List.generate(fields.length, (int i) {
                    final String field = fields[i];
                    final String name =
                        fields[i].replaceAll(" ", "-").toLowerCase();
                    final bool isTextArea = name == "message";

                    return Container(
                      height: isTextArea ? 100 : null, // auto-height,
                      margin: EdgeInsets.only(bottom: 8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: TextFormField(
                          expands: isTextArea,
                          maxLines: isTextArea ? null : 1,
                          style: theme.headline6,
                          decoration: InputDecoration(
                            hintText: "Add your " + name,
                            labelText: field,
                            labelStyle: theme.subtitle2!.copyWith(
                              color:
                                  Theme.of(context).colorScheme.primaryVariant,
                            ),
                            filled: true,
                            errorBorder: InputBorder.none,
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return name + " is required";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            this.setState(() {
                              data[name] = value;
                            });
                          },
                        ),
                      ),
                    );
                  }),
                  SizedBox(height: 10),
                  InputDecorator(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 10),
                      labelText: 'Problem Type',
                      labelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.primaryVariant,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      helperText: "",
                      fillColor: Colors.grey[200],
                      filled: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                    isEmpty: _chosenValue == null || _chosenValue!.isEmpty,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          style: Theme.of(context).textTheme.subtitle2,
                          onChanged: (String? _value) {
                            // formData[field.value] = _value;
                            // setState(() {});
                            setState(() {
                              _chosenValue = _value;
                            });
                          },
                          value: _chosenValue,
                          isDense: true,
                          items: <String>[
                            'Authentication Issues',
                            'My order didn\'t arrive',
                            'Problem with an order/product',
                            'Others'
                          ].map((String value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(value,
                                  style: Theme.of(context).textTheme.subtitle2),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      if (loading == false) {
                        this.submit();
                      }
                    },
                    child: Button(
                      gradient: "colored",
                      label: 'Submit',
                      loading: loading,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
