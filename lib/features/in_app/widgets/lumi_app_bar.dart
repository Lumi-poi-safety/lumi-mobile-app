import 'package:flutter/material.dart';

PreferredSizeWidget lumiAppBar(String title, {List<Widget>? actions}) {
  return AppBar(
    leading: Image.asset("lib/assets/images/Lumi_f2.png"),
    title: Text(title),
    elevation: 0,
    centerTitle: true,
    backgroundColor: Colors.transparent,
    foregroundColor: const Color(0xFF1E2A33),
    actions: actions,
  );
}
