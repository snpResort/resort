import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:resort/auth/models/user.dart';
import 'package:resort/auth/repository/db_user.dart';
import 'package:resort/auth/repository/p_user.dart';
import 'package:resort/auth/request/login_request.dart';
import 'package:resort/constant/app_string.dart';
import 'package:resort/main.dart';
import 'package:resort/user_page/request/user_request.dart';
import 'package:resort/user_page/screen/change_password_user.dart';
import 'package:resort/user_page/screen/history_booked_page.dart';
import 'package:resort/user_page/screen/upgrade_rank_page.dart';
import 'package:resort/user_page/screen/user_info_page.dart';
import 'package:resort/widgets/loading_widget.dart';
import 'package:resort/widgets/message_alert.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  static String id = '/user';

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  bool isLogin = false;
  User? _user;
  
  bool _isload = false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    Provider.of<PUser>(context, listen: false);

    
    isLogin = Provider.of<PUser>(context).isLogin;
    _user = isLogin ? Provider.of<PUser>(context).user : null;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
    ));

    print(DBUser.getUser().toString());

    print('------------ loading: $_isload');

    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    final ImagePicker _picker = ImagePicker();
    XFile? _imageFile;

    void _onImageButtonPressed(ImageSource source, {BuildContext? context }) async {
      try {
        final pickedFile = await _picker.pickImage(
          source: source,
        );
        setState(() {
          _isload = true;
        });
        _imageFile = pickedFile;
        File file = File(_imageFile!.path);
        final base64Image = base64Encode(file.readAsBytesSync());
        final image = await updateAvatar(base64: base64Image, userID: _user!.idTK);
        final reloadUser = await loginRequest(username: _user!.username, password: _user!.password);
        setState(() {
          _isload = false;
        });
        if (reloadUser != null) {
          Provider.of<PUser>(context!, listen: false).login(reloadUser);
        }
        print('-------- image: $image');
        // _user!.avt = image;
        // Provider.of<PUser>(context!, listen: false).setAVT(_user!);
        
      } catch (e) {
        print(e);
        setState(() {
        });
      }
      
    }

    Widget _dividerControl = const Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Divider(
        height: 0,
        thickness: 2,
      ),
    );

    Widget _divider = Divider(
      thickness: 23,
      height: 18,
      color: Colors.grey.shade300,
    );

    Widget _userInformation = Container(
        color: Colors.transparent,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              width: _width,
              height: _width / 2.45,
              color: Colors.blueGrey,
            ),
            Column(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: _width / 3.5,
                          width: _width / 3.5,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(365),
                          ),
                        ),
                        CachedNetworkImage(
                          imageUrl: '${kUrlServer}/images/${_user!.avt}',
                          cacheKey: DateTime.now().toIso8601String(),
                          imageBuilder: (context, imageProvider) {
                            return Container(
                              height: _width / 4,
                              width: _width / 4,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                ),
                                borderRadius: BorderRadius.circular(365),
                              ),
                            );
                          },
                          placeholder: (context, url) {
                            return Container(
                              height: _width / 4,
                              width: _width / 4,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(365),
                              ),
                              child: Center(
                                child: LoadingWidget(color: Colors.orange.shade700),
                              ),
                            );
                          },
                          errorWidget: (context, url, error) {
                            return Container(
                              height: _width / 5,
                              width: _width / 5,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(kAvtNull),
                                ),
                                borderRadius: BorderRadius.circular(365),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        // Todo: select image to set avatar
                        showModalBottomSheet<int>(
                          isDismissible: true,
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              height: _height / 4,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  TextButton.icon(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      _onImageButtonPressed(ImageSource.camera, context: context);
                                    }, 
                                    icon: Icon(Icons.camera, size: _width / 8, color: Colors.amber,),
                                    label: Text('Camera', style: TextStyle(fontSize: _width / 18),),
                                  ),
                                  TextButton.icon(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      _onImageButtonPressed(ImageSource.gallery, context: context);
                                    }, 
                                    icon: Icon(Icons.image_outlined, size: _width / 8, color: Colors.green.shade400,),
                                    label: Text('Gellary', style: TextStyle(fontSize: _width / 18),),
                                  )
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        height: _width / 12,
                        width: _width / 12,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(365),
                        ),
                        child: Icon(
                          CupertinoIcons.camera,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  _user!.hoTen,
                  style: TextStyle(color: Colors.white, fontSize: _width / 12),
                ),
                Row(
                  children: [
                    const Spacer(),
                    Text(
                      'Hạng thành viên',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: _width / 16,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      _user!.member.loaiThanhVien,
                      style: TextStyle(
                        fontSize: _width / 16,
                        color: Colors.orange,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 35),
              ],
            ),
          ],
        ));

    Widget _thanhVien = Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  CupertinoIcons.star_circle,
                  size: _width / 16,
                ),
                Text(
                  'Mã thành viên',
                  style: TextStyle(
                    fontSize: _width / 16,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(UpgradeRankPage.id);
                  },
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(horizontal: 15),
                    ),
                    backgroundColor: MaterialStateProperty.all(Colors.orange),
                  ),
                  child: const Text(
                    'Nâng hạng',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            if (_user!.member.loaiThanhVien == 'ĐỒNG')
            CopperRank(width: _width, user: _user),
            if (_user!.member.loaiThanhVien == 'BẠC')
            SilverRank(width: _width, user: _user),
            if (_user!.member.loaiThanhVien == 'VÀNG')
            GoldRank(width: _width, user: _user),
            if (_user!.member.loaiThanhVien == 'KIM CƯƠNG')
            DiamondRank(width: _width, user: _user),
            const SizedBox(height: 20),

            // Container(
            //   margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            //   alignment: Alignment.centerLeft,
            //   child: Text(
            //     'Quyền lợi dành riêng',
            //     style: TextStyle(
            //       fontSize: _width / 15,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );

    Widget _control = Container(
      child: Column(
        children: [
          _buttonControl(
            title: 'Thông tin cá nhân',
            icon: CupertinoIcons.person_circle,
            onClick: () {
              PersistentNavBarNavigator.pushNewScreen(
                context,
                screen: const UserInfoPage(),
                withNavBar: true, // OPTIONAL VALUE. True by default.
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );
            },
          ),
          _dividerControl,
          _buttonControl(
            title: 'Thay đổi mật khẩu',
            icon: CupertinoIcons.lock_shield,
            onClick: () {
              Navigator.of(context).pushNamed(ChangePasswordUser.id);
            },
          ),
          // _dividerControl,
          // _buttonControl(
          //   title: 'Mã khuyến mãi của tôi',
          //   icon: CupertinoIcons.gift,
          //   onClick: () {},
          // ),
          _dividerControl,
          _buttonControl(
            title: 'Lịch sử',
            icon: CupertinoIcons.timer,
            onClick: () {
              print('click lịch sử');
              PersistentNavBarNavigator.pushNewScreen(
                context,
                screen: const HistoryBooked(),
                withNavBar: true, // OPTIONAL VALUE. True by default.
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );
            },
          ),
        ],
      ),
    );

    Widget _buttonSignout = Container(
      child: ListTile(
        onTap: () {
          messageAlert(
            context, 
            'Bạn có muốn đăng xuất?',
            color: Colors.blue.shade400,
            onPressOK: () {
              Provider.of<PUser>(context, listen: false).signout();
              isUpdateBottomBar = true;
              RestartWidget.restartApp(context);
            },
            onPressCancel: () {

            }
          );
          
        },
        title: Align(
          child: Text(
            'Đăng xuất',
            style: TextStyle(
              fontSize: _width / 15,
              color: Color.fromARGB(255, 253, 63, 49),
            ),
          ),
        ),
      ),
    );

    final _name = Provider.of<PUser>(context).user!.username;

    return Stack(
      children: [
        Image.asset(
          kBanner,
          fit: BoxFit.cover,
          height: 165,
        ),
        RefreshIndicator(
          onRefresh: () async { 
            setState(() {
              _isload = true;
            });
            final reloadUser = await loginRequest(username: _user!.username, password: _user!.password);
            if (reloadUser != null) {
              Provider.of<PUser>(context, listen: false).login(reloadUser);
            }
            setState(() {
              _isload = false;
            });
            return Future.delayed(Duration(milliseconds: 500));
          },
          child: SafeArea(
            child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height,
                      width: _width,
                      color: Colors.white,
                    ),
                    Column(
                      children: [
                        const SizedBox(height: 45),
                        _userInformation,
                        _thanhVien,
                        _divider,
                        _control,
                        _divider,
                        _buttonSignout,
                        Divider(
                          thickness: 50,
                          height: 50.5,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 55),
                      ],
                    ),
                  ],
                )),
          ),
        ),
        if (_isload) 
          Container(
            height: _height,
            width: _width,
            color: Colors.black54,
            child: LoadingWidget(),
          )
      ],
    );
  }
}

