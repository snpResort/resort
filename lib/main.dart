import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:resort/about_page/screen/about_page.dart';
import 'package:resort/auth/models/member.dart';
import 'package:resort/auth/models/user.dart';
import 'package:resort/auth/repository/db_user.dart';
import 'package:resort/auth/repository/p_user.dart';
import 'package:resort/auth/screen/change_password.dart';
import 'package:resort/auth/screen/login_page.dart';
import 'package:resort/auth/screen/register_info.dart';
import 'package:resort/auth/screen/register_page.dart';
import 'package:resort/auth/screen/verify_page.dart';
import 'package:resort/cart_page/screen/cart_page.dart';
import 'package:resort/constant/app_string.dart';
import 'package:resort/explore_page/screen/explore_page.dart';
import 'package:resort/home_page/repository/p_room.dart';
import 'package:resort/home_page/screen/home_page.dart';
import 'package:resort/home_page/screen/room_info_page.dart';
import 'package:resort/home_page/screen/room_search.dart';
import 'package:resort/home_page/screen/rooms_info.dart';
import 'package:resort/user_page/screen/booked_info_page.dart';
import 'package:resort/user_page/screen/change_password_user.dart';
import 'package:resort/user_page/screen/edit_info_page.dart';
import 'package:resort/user_page/screen/history_booked_page.dart';
import 'package:resort/user_page/screen/upgrade_rank_page.dart';
import 'package:resort/user_page/screen/user_info_page.dart';
import 'package:resort/user_page/screen/user_page.dart';
import 'package:resort/widgets/logo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  // Todo: register adapter
  Hive.registerAdapter(MemberAdapter());
  Hive.registerAdapter(UserAdapter());

  // Todo: open box Hive
  await Hive.openBox<User>(DBUser.dirName);

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.light,
  ));

  runApp(
    RestartWidget(
      child: const MyApp(),
    ),
  );
}

class RestartWidget extends StatefulWidget {
  RestartWidget({this.child});

  final Widget? child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>()?.restartApp();
  }

  @override
  State<StatefulWidget> createState() {
    return _RestartWidgetState();
  }
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child ?? Container(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PUser()),
        ChangeNotifierProvider(create: (context) => PRoom()),
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
          VerifyPage.id: (context) => VerifyPage(),
          ChangePassword.id: (context) => const ChangePassword(),
          RegisterInfo.id: (context) => const RegisterInfo(),
          RoomInfoPage.id: (context) => RoomInfoPage(),
          UserInfoPage.id: (context) => const UserInfoPage(),
          RoomsInfo.id: (context) => const RoomsInfo(),
          HistoryBooked.id: (context) => const HistoryBooked(),              
          RoomSearch.id: (context) => RoomSearch(),
          ChangePasswordUser.id: (context) => const ChangePasswordUser(),
          BookedInfoPage.id: (context) => BookedInfoPage(),
          EditInfoPage.id: (context) => EditInfoPage(),
          UpgradeRankPage.id: (context) => UpgradeRankPage(),
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

PersistentTabController controllerPersistent = PersistentTabController(initialIndex: 0);
bool isUpdateBottomBar = false;

class _AppState extends State<App> {

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    
    Provider.of<PUser>(context, listen: false);
    Provider.of<PRoom>(context, listen: false);

    if (isUpdateBottomBar) {
      controllerPersistent = PersistentTabController(initialIndex: 0);
      isUpdateBottomBar = false;
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
    print('\n=============================== tabPage length: ${tabPage.length} ');
    return tabPage;
  }

  List<PersistentBottomNavBarItem> _navBarsItems(contex) {
    final listButton = <PersistentBottomNavBarItem>[
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.home),
        inactiveIcon: Icon(CupertinoIcons.house_fill),
        title: ("Trang chủ"),
        activeColorPrimary: CupertinoColors.activeGreen,
        inactiveColorPrimary: CupertinoColors.systemGrey,
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          initialRoute: "/",
          routes: {
            ScreenLogin.id: (context) => const ScreenLogin(),
            ScreenRegister.id: (context) => const ScreenLogin(),
            VerifyPage.id: (context) => VerifyPage(),
            ChangePassword.id: (context) => const ChangePassword(),
            RegisterInfo.id: (context) => const RegisterInfo(),
            RoomsInfo.id: (context) => const RoomsInfo(),
            RoomSearch.id: (context) => RoomSearch(),
            RoomInfoPage.id: (context) => RoomInfoPage(),
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
        inactiveIcon: Stack(
          alignment: Alignment.center,
          children: [
            Icon(CupertinoIcons.cart_fill),
            if (Provider.of<PRoom>(context).infoBook.isNotEmpty)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  height: 10,
                  width: 10,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(60),
                  ),
                ),
              )
          ],
        ),
        title: ("Giỏ hàng"),
        activeColorPrimary: CupertinoColors.activeOrange,
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
          routeAndNavigatorSettings: RouteAndNavigatorSettings(
            initialRoute: "/",
            routes: {
              UserInfoPage.id: (context) => const UserInfoPage(),
              HistoryBooked.id: (context) => const HistoryBooked(),
              ChangePasswordUser.id: (context) => const ChangePasswordUser(),
              EditInfoPage.id: (context) => EditInfoPage(),
              UpgradeRankPage.id: (context) => UpgradeRankPage(),
              BookedInfoPage.id: (context) => BookedInfoPage(),
            },
          ),
        ),
      );
    }
    print('===================== listButton length: ${listButton.length}');
    return listButton;
  }
  
  @override
  Widget build(BuildContext context) {
    if (DBUser.hasLogin() && Provider.of<PUser>(context, listen: false).user == null) {
      print('login');
      print(DBUser.getUser().toString());
      Provider.of<PUser>(context, listen: false).login(DBUser.getUser()!);
    }
    

    print('----------------------- reset: ${_navBarsItems(context).length} ');

    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return PersistentTabView(
      context,
      controller: controllerPersistent,
      screens: _buildScreens(),
      items: _navBarsItems(context),

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
