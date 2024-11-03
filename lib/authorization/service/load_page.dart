import 'package:flutter/material.dart';
import '../../routes/auth_route.dart';

class LoadPage extends ChangeNotifier{
  Widget? _page;
  Widget? get page => _page;

  loadPage(final context) async{
    _page = await AuthRoute(ctx: context).navigateController();
    notifyListeners();
  }
}