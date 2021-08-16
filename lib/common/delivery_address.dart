import 'package:flutter/material.dart';
import 'package:itarashop/api/ApiResource.dart';
import 'package:itarashop/model/Delivery.dart';
import 'package:itarashop/ui/account/account_addressbook.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import 'add_button.dart';

class DeliveryAddress extends StatelessWidget {
  final String? userId;
  final Delivery? address;
  final bool isSummary;

  DeliveryAddress({
    @required this.userId,
    @required this.address,
    this.isSummary = true,
  });

  final ApiResource apiResource = ApiResource();

  @override
  Widget build(context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: isSummary ? EdgeInsets.zero : EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Address Details',
            style: textTheme.bodyText1,
          ),
          SizedBox(height: 20.0),
          if (address == null)
            Column(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).colorScheme.primaryVariant,
                  ),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AccountAdressBook(
                          userId: userId,
                          action: () => Navigator.pop(context),
                        ),
                      ),
                    );
                  },
                  child: Text('Add Address'),
                ),
                // InkWell(
                //   child: AddButton(label: 'Add Address'),
                //   onTap: () async {
                //     await Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => AccountAdressBook(
                //           userId: userId,
                //           action: () => Navigator.pop(context),
                //         ),
                //       ),
                //     );
                    // await Navigator.pushNamed(
                    //   context,
                    //   '/account/add-address',
                    //   arguments: <String, dynamic>{
                    //     'userId': userId,
                    //   },
                    // );
                //   },
                // ),
              ],
            )
          else
            GestureDetector(
              onTap: () async {
                // await Navigator.pushNamed(context, '/account/address-book',
                //     arguments: <String, String>{
                //       'userId': userId,
                //     });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          address!.contactName! +
                              "\n${address!.addressLine1}\n"
                                  "${address!.addressLine2}",
                          style: textTheme.bodyText2!.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          "${address!.city!['name']}, ${address!.city!['politicalState']['name']}\n"
                          "${address!.contactPhone}",
                          style: textTheme.bodyText2!.copyWith(
                            color: Colors.grey,
                          ),
                        )
                      ],
                    ),
                  ),
                  if (!isSummary)
                    Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).colorScheme.primaryVariant,
                        ),
                        onPressed: () async {
                          await Navigator.pushNamed(
                              context, '/account/address-book',
                              arguments: <String, String>{
                                'userId': userId!,
                              });
                        },
                        child: Text('Change Address'),
                      ),
                    )
                ],
              ),
            ),
          SizedBox(height: 20),
          if (!isSummary)
            if (address?.deliveryInstruction == null)
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/account/delivery-instruction',
                    arguments: {
                      'address': address!.toMap(),
                      'userId': userId,
                    },
                  );
                },
                child: AddButton(
                  label: 'Add delivery Instruction or additional \ndescription',
                ),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  InkWell(
                    child: AddButton(label: 'Edit Delivery Instruction'),
                    onTap: () async {
                      await Navigator.pushNamed(
                          context, '/account/delivery-instruction',
                          arguments: <String, dynamic>{
                            'userId': userId,
                            'address': address!.toMap()
                          });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 6,
                      top: 10,
                    ),
                    child: Text(address!.deliveryInstruction!),
                  ),
                ],
              ),
        ],
      ),
    );
  }
}
