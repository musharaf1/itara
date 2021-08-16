import 'package:flutter/material.dart';
import 'package:itarashop/api/ApiResource.dart';
import 'package:provider/provider.dart';
import '../../app_state.dart';
import '../../common/address_item.dart';
import '../../common/button_widget.dart';

class AccountAdressBook extends StatefulWidget {
  final String? userId;
  final Function? action;

  AccountAdressBook({@required this.userId, this.action});

  @override
  _AccountAdressBookState createState() => _AccountAdressBookState();
}

class _AccountAdressBookState extends State<AccountAdressBook> {
  final ApiResource apiResource = ApiResource();
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      AppState appstate = Provider.of<AppState>(context, listen: false);
      if (appstate.addressBook == null) {
        Provider.of<AppState>(context, listen: false)
            .listAddresses(notify: true);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        title: Text(
          'Address Book',
          style: Theme.of(context).textTheme.headline6!.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        titleSpacing: 0,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Consumer<AppState>(builder: (context, appstate, _) {
        return ListView(
          children: [
            Divider(height: 1),
            if (appstate.addressBook != null)
              for (Map address in appstate.addressBook!)
                AddressItem(
                  address: address,
                  userId: widget.userId!,
                  action: widget.action,
                ),
            Padding(
              padding: EdgeInsets.all(24.0),
              child: InkWell(
                child: Button(
                  label: 'ADD A NEW ADDRESS',
                ),
                onTap: () async {
                  await Navigator.pushNamed(
                    context,
                    '/account/add-address',
                    arguments: {
                      'userId': widget.userId,
                    },
                  );
                },
              ),
            )
          ],
        );
      }),
    );
  }
}
