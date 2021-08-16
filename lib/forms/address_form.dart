import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../api/ApiResource.dart';
import '../app_state.dart';
import '../common/button_widget.dart';
import '../common/custom_checkbox.dart';

class AddressForm extends StatefulWidget {
  final List? countries;
  final String? userId;
  final Map? address;

  AddressForm({@required this.countries, @required this.userId, this.address});

  @override
  _AddressFormState createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
  List getStates(String country) {
    final List states = widget.countries!
        .firstWhere((element) => element['name'] == country)['politicalStates'];

    return states;
  }

  List getCities(String state) {
    final List states = getStates(formData['country']);
    final List cities =
        states.firstWhere((element) => element['name'] == state)['cities'];

    return cities;
  }

  final ApiResource apiResource = ApiResource();
  final _formKey = GlobalKey<FormState>();
  final List<String> dropdownFields = ["citySlug", "politicalState", "country"];
  final List<String> phoneFields = ["contactPhone", "contactPhone2"];
  Map formData = <String, dynamic>{};
  final formFields = <String, dynamic>{
    'First Name': 'firstName',
    'Last Name': 'lastName',
    'Address Line 1': 'addressLine1',
    'Address Line 2': 'addressLine2',
    'Country': 'country',
    'State': 'politicalState',
    'City': 'citySlug',
    'Mobile Phone Number': 'contactPhone',
    'Additional Mobile Number': 'contactPhone2',
  };

  // display common errors if any
  bool isLoading = false;
  String? errors;

  @override
  void initState() {
    print(widget.address);
    // signifies an update form
    if (widget.address != null) {
      final List<String>? names =
          widget.address!['contactName'].toString().split(' ');
      formData = <String, dynamic>{
        ...?widget.address,
        'firstName': names![0],
        'lastName': names[1],
        'country': 'Nigeria',
        'politicalState': widget.address!['city']['politicalState']['name'],
        'citySlug': widget.address!['city']['slug'],
      };
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.countries);
    final TextTheme textTheme = Theme.of(context).textTheme;

    // print(formData);

    return ListView(
      children: [
        Divider(height: 1),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (MapEntry field in formFields.entries)
                  if (dropdownFields.contains(field.value))
                    DropdownButtonFormField(
                      decoration: InputDecoration(
                        labelText: field.key,
                      ),
                      value: formData[field.value] != null
                          ? formData[field.value]
                          : null,
                      items: [
                        if (field.key == "Country")
                          for (var country in widget.countries!)
                            DropdownMenuItem(
                              value: country['name'],
                              child: Text(
                                country['name'],
                                style: textTheme.headline6,
                              ),
                            ),
                        if (field.key == "State" && formData['country'] != null)
                          for (var state in getStates(formData['country']))
                            DropdownMenuItem(
                              value: state['name'],
                              child: Text(
                                state['name'],
                                style: textTheme.headline6,
                              ),
                            ),
                        if (field.key == "City" &&
                            formData['politicalState'] != null)
                          for (var city
                              in getCities(formData['politicalState']))
                            DropdownMenuItem(
                              value: city['slug'],
                              child: Text(
                                city['name'],
                                style: textTheme.headline6,
                              ),
                            ),
                      ],
                      validator: (value) {
                        if (value == null) {
                          return field.key + " is required";
                        }
                        return null;
                      },
                      onChanged: (value) {
                        // clean up state descendants,
                        if (field.value == "country") {
                          formData['politicalState'] = null;
                          formData['citySlug'] = null;
                        } else if (field.value == "politicalState") {
                          formData['citySlug'] = null;
                        }
                        formData[field.value] = value;
                        setState(() {});
                      },
                    )
                  else if (phoneFields.contains(field.value))
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 2,
                          child: DropdownButtonFormField(
                            value: '+234',
                            style: textTheme.headline6,
                            decoration: InputDecoration(
                              labelText: ' ',
                            ),
                            items: [
                              DropdownMenuItem(
                                value: '+234',
                                child: Text(
                                  '+234',
                                  style: textTheme.headline6,
                                ),
                              )
                            ],
                            onChanged: (value) => null,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding: EdgeInsets.only(top: 2.5),
                            child: TextFormField(
                              keyboardType: TextInputType.phone,
                              style: textTheme.headline6,
                              decoration: InputDecoration(
                                labelText: field.key,
                              ),
                              initialValue: formData[field.value] != null
                                  ? formData[field.value]
                                      .toString()
                                      .replaceAll('+234', '')
                                  : null,
                              onSaved: (value) =>
                                  formData[field.value] = "+234" + value!,
                            ),
                          ),
                        )
                      ],
                    )
                  else
                    TextFormField(
                      style: textTheme.headline6,
                      decoration: InputDecoration(
                        labelText: field.key,
                      ),
                      initialValue: formData[field.value],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          if (field.key.toString().contains('Line 2')) {
                            return null;
                          } else {
                            return field.key + " is required";
                          }
                        }
                        return null;
                      },
                      onSaved: (value) => formData[field.value] = value,
                    ),
                if (errors != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      errors!,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                SizedBox(height: 15),
                Text(
                  'Add delivery instructions (optional)',
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 19,
                      ),
                ),
                SizedBox(height: 10),
                Text(
                  'Do we need additional instructions to find this address?',
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 15),
                TextFormField(
                  maxLines: 8,
                  style: Theme.of(context).textTheme.headline6,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.only(left: 8, top: 10, right: 8, bottom: 10),
                    // helperText: '',
                    hintText:
                        'Provide details such as building description, a nearby landmark, or other navigation instructions',
                    hintMaxLines: 3,
                    labelText: 'Delivery Instruction',
                    labelStyle: Theme.of(context).textTheme.headline6,
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 1, color: Colors.black45)),
                    focusedBorder: OutlineInputBorder(),
                  ),
                  initialValue: formData['deliveryInstruction'],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "This field is required";
                    }
                    return null;
                  },
                  onSaved: (value) => formData['deliveryInstruction'] = value,
                ),
                SizedBox(height: 24),
                CustomCheckBox(
                  isChecked: formData['isDefaultDeliveryAddress'] ?? true,
                  onChanged: (value) {
                    formData['isDefaultDeliveryAddress'] = value;
                    setState(() {});
                  },
                  label: 'Default Shipping Address',
                ),
                SizedBox(height: 40),
                InkWell(
                  child: Button(
                    label: 'Save Changes',
                    gradient: 'colored',
                    loading: isLoading,
                  ),
                  onTap: () async {
                    FocusScope.of(context).unfocus();

                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      if (isLoading == false) {
                        if (formData['contactPhone'].isEmpty) {
                          errors = 'Phone number is required';
                          setState(() {});
                        } else {
                          errors = null;
                          isLoading = true;
                          setState(() {});

                          try {
                            if (widget.address != null) {
                              // Update address
                              await apiResource.updateAddress(
                                address: formData,
                                userId: widget.userId!,
                              );
                            } else {
                              // Create address
                              await apiResource.createAddress(
                                address: formData,
                                userId: widget.userId!,
                              );
                            }

                            // update user address book state
                            await Provider.of<AppState>(context, listen: false)
                                .listAddresses();

                            Navigator.pop(context);
                          } catch (e) {
                            print(e);

                            errors = e.toString();
                            isLoading = false;
                            setState(() {});
                          }
                        }
                      } else {}
                    }
                  },
                ),
                SizedBox(height: 24),
              ],
            ),
          ),
        )
      ],
    );
  }
}
