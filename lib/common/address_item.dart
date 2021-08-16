// Address Item
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itarashop/api/ApiResource.dart';
import 'package:itarashop/model/Delivery.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import 'add_button.dart';
import 'custom_alert.dart';
import 'custom_checkbox.dart';
import 'small_button.dart';

class AddressItem extends StatefulWidget {
  final Map? address;
  final bool checked;
  final String? userId;
  final Function? action;

  AddressItem(
      {this.address, this.checked = false, @required this.userId, this.action});

  @override
  _AddressItemState createState() => _AddressItemState();
}

class _AddressItemState extends State<AddressItem> {
  bool? isChecked;
  bool isLoading = false;

  @override
  void initState() {
    isChecked = widget.checked;
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      setAddress();
    });
    super.initState();
  }

  void setAddress() {
    if (widget.address!['isDefaultDeliveryAddress'] == true) {
      Provider.of<AppState>(context, listen: false).setAddress(
          Delivery.fromJson(widget.address as Map<String, dynamic>));
    }
  }

  @override
  Widget build(BuildContext context) {
    final _address = widget.address;

    return Container(
      padding: EdgeInsets.all(24.0),
      margin: EdgeInsets.only(left: 24.0, right: 24.0, top: 24.0),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            _address!['contactName'] ?? 'No Name',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          SizedBox(height: 12),
          Title(
            label: "${_address['addressLine1']}\n${_address['addressLine2']}",
          ),
          SizedBox(height: 8),
          Title(
              label:
                  "${_address['city']['name']}, ${_address['city']['politicalState']['name']}"),
          Title(label: "${_address['contactPhone']}"),
          SizedBox(height: 16),
          InkWell(
            child: AddButton(
              label: _address['deliveryInstruction'] == null
                  ? 'Add Delivery Instruction'
                  : 'Edit Delivery Instruction',
            ),
            onTap: () async {
              await Navigator.pushNamed(
                context,
                '/account/delivery-instruction',
                arguments: <String, dynamic>{
                  'userId': widget.userId,
                  'address': _address,
                },
              );
            },
          ),
          Consumer<AppState>(builder: (context, appstate, child) {
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: appstate.address!.deliveryAddressId ==
                          _address['deliveryAddressId']
                      ? Colors.grey[500]
                      : Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6))),
              onPressed: () {
                appstate.setAddress(
                    Delivery.fromJson(_address as Map<String, dynamic>));
                // widget.action != null ? widget.action!() : () {};
                Navigator.pop(context);
              },
              child: Text(
                appstate.address!.deliveryAddressId ==
                        _address['deliveryAddressId']
                    ? 'This address is selected'
                    : 'Deliver to this address',
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(color: Colors.white),
              ),
            );
          }),
          SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SmallButton(
                title: 'Edit',
                borderRadius: 3,
                color: Colors.black12.withAlpha(10),
                borderColor: Colors.black12,
                textColor: Colors.black,
                onTap: () async {
                  await Navigator.pushNamed(context, '/account/edit-address',
                      arguments: {
                        'userId': widget.userId,
                        'address': _address,
                      });
                },
              ),
              SmallButton(
                title: 'Remove',
                borderRadius: 3,
                color: Colors.black12.withAlpha(10),
                borderColor: Colors.black12,
                textColor: Colors.black,
                onTap: () async {
                  // remove with addressID
                  final String addressId = _address['deliveryAddressId'];

                  await showDialog(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(builder: (context, setState) {
                          return CustomAlert(
                            title: "Delete ${_address['contactName']}",
                            desc:
                                'Are you sure you want to delete the selected address?',
                            loading: isLoading,
                            onCancel: () {
                              isLoading = false;
                              setState(() {});
                            },
                            onAction: () async {
                              isLoading = true;
                              setState(() {});

                              try {
                                await Provider.of<AppState>(context,
                                        listen: false)
                                    .deleteAddress(addressId: addressId);

                                isLoading = false;
                                setState(() {});

                                Navigator.pop(context);
                              } catch (e) {
                                isLoading = false;
                                setState(() {});
                              }
                            },
                          );
                        });
                      });
                },
              ),
            ],
          ),
          SizedBox(height: 8),
          CustomCheckBox(
            isChecked: _address['isDefaultDeliveryAddress'] ?? false,
            onChanged: (value) async {
              return await showDialog(
                context: context,
                builder: (context) {
                  return StatefulBuilder(builder: (context, setState) {
                    return CustomAlert(
                      title: _address['contactName'],
                      desc: 'Are you sure you want to set this as your '
                          'default delivery address?',
                      loading: isLoading,
                      onCancel: () {
                        isLoading = false;
                        setState(() {});
                      },
                      onAction: () async {
                        isLoading = true;
                        setState(() {});

                        try {
                          ApiResource apiResource = ApiResource();

                          await apiResource.updateAddressDefault(
                              address: _address,
                              isDefaultDeliveryAddress: value);
                          Provider.of<AppState>(context, listen: false)
                              .setAddress(Delivery.fromJson(
                                  _address as Map<String, dynamic>));

                          await Provider.of<AppState>(context, listen: false)
                              .listAddresses();

                          isLoading = false;
                          setState(() {});

                          Navigator.pop(context);
                        } catch (e) {
                          isLoading = false;
                          setState(() {});
                        }
                      },
                    );
                  });
                },
              );

              //update delivery address
            },
            label: 'Default Shipping Address',
          ),
        ],
      ),
    );
  }
}

/// Title
class Title extends StatelessWidget {
  final String? label;

  Title({@required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label!,
      style: Theme.of(context)
          .textTheme
          .bodyText2!
          .copyWith(color: Colors.black45, fontWeight: FontWeight.w400),
    );
  }
}
