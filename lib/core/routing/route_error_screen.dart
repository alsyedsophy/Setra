import 'package:flutter/material.dart';

import '../localization/l10n_extension.dart';
import '../widgets/widgets.dart';

class RouteErrorScreen extends StatelessWidget {
  const RouteErrorScreen({this.message, super.key});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: AppErrorView(message: message ?? context.l10n.tr('errorGeneric')),
    );
  }
}
