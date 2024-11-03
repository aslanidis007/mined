import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mined/screens/talk.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mined/services/auth_system.dart';
import 'package:mined/services/hide_nav_bar.dart';
import 'package:mined/translations/locale_keys.g.dart';
import 'package:provider/provider.dart';
import '../../constants/assets.dart';
import '../../constants/color.dart';
import '../home.dart';
import '../home_admin.dart';

// ignore: must_be_immutable
class BottomMenu extends StatefulWidget {
  const BottomMenu({super.key, });
  @override
  State<BottomMenu> createState() => _BottomMenuState();
}

class _BottomMenuState extends State<BottomMenu> with AutomaticKeepAliveClientMixin<BottomMenu> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    // Event(),
    Talk(),
  ];

  static const List<Widget> _widgetOptionsAdmin = <Widget>[
    HomeAdmin(),
    // Event(),
    Talk(),
  ];


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    Provider.of<HideNavBar>(context, listen: false);
    Provider.of<AuthSystem>(context, listen: false).getRole();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
        extendBody: true,
        backgroundColor: Colors.transparent,
        body: Consumer<AuthSystem>(
          builder: (context, data, child) {
            return IndexedStack(
              index: _selectedIndex,
              children: data.role == 'member'
              ? _widgetOptions
              : _widgetOptionsAdmin
            );
          }
        ),
        bottomNavigationBar: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40)
          ),
          child: Consumer<HideNavBar>(
            builder: (context, data, child) {
              if(data.hideNavBar == true){
                return const SizedBox();
              }
              return Container(
                height: h * 0.112,
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.darkMov,
                      blurRadius: 100,
                      spreadRadius: 100,
                      offset: Offset(30, 10)
                    )
                  ]
                ),
                child: BottomNavigationBar(
                  backgroundColor: AppColors.white,
                  type: BottomNavigationBarType.fixed,
                  elevation: 5,
                  selectedLabelStyle: const TextStyle(
                    color: AppColors.darkMov,
                    fontSize: 10,
                    fontWeight: FontWeight.w400
                  ),
                  unselectedLabelStyle: TextStyle(
                    color: AppColors.darkMov.withOpacity(0.4),
                    fontSize: 10,
                    fontWeight: FontWeight.w400
                  ),
                  selectedItemColor: AppColors.darkMov,
                  unselectedItemColor: AppColors.darkMov.withOpacity(0.4),
                  currentIndex: _selectedIndex,
                  onTap: _onItemTapped,
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: _selectedIndex == 0
                          ? Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: SvgPicture.asset(
                              AppAssets.homeicon,
                              width: 30,
                              // ignore: deprecated_member_use
                              color: AppColors.darkMov,
                            ),
                          )
                          : Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: SvgPicture.asset(
                              AppAssets.homeicon, 
                              width: 30,
                              // ignore: deprecated_member_use
                              color: AppColors.darkMov.withOpacity(0.4),
                            ),
                          ),
                      label: LocaleKeys.homeTitle.tr(context: context),
                    ),
                    // BottomNavigationBarItem(
                    //   icon: _selectedIndex == 1
                    //       ? Padding(
                    //         padding: const EdgeInsets.only(bottom: 5.0),
                    //         child: SvgPicture.asset(
                    //           AppAssets.icon,
                    //           width: 30,
                    //           // ignore: deprecated_member_use
                    //           color: AppColors.darkMov,
                    //         ),
                    //       )
                    //       : Padding(
                    //         padding: const EdgeInsets.only(bottom: 5.0),
                    //         child: SvgPicture.asset(
                    //           AppAssets.icon, 
                    //           width: 30,
                    //           // ignore: deprecated_member_use
                    //           color: AppColors.darkMov.withOpacity(0.4),
                    //         ),
                    //       ),
                    //   label: LocaleKeys.addLifeEventTitle.tr(context: context),
                    // ),
                    BottomNavigationBarItem(
                      icon: _selectedIndex == 2
                          ? Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: SvgPicture.asset(
                              AppAssets.talkicon,
                              width: 30,
                              // ignore: deprecated_member_use
                              color: AppColors.darkMov,
                            ),
                          )
                          : Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: SvgPicture.asset(
                              AppAssets.talkicon, 
                              width: 30,
                              // ignore: deprecated_member_use
                              color: AppColors.darkMov.withOpacity(0.4),
                            ),
                          ),
                      label: LocaleKeys.talkToSomeOneTitle.tr(context: context),
                    ),
                  ],
                ),
              );
            }
          ),
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
