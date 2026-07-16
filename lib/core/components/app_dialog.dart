import 'package:flutter/material.dart';

class AppDialog extends StatelessWidget {
  const AppDialog({
    required this.title,
    this.content,
    this.actions = const <Widget>[],
    super.key,
  });

  final String title;
  final Widget? content;
  final List<Widget> actions;

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    Widget? content,
    List<Widget> actions = const <Widget>[],
  }) {
    return showDialog<T>(
      context: context,
      builder: (BuildContext context) =>
          AppDialog(title: title, content: content, actions: actions),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(title: Text(title), content: content, actions: actions);
  }
}
