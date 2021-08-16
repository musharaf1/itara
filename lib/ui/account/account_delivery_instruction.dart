import 'package:flutter/material.dart';
import 'package:itarashop/api/ApiResource.dart';
import 'package:provider/provider.dart';
import '../../app_state.dart';
import '../../common/button_widget.dart';

class DeliveryInstruction extends StatefulWidget {
  final Map? address;
  final String? userId;

  DeliveryInstruction({@required this.address, @required this.userId});

  @override
  _DeliveryInstructionState createState() => _DeliveryInstructionState();
}

class _DeliveryInstructionState extends State<DeliveryInstruction> {
  bool isLoading = false;
  Map? formData;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ApiResource apiResource = ApiResource();

  @override
  void initState() {
    super.initState();
    final List<String>? names = widget.address!['contactName'].toString().split(' ');
    formData = <String, dynamic>{
      ...?widget.address,
      'firstName': names![0],
      'lastName': names[1],
      'country': 'Nigeria',
      'politicalState': widget.address!['city']['politicalState']['name'],
      'citySlug': widget.address!['city']['slug'],
    };
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          title: Text(
            'Delivery Instruction',
           style: Theme.of(context).textTheme.headline6!.copyWith(
                fontWeight: FontWeight.w500,
              ),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          brightness: Brightness.light,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Divider(height: 1),
              Padding(
                padding: EdgeInsets.only(
                  left: 24.0,
                  right: 24.0,
                  bottom: 24.0,
                  top: 16.0,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        maxLines: 10,
                        style: Theme.of(context).textTheme.headline6,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 8, top: 10, right: 8, bottom: 10),
                          helperText: 'Short description',
                          
                          enabledBorder: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(),
                        ),
                        initialValue: formData!['deliveryInstruction'],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "This field is required";
                          }
                          return null;
                        },
                        onSaved: (value) =>
                            formData!['deliveryInstruction'] = value,
                      ),
                      SizedBox(height: 24),
                      InkWell(
                        child: Button(
                          label: 'Add to Address',
                          gradient: 'colored',
                          loading: isLoading,
                        ),
                        onTap: () async {
                          FocusScope.of(context).unfocus();

                          if (isLoading == false) {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();

                              isLoading = true;
                              setState(() {});

                              try {
                                await apiResource.updateAddress(
                                    address: formData!, userId: widget.userId!);

                                await Provider.of<AppState>(context,
                                        listen: false)
                                    .listAddresses(notify: true);

                                Navigator.pop(context);
                              } catch (e) {
                                //  TODO: handle error
                                isLoading = false;
                                setState(() {});
                              }
                              //
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
