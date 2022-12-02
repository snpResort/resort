import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:resort/about_page/screen/about_page.dart';
import 'package:resort/auth/models/member.dart';
import 'package:resort/auth/models/user.dart';
import 'package:resort/auth/repository/db_user.dart';
import 'package:resort/auth/repository/p_user.dart';
import 'package:resort/auth/screen/login_page.dart';
import 'package:resort/auth/screen/register_info.dart';
import 'package:resort/auth/screen/register_page.dart';
import 'package:resort/auth/screen/verify_page.dart';
import 'package:resort/cart_page/screen/cart_page.dart';
import 'package:resort/explore_page/screen/explore_page.dart';
import 'package:resort/home_page/screen/home_page.dart';
import 'package:resort/user_page/screen/user_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  // Todo: register adapter
  Hive.registerAdapter(MemberAdapter());
  Hive.registerAdapter(UserAdapter());

  // Todo: open box Hive
  await Hive.openBox<User>(DBUser.dirName);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PUser()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const App(),
        routes: {
          ScreenLogin.id: (context) => const ScreenLogin(),
          ScreenRegister.id: (context) => const ScreenRegister(),
          VerifyPage.id: (context) => const VerifyPage(),
          RegisterInfo.id: (context) => const RegisterInfo(),
        },
      ),
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // check login
    if (DBUser.hasLogin()) {
      Provider.of<PUser>(context, listen: false).login(DBUser.getUser()!);
    }
  }

  List<Widget> _buildScreens() {
    final tabPage = <Widget>[
      const HomePage(),
      const ExplorePage(),
      const CartPage(),
      const AboutPage(),
    ];
    if (Provider.of<PUser>(context, listen: true).isLogin) {
      tabPage.add(const UserPage());
    }
    return tabPage;
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    final listButton = <PersistentBottomNavBarItem>[
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.home),
        inactiveIcon: Icon(CupertinoIcons.house_fill),
        title: ("Trang chủ"),
        activeColorPrimary: CupertinoColors.activeOrange,
        inactiveColorPrimary: CupertinoColors.systemGrey,
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          initialRoute: "/",
          routes: {
            ScreenLogin.id: (context) => const ScreenLogin(),
            ScreenRegister.id: (context) => const ScreenLogin(),
            VerifyPage.id: (context) => const VerifyPage(),
            RegisterInfo.id: (context) => const RegisterInfo(),
          },
        ),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.compass),
        inactiveIcon: Icon(CupertinoIcons.compass_fill),
        title: ("Khám phá"),
        activeColorPrimary: CupertinoColors.activeGreen,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.cart),
        inactiveIcon: Icon(CupertinoIcons.cart_fill),
        title: ("Giỏ hàng"),
        activeColorPrimary: CupertinoColors.activeGreen,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.info),
        inactiveIcon: Icon(CupertinoIcons.info_circle_fill),
        title: ("Giới thiệu"),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
    if (Provider.of<PUser>(context, listen: true).isLogin) {
      listButton.add(
        PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.person),
          inactiveIcon: Icon(CupertinoIcons.person_fill),
          title: ("Tài khoản"),
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
