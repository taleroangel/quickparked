import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:quickparked/providers/profile_picture_provider.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({Key? key, required this.size}) : super(key: key);
  final double size;

  @override
  Widget build(BuildContext context) {
    final ProfilePictureProvider provider =
        context.watch<ProfilePictureProvider>();
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: provider.profilePicture,
            fit: BoxFit.scaleDown,
          )),
    );
  }
}
