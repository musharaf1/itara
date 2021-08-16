import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String? profilePictureUrl;

  ProfileAvatar({@required this.profilePictureUrl});
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        color: Colors.grey.withOpacity(.2),
        child: Image.network(
          profilePictureUrl == null || profilePictureUrl!.isEmpty
              ? 'https://www.kindpng.com/picc/m/421-4212275_transparent-default-avatar-png-avatar-img-png-download.png'
              : profilePictureUrl!,
          width: MediaQuery.of(context).size.width * 0.28,
          height: MediaQuery.of(context).size.width * 0.28,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
