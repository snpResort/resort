import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:resort/auth/repository/db_user.dart';
import 'package:resort/auth/repository/p_user.dart';
import 'package:resort/constant/app_string.dart';
import 'package:resort/main.dart';
import 'package:resort/user_page/screen/history_booked_page.dart';
import 'package:resort/user_page/screen/user_info_page.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  static String id = '/user';

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    final isLogin = Provider.of<PUser>(context).isLogin;
    final _user = isLogin ? Provider.of<PUser>(context).user : null;

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
          _imageFile = pickedFile;
        });
      } catch (e) {
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
              height: _width / 2.7,
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
                          imageUrl: _user!.avt,
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
                                child: CircularProgressIndicator(),
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
                          isDismissible: false,
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              height: _height / 3,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  TextButton.icon(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      _onImageButtonPressed(ImageSource.camera, context: context);
                                    }, 
                                    icon: Icon(Icons.camera, size: _width / 8,),
                                    label: Text('Camera', style: TextStyle(fontSize: _width / 18),),
                                  ),
                                  TextButton.icon(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      _onImageButtonPressed(ImageSource.gallery, context: context);
                                    }, 
                                    icon: Icon(Icons.image_outlined, size: _width / 8,),
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
                  _user.hoTen,
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
                      _user.member.loaiThanhVien,
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
                  onPressed: () {},
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
            Container(
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
                            fontSize: _width / 18,
                            color: Colors.white,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'COPPER',
                          style: TextStyle(
                            fontSize: _width / 18,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    Text(
                      // Todo: change name user
                      _user.hoTen,
                      style: TextStyle(
                        fontSize: _width / 14,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      // Todo: change code
                      _user.idTK,
                      style: TextStyle(
                        fontSize: _width / 13,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
            icon: CupertinoIcons.person_circle,
            onClick: () {},
          ),
          _dividerControl,
          _buttonControl(
            title: 'Mã khuyến mãi của tôi',
            icon: CupertinoIcons.gift,
            onClick: () {},
          ),
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
          Provider.of<PUser>(context, listen: false).signout();
          isUpdateBottomBar = true;
          RestartWidget.restartApp(context);
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
          height: 155,
        ),
        SafeArea(
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
        )
      ],
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
