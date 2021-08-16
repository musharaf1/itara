import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itarashop/app_state.dart';
import 'package:provider/provider.dart';

class AppTab extends StatelessWidget {
  final String? icon;
  final bool isActive;
  final Function? onTap;
  final int? screen;

  AppTab(
      {@required this.icon,
      this.isActive = false,
      @required this.onTap,
      this.screen});

  @override
  Widget build(BuildContext context) {
    print(Provider.of<AppState>(context).cartItems.length);
    return Stack(
      children: [
        InkWell(
          onTap: () => onTap!(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            child: Container(
              // color: Colors.red,
              height: 30,
              width: 30,
              child: Stack(
                // mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    isActive
                        ? "${icon!.replaceFirst('.svg', '_active.svg')}"
                        : icon!,
                    height: 24,
                    width: 24,
                    fit: BoxFit.cover,
                  ),
                  // SizedBox(height: 8),
                  // Text(
                  //   'Discover',
                  //   style: TextStyle(
                  //     fontSize: 12,
                  //   ),
                  // ),
                  icon == 'assets/images/cart.svg' &&
                          Provider.of<AppState>(context).cartItems.length > 0
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xff2b2b2b),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Text(
                                    Provider.of<AppState>(context)
                                        .cartItems
                                        .length
                                        .toString(),
                                    style: GoogleFonts.workSans(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white),
                                  ),
                                ),
                              )),
                        )
                      : SizedBox()
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
