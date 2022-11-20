import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:resort/pages/about_page/screen/about_page.dart';
import 'package:resort/pages/explore_page/screen/explore_page.dart';
import 'package:resort/pages/home_page/screen/home_page.dart';
import 'package:resort/pages/login/screen/login_page.dart';
import 'package:resort/pages/register/screen/register_page.dart';
import 'package:resort/pages/user_page/screen/user_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const App(),
      routes: {
        ScreenLogin.id: (context) => const ScreenLogin(),
        ScreenRegister.id: (context) => const ScreenRegister(),
      },
    );
  }
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final _isLogin = false;
  PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  List<Widget> _buildScreens() {
    final tabPage = <Widget>[
      const HomePage(),
      const ExplorePage(),
      const AboutPage(),
    ];
    if (_isLogin) {
      tabPage.add(const UserPage());
    }
    return tabPage;
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    final listButton = <PersistentBottomNavBarItem>[
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.home),
        inactiveIcon: Icon(CupertinoIcons.house_fill),
        title: ("Home"),
        activeColorPrimary: CupertinoColors.activeOrange,
        inactiveColorPrimary: CupertinoColors.systemGrey,
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          initialRoute: "/",
          routes: {
            ScreenLogin.id: (context) => const ScreenLogin(),
            ScreenRegister.id: (context) => const ScreenLogin(),
          },
        ),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.compass),
        inactiveIcon: Icon(CupertinoIcons.compass_fill),
        title: ("Explore"),
        activeColorPrimary: CupertinoColors.activeGreen,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.info),
        inactiveIcon: Icon(CupertinoIcons.info_circle_fill),
        title: ("About"),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
    if (_isLogin) {
      listButton.add(
        PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.person),
          inactiveIcon: Icon(CupertinoIcons.person_fill),
          title: ("User"),
          activeColorPrimary: CupertinoColors.systemIndigo,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ),
      );
    }
    return listButton;
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      resizeToAvoidBottomInset: true,
      navBarHeight: MediaQuery.of(context).viewInsets.bottom > 0
          ? 0.0
          : kBottomNavigationBarHeight,
      bottomScreenMargin: 0,
      backgroundColor: Colors.white,
      decoration: const NavBarDecoration(colorBehindNavBar: Colors.indigo),
      itemAnimationProperties: const ItemAnimationProperties(
        duration: Duration(milliseconds: 400),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        animateTabTransition: true,
      ),
    );
  }
}
