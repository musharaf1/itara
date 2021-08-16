import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:itarashop/api/ApiResource.dart';
import 'package:itarashop/api/Client.dart';

import '../../common/button_widget.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Padding(
          padding: EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Align(
              //   alignment: Alignment.center,
              //   child: SvgPicture.asset(
              //     'assets/images/logo.svg',
              //     height: MediaQuery.of(context).size.height / 6,
              //     fit: BoxFit.contain,
              //   ),
              // ),
              Image.asset(
                'assets/images/splash.png',
                height: 55,
              ),
              SizedBox(height: 40.0),
              GestureDetector(
                // onTap: () async {
                //   final Client apiResource = Client();
                //   apiResource.getToken();
                // },
                onTap: () => Navigator.pushNamed(context, '/signin'),
                child: Button(
                  label: "SIGN IN",
                  gradient: "colored",
                ),
              ),
              SizedBox(height: 10.0),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/register'),
                child: Button(
                  label: "SIGN UP",
                  gradient: "colored-inverse",
                ),
              ),
              SizedBox(height: 60.0),
              GestureDetector(
                // onTap: () async {
                //  final Dio dio = Dio(BaseOptions(
                //    baseUrl: 'https://ezzev2production.azurewebsites.net/api/v2'
                //  ));

                //  Response response = await dio.get('/payments/get-oauth-link');
                //  if(response.statusCode.toString().startsWith('2')) {
                //    print(response.data);
                //  } else {
                //    print(response.data);
                //  }
                // },
                onTap: () =>
                    Navigator.pushReplacementNamed(context, '/app', arguments: {
                  'activeScreen': 0,
                }),
                child: Button(label: "ENTER AS A GUEST"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
