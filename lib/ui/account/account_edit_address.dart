import 'package:flutter/material.dart';
import 'package:itarashop/api/ApiResource.dart';
import 'package:itarashop/forms/address_form.dart';
import 'package:shimmer/shimmer.dart';

class EditAddress extends StatelessWidget {
  final Map? address;
  final String? userId;

  EditAddress({@required this.address, @required this.userId});

  final ApiResource apiResource = ApiResource();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        titleSpacing: 0,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Edit Address',
          style: Theme.of(context).textTheme.headline6!.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
      ),
      body: FutureBuilder<List>(
        future: apiResource.getCountries(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Shimmer.fromColors(
              baseColor: Colors.black12.withAlpha(50),
              highlightColor: Colors.black12,
              child: ListView.builder(
                padding: EdgeInsets.all(24),
                itemCount: 5,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 150,
                        height: 15,
                        margin: EdgeInsets.only(bottom: 8),
                        color: Colors.grey.withOpacity(0.3),
                      ),
                      Container(
                        width: double.infinity,
                        height: 45,
                        margin: EdgeInsets.only(bottom: 24),
                        color: Colors.grey.withOpacity(0.3),
                      ),
                    ],
                  );
                },
              ),
            );
          }

          if (snapshot.hasData) {
            return AddressForm(
              countries: snapshot.data!,
              userId: userId!,
              address: address!,
            );
          }

          return Container(); // TODO: error
        },
      ),
    );
  }
}
