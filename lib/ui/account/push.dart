import 'package:flutter/material.dart';
import 'package:itarashop/app_state.dart';
import 'package:provider/provider.dart';

class PushNotifications extends StatelessWidget {
  final AppState? appState;
  const PushNotifications({Key? key, this.appState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Push Notifications', style: Theme.of(context).textTheme.headline6!.copyWith(
                fontWeight: FontWeight.w500,
              ),),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ListView(
          children: [
            Divider(height: 1),
            ListTile(
              trailing: Switch(
                  activeColor: Theme.of(context).colorScheme.primaryVariant,
                  value: appState!.enablePushNotification,
                  onChanged: (val) async {
                    Provider.of<AppState>(context, listen: false)
                        .updatePushNotification();
                  }),
              title: Text(
                'Deals/discount alerts',
                style: Theme.of(context).textTheme.headline6!.copyWith(
                      fontSize: 16.0,
                    ),
              ),
            ),
            Divider(height: 1),
            ListTile(
              trailing: Switch(
                  activeColor: Theme.of(context).colorScheme.primaryVariant,
                  value: appState!.enablePushNotification,
                  onChanged: (val) async {
                    Provider.of<AppState>(context, listen: false)
                        .updatePushNotification();
                  }),
              title: Text(
                'New product category alert',
                style: Theme.of(context).textTheme.headline6!.copyWith(
                      fontSize: 16.0,
                    ),
              ),
            ),
            Divider(height: 1),
            ListTile(
              trailing: Switch(
                  activeColor: Theme.of(context).colorScheme.primaryVariant,
                  value: appState!.enablePushNotification,
                  onChanged: (val) async {
                   Provider.of<AppState>(context, listen: false)
                        .updatePushNotification();
                  }),
              title: Text(
                'New single piece(s) product alert',
                style: Theme.of(context).textTheme.headline6!.copyWith(
                      fontSize: 16.0,
                    ),
              ),
            ),
            Divider(height: 1),
            ListTile(
              trailing: Switch(
                  activeColor: Theme.of(context).colorScheme.primaryVariant,
                  value: appState!.enablePushNotification,
                  onChanged: (val) async {
                    Provider.of<AppState>(context, listen: false)
                        .updatePushNotification();
                  }),
              title: Text(
                'New limited pieces products alert',
                style: Theme.of(context).textTheme.headline6!.copyWith(
                      fontSize: 16.0,
                    ),
              ),
            ),
            Divider(height: 1),
            ListTile(
              trailing: Switch(
                  activeColor: Theme.of(context).colorScheme.primaryVariant,
                  value: appState!.enablePushNotification,
                  onChanged: (val) async {
                  Provider.of<AppState>(context, listen: false)
                        .updatePushNotification();
                  }),
              title: Text(
                'New product alerts',
                style: Theme.of(context).textTheme.headline6!.copyWith(
                      fontSize: 16.0,
                    ),
              ),
            ),
            Divider(height: 1),
            ListTile(
              trailing: Switch(
                  activeColor: Theme.of(context).colorScheme.primaryVariant,
                  value: appState!.enablePushNotification,
                  onChanged: (val) async {
                  Provider.of<AppState>(context, listen: false)
                        .updatePushNotification();
                  }),
              title: Text(
                'General Updates',
                style: Theme.of(context).textTheme.headline6!.copyWith(
                      fontSize: 16.0,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