class CopperRank extends StatelessWidget {
  CopperRank({
    Key? key,
    required double width,
    required User? user,
    DateTime? this.ngayTao
  }) : _width = width, _user = user, super(key: key);

  final double _width;
  final User? _user;
  late DateTime? ngayTao;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            offset: Offset(3, 4),
            blurRadius: 5,
            color: Colors.grey,
          )
        ],
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomCenter,
          colors: [
            // Color.fromARGB(255, 192, 192, 192),
            // Color.fromARGB(255, 201, 201, 201),
            // Color.fromARGB(255, 211, 211, 211),
            Color.fromARGB(255, 199, 159, 48),
            Color.fromARGB(255, 185, 118, 29),
            Color.fromARGB(255, 129, 84, 0),
          ],
        ),
      ),
      height: 240,
      width: _width,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  kLogoApp,
                  width: 50,
                ),
                const SizedBox(width: 10),
                Text(
                  'MOONLIGHT',
                  style: TextStyle(
                    fontSize: (_width - 15) / 18,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                Text(
                  'COPPER',
                  style: TextStyle(
                    fontSize: (_width - 15) / 18,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        // Todo: change name user
                        _user!.hoTen,
                        style: TextStyle(
                          fontSize: (_width - 15) / 17,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        // Todo: change code
                        _user!.idTK,
                        style: TextStyle(
                          fontSize: (_width - 15) / 15,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'MEMBER SINCE',
                            style: TextStyle(
                              fontSize: (_width - 15) / 25,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '${DateFormat('MMM dd yyyy').format(ngayTao ?? _user!.member.ngayTao)}',
                            style: TextStyle(
                              fontSize: (_width - 15) / 18,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                      
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SilverRank extends StatelessWidget {
  SilverRank({
    Key? key,
    required double width,
    required User? user,
    DateTime? this.ngayTao
  }) : _width = width, _user = user, super(key: key);

  final double _width;
  final User? _user;
  late DateTime? ngayTao;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            offset: Offset(3, 4),
            blurRadius: 5,
            color: Colors.grey,
          )
        ],
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomCenter,
          colors: [
            // Color.fromARGB(255, 192, 192, 192),
            // Color.fromARGB(255, 201, 201, 201),
            // Color.fromARGB(255, 211, 211, 211),
            Color.fromARGB(255, 200, 200, 200),
            Color.fromARGB(255, 185, 185, 185),
            Color.fromARGB(255, 140, 140, 140),
          ],
        ),
      ),
      height: 240,
      width: _width,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  kLogoApp,
                  width: 50,
                ),
                const SizedBox(width: 10),
                Text(
                  'MOONLIGHT',
                  style: TextStyle(
                    fontSize: (_width - 15) / 18,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                Text(
                  'SIVLER',
                  style: TextStyle(
                    fontSize: (_width - 15) / 18,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        // Todo: change name user
                        _user!.hoTen,
                        style: TextStyle(
                          fontSize: (_width - 15) / 17,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        // Todo: change code
                        _user!.idTK,
                        style: TextStyle(
                          fontSize: (_width - 15) / 15,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'MEMBER SINCE',
                            style: TextStyle(
                              fontSize: (_width - 15) / 25,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '${DateFormat('MMM dd yyyy').format(ngayTao ?? _user!.member.ngayTao)}',
                            style: TextStyle(
                              fontSize: (_width - 15) / 18,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(width: 35,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'VALID THRU',
                            style: TextStyle(
                              fontSize: (_width - 15) / 25,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '${DateFormat('MMM dd yyyy').format(ngayTao?.add(Duration(days: 365)) ?? _user!.member.ngayTao.add(Duration(days: 365)))}',
                            style: TextStyle(
                              fontSize: (_width - 15) / 18,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class GoldRank extends StatelessWidget {
  GoldRank({
    Key? key,
    required double width,
    required User? user,
    DateTime? this.ngayTao
  }) : _width = width, _user = user, super(key: key);

  final double _width;
  final User? _user;
  late DateTime? ngayTao;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            offset: Offset(3, 4),
            blurRadius: 5,
            color: Colors.grey,
          )
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomCenter,
          colors: [
            // Color.fromARGB(255, 192, 192, 192),
            // Color.fromARGB(255, 201, 201, 201),
            // Color.fromARGB(255, 211, 211, 211),
            Color(0xffc79938),
            Color(0xffcfa64c),
            Color(0xffd3ae57),
          ],
        ),
      ),
      height: 240,
      width: _width,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  kLogoApp,
                  width: 50,
                ),
                const SizedBox(width: 10),
                Text(
                  'MOONLIGHT',
                  style: TextStyle(
                    fontSize: (_width - 15) / 18,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                Text(
                  'GOLD',
                  style: TextStyle(
                    fontSize: (_width - 15) / 18,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        // Todo: change name user
                        _user!.hoTen,
                        style: TextStyle(
                          fontSize: (_width - 15) / 17,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        // Todo: change code
                        _user!.idTK,
                        style: TextStyle(
                          fontSize: (_width - 15) / 15,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'MEMBER SINCE',
                            style: TextStyle(
                              fontSize: (_width - 15) / 25,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '${DateFormat('MMM dd yyyy').format(ngayTao ?? _user!.member.ngayTao)}',
                            style: TextStyle(
                              fontSize: (_width - 15) / 18,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(width: 35,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'VALID THRU',
                            style: TextStyle(
                              fontSize: (_width - 15) / 25,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '${DateFormat('MMM dd yyyy').format(ngayTao?.add(Duration(days: 365)) ?? _user!.member.ngayTao.add(Duration(days: 365)))}',
                            style: TextStyle(
                              fontSize: (_width - 15) / 18,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DiamondRank extends StatelessWidget {
  DiamondRank({
    Key? key,
    required double width,
    required User? user,
    DateTime? this.ngayTao
  }) : _width = width, _user = user, super(key: key);

  final double _width;
  final User? _user;
  late DateTime? ngayTao;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            offset: Offset(3, 4),
            blurRadius: 5,
            color: Colors.grey,
          )
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomCenter,
          colors: [
            // Color.fromARGB(255, 192, 192, 192),
            // Color.fromARGB(255, 201, 201, 201),
            // Color.fromARGB(255, 211, 211, 211),
            Colors.black87,
            Colors.black45,
            Colors.black26,
          ],
        ),
      ),
      height: 240,
      width: _width,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  kLogoApp,
                  width: 50,
                ),
                const SizedBox(width: 10),
                Text(
                  'MOONLIGHT',
                  style: TextStyle(
                    fontSize: (_width - 15) / 18,
                    color: Color(0xffcfb775),
                  ),
                ),
                const Spacer(),
                Text(
                  'DIAMOND',
                  style: TextStyle(
                    fontSize: (_width - 15) / 18,
                    color: Color(0xffcfb775),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        // Todo: change name user
                        _user!.hoTen,
                        style: TextStyle(
                          fontSize: (_width - 15) / 17,
                          color: Color(0xffcfb775),
                        ),
                      ),
                      Text(
                        // Todo: change code
                        _user!.idTK,
                        style: TextStyle(
                          fontSize: (_width - 15) / 15,
                          color: Color(0xffcfb775),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'MEMBER SINCE',
                            style: TextStyle(
                              fontSize: (_width - 15) / 25,
                              color: Color(0xffcfb775),
                            ),
                          ),
                          Text(
                            '${DateFormat('MMM dd yyyy').format(ngayTao ?? _user!.member.ngayTao)}',
                            style: TextStyle(
                              fontSize: (_width - 15) / 18,
                              color: Color(0xffcfb775),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(width: 35,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'VALID THRU',
                            style: TextStyle(
                              fontSize: (_width - 15) / 25,
                              color: Color(0xffcfb775),
                            ),
                          ),
                          Text(
                            '${DateFormat('MMM dd yyyy').format(ngayTao?.add(Duration(days: 365)) ?? _user!.member.ngayTao.add(Duration(days: 365)))}',
                            style: TextStyle(
                              fontSize: (_width - 15) / 18,
                              color: Color(0xffcfb775),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _buttonControl extends StatelessWidget {
  const _buttonControl({
    Key? key,
    required this.title,
    required this.onClick,
    required this.icon,
  }) : super(key: key);

  final String title;
  final Function onClick;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onClick();
      },
      contentPadding: EdgeInsets.symmetric(horizontal: 23, vertical: 5),
      leading: Icon(icon),
      minLeadingWidth: 10,
      title: Text(
        title,
        style: TextStyle(
          fontSize: MediaQuery.of(context).size.width / 20,
        ),
      ),
      trailing: Icon(CupertinoIcons.chevron_forward),
    );
  }
}
