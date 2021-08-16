import 'package:flutter/material.dart';
import 'package:itarashop/common/progressbar_circular.dart';
import 'package:lottie/lottie.dart';
import '../common/progressbar_linear.dart';

class CustomAlert extends StatelessWidget {
  final String? title;
  final String? desc;
  final bool loading;
  final Function? onAction;
  final Function? onCancel;

  CustomAlert({
    this.title,
    this.desc,
    this.loading = false,
    this.onCancel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      titlePadding: EdgeInsets.zero,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  title!,
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(color: Color(0xFF5C5C5C), fontSize: 18),
                ),
                SizedBox(height: 20),
                Text(
                  desc!,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(color: Colors.black45),
                ),
              ],
            ),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 800),
            height: loading ? 2 : 0,
            child: ProgressbarLinear(),
          ),
        ],
      ),
      content: Container(
        width: double.infinity,
        // height: 50,
        decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            )),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    elevation: 1,
                    primary: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7))),
                onPressed: () {
                  Navigator.of(context).pop('dialog');
                  if (onCancel != null) this.onCancel!();
                },
                label: Text(
                  'Cancel',
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: Colors.black,
                      ),
                ),
                icon: Icon(
                  Icons.close,
                  color: Colors.black,
                  size: 16,
                ),
              ),
              if (onAction != null)
                loading == false
                    ? ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            elevation: 1,
                            primary:
                                Theme.of(context).colorScheme.primaryVariant,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7))),
                        onPressed: () {
                          if (onAction != null) this.onAction!();
                        },
                        label: Text(
                          'Continue',
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                color: Colors.white,
                              ),
                        ),
                        icon: Icon(
                          Icons.done,
                          color: Colors.white,
                          size: 16,
                        ),
                      )
                    : SizedBox(
                        width: 100,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.grey[400],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7),
                            ),
                          ),
                          onPressed: () {},
                          child: Container(
                            height: 17,
                            width: 17,
                            child: ProgressbarCircular(),
                          ),
                        ),
                      )
            ],
          ),
        ),
      ),
      contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
    );
  }
}

// Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: <Widget>[
//           Expanded(
//             child: FlatButton(
//               padding: EdgeInsets.all(10.0),
//               shape: BorderDirectional(
//                 top: BorderSide(color: Colors.black12),
//               ),
//               onPressed: () {
//                 Navigator.of(context).pop('dialog');
//                 if (onCancel != null) this.onCancel();
//               },
//               child: SizedBox(
//                 height: 40,
//                 child: Center(
//                   child: Text(
//                     'Close',
//                     style: Theme.of(context).textTheme.body2.copyWith(
//                           color: Theme.of(context).colorScheme.primaryVariant,
//                         ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           if (onAction != null)
//             Expanded(
//               child: FlatButton(
//                 padding: EdgeInsets.all(10.0),
//                 shape: BorderDirectional(
//                   top: BorderSide(color: Colors.black12),
//                   start: BorderSide(color: Colors.black12),
//                 ),
//                 onPressed: () {
//                   if (onAction != null) this.onAction();
//                 },
//                 child: SizedBox(
//                   height: 40,
//                   child: Center(
//                     child: Text(
//                       'Continue',
//                       style: Theme.of(context).textTheme.body2.copyWith(
//                             color: Theme.of(context).colorScheme.primaryVariant,
//                           ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//         ],
//       ),
