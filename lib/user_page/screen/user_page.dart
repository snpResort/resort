import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:resort/auth/repository/p_user.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  static String id = '/user';

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    final _name = Provider.of<PUser>(context).user!.username;
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Text(_name),
            ),
          ],
        ),
      ),
    );
  }
}
