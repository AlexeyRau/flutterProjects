import 'package:flutter/material.dart';

class CustomAppBar extends AppBar {
  CustomAppBar({
    required String title,
    required BuildContext context,
    List<Widget>? actions,
  }) : super(
         title: Text(title),
         leading: IconButton(
           icon: const Icon(Icons.arrow_back),
           onPressed: () => Navigator.pop(context),
         ),
         actions: actions,
       );
}
