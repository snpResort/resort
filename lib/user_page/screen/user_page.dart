import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:resort/auth/repository/p_user.dart';
import 'package:resort/utils/constants.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  static String id = '/user';

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;

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
                        Container(
                          height: _width / 4,
                          width: _width / 4,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                'https://scontent.fsgn19-1.fna.fbcdn.net/v/t39.30808-6/282098508_1477564782675813_5220065825042207171_n.jpg?_nc_cat=101&ccb=1-7&_nc_sid=174925&_nc_ohc=djRn3G8HhXcAX9AR2HG&_nc_ht=scontent.fsgn19-1.fna&oh=00_AfAlFb-8aFRooQNjHCcIm1j2FW92HR70YbCq5Z3C23pCOw&oe=6383B749',
                              ),
                            ),
                            borderRadius: BorderRadius.circular(365),
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {},
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
                  'Từ Huệ Sơn',
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
                      'Bạc',
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
                  child: Text(
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
                    Color.fromARGB(255, 192, 192, 192),
                    Color.fromARGB(255, 201, 201, 201),
                    Color.fromARGB(255, 211, 211, 211),
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
                          'SILVER',
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
                      'Từ Huệ Sơn',
                      style: TextStyle(
                        fontSize: _width / 14,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      // Todo: change code
                      '123 456 789',
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
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.orange,
                      ),
                    ),
                    child: ListTile(
                      onTap: () {},
                      contentPadding: EdgeInsets.zero,
                      leading: Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Icon(
                          Icons.spoke_outlined,
                          color: Colors.orange,
                        ),
                      ),
                      title: Text(
                        'Sử dụng điện thoại làm mã thành viên',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: _width / 18,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  child: Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.orange,
                      ),
                    ),
                    child: Icon(
                      CupertinoIcons.arrowshape_turn_up_right,
                      color: Colors.orange,
                    ),
                  ),
                ),
              ],
            ),
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
            onClick: () {},
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
            onClick: () {},
          ),
        ],
      ),
    );

    Widget _buttonSignout = Container(
      child: ListTile(
        onLongPress: () {},
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
      onTap: () => onClick,
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
