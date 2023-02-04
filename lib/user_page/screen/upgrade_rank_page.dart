import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:resort/auth/repository/p_user.dart';
import 'package:resort/auth/request/login_request.dart';
import 'package:resort/constant/app_colors.dart';
import 'package:resort/constant/app_numbers.dart';
import 'package:resort/constant/app_string.dart';
import 'package:resort/user_page/request/user_request.dart';
import 'package:resort/user_page/screen/user_page.dart';
import 'package:resort/widgets/loading_widget.dart';
import 'package:resort/widgets/message_alert.dart';
import 'package:resort/widgets/payment_method.dart';
import 'package:resort/widgets/rounded_button.dart';

class UpgradeRankPage extends StatefulWidget {
  const UpgradeRankPage({super.key});

  static String id = 'UpgradeRankPage';

  @override
  State<UpgradeRankPage> createState() => _UpgradeRankPageState();
}

class _UpgradeRankPageState extends State<UpgradeRankPage> {

  PUser? puser;
  List sales = [];
  bool isLoad = false;
  final oCcyMoney = NumberFormat("#,##0");
  final oCcySale = NumberFormat("#.##");
  
  String _paymentMethod = 'https://upload.wikimedia.org/wikipedia/vi/f/fe/MoMo_Logo.png';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoad = true;
    saleMember().then((value) {
      setState(() {
        sales.addAll(value);
        isLoad = false;
      });
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    puser = Provider.of<PUser>(context, listen: true);
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    int flag = 0;

    return Stack(
      children: [
        Image.asset(
          kBg1,
          fit: BoxFit.fill,
          height: _height,
          width: _width,
        ),
        if (sales.isNotEmpty)
        DefaultTabController(
          length: 4,
          child: Scaffold(
            appBar: AppBar(
              elevation: 1,
              backgroundColor: Colors.white,
              centerTitle: true,
              leading: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(
                  CupertinoIcons.back,
                  color: Colors.black,
                ),
              ),
              title: Text(
                'Nâng cấp thành viên',
                style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
              ),
              bottom: TabBar(
                tabs: sales.map((sale) {
                  return Tab(
                    child: Stack(children: [
                      Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        child: Text(
                          sale['TenLoai'], 
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      if (puser!.user!.member.loaiThanhVien == sale['TenLoai'] )
                      Container(
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(50)
                        ),
                      )
                    ],));
                }).toList() 
                // [
                //   Tab(child: Text('Đồng', style: TextStyle(color: Colors.black),)),
                //   Tab(child: Text('Bạc', style: TextStyle(color: Colors.black),)),
                //   Tab(child: Text('Vàng', style: TextStyle(color: Colors.black),)),
                //   Tab(child: Text('Kim cương', style: TextStyle(color: Colors.black),)),
                // ]
              ),
            ),
            body: TabBarView(
              children: sales.map((sale) {
                return Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(20),
                      child: sale['TenLoai'] == 'ĐỒNG' 
                        ? CopperRank(
                          width: _width, 
                          user: puser!.user,
                          ngayTao: DateTime.now(),
                        ) 
                        : sale['TenLoai'] == 'BẠC'  
                          ? SilverRank(
                            width: _width, 
                            user: puser!.user,
                            ngayTao: DateTime.now(),
                          ) 
                          : sale['TenLoai'] == 'VÀNG'
                            ? GoldRank(
                              width: _width, 
                              user: puser!.user,
                              ngayTao: DateTime.now(),
                            ) : DiamondRank(
                              width: _width, 
                              user: puser!.user,
                              ngayTao: DateTime.now(),
                            ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text('Khuyến mãi:',
                                  style: TextStyle(
                                    fontSize: _width / 16,
                                  )
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  '${oCcySale.format(sale['KhuyenMai'] * 100)} %',
                                  style: TextStyle(
                                    fontSize: _width / 16,
                                  )
                                ),
                              )
                            ],
                          ),
                          if (sale['TenLoai'] != 'ĐỒNG') 
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                child: Text('Giá:',
                                  style: TextStyle(
                                    fontSize: _width / 16,
                                  )
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  '${oCcyMoney.format(sale['Gia'])} ₫/năm',
                                  style: TextStyle(
                                    fontSize: _width / 16,
                                  )
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30,),
                    if (sale['TenLoai'] != 'ĐỒNG') 
                    RoundedButton(
                      color: puser!.user!.member.id >= sale['Id'] 
                        ? Colors.grey.shade600
                        : Colors.orange, 
                      title: 'Nâng cấp',
                      onPressed: puser!.user!.member.id >= sale['Id'] 
                        ? null : () {
                          // todo: nâng cấp tài khoản
                          showDialog(
                            barrierDismissible: false,
                            context: context, 
                            builder: (context) => AlertDialog(
                              titlePadding: EdgeInsets.zero,
                              contentPadding: EdgeInsets.zero,
                              title: StatefulBuilder(
                                builder: (context, setState) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(AppNumbers.buttonRadius),
                                    ),
                                    width: MediaQuery.of(context).size.width / 1.1,
                                    child: Stack(
                                      children: [
                                        Container(
                                          height: _paymentMethod == 'atm' ? _height / 2.4 : null,
                                          padding: EdgeInsets.all(20),
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                Text('Thanh toán', style: TextStyle(fontSize: _width/15),),
                                                SizedBox( height: 20, ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      sale['TenLoai'],
                                                      style: TextStyle(fontWeight: FontWeight.bold),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                    Text(
                                                      '${oCcyMoney.format(sale['Gia'])} ₫/năm',
                                                      style: TextStyle(fontWeight: FontWeight.bold),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ],
                                                ),
                                                SizedBox( height: 20, ),
                                                const Divider(thickness: 2,),
                                                SizedBox( height: 20, ),
                                                GestureDetector(
                                                  onTap: () {
                                                    // Todo show select method pay
                                                    paymentMethod(context, onPress: (val) {
                                                      setState(() {
                                                        _paymentMethod = val;
                                                      });
                                                    });
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(
                                                        'Phương thức thanh toán',
                                                        style: TextStyle(
                                                          fontSize: _width / 20,
                                                          fontWeight: FontWeight.w400,
                                                        ),
                                                      ),
                                                      if (_paymentMethod.isNotEmpty && _paymentMethod != 'atm')
                                                        CachedNetworkImage(imageUrl: _paymentMethod, height: 40, width: 40),
                                                      Icon(Icons.arrow_forward_ios),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox( height: 20, ),
                                                if (_paymentMethod == 'atm')
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    TextField(
                                                      inputFormatters: [
                                                        MaskTextInputFormatter(mask: "#### #### #### ####"),
                                                      ],
                                                      // obscureText: _obscureTextPw,
                                                      // focusNode: _focusPw,
                                                      keyboardType: TextInputType.number,
                                                      decoration: InputDecoration(
                                                        hintText: 'Số thẻ',
                                                        fillColor: Colors.white,
                                                        filled: true,
                                                        border: const OutlineInputBorder(),
                                                        prefixIcon: Icon(Icons.atm_outlined),
                                                      ),
                                                      // controller: _pw,
                                                    ),
                                                    SizedBox( height: 20, ),
                                                    TextField(
                                                      // obscureText: _obscureTextPw,
                                                      // focusNode: _focusPw,
                                                      keyboardType: TextInputType.number,
                                                      inputFormatters: [
                                                        MaskTextInputFormatter(mask: "##/##"),
                                                      ],
                                                      decoration: InputDecoration(
                                                        hintText: 'YY/MM',
                                                        fillColor: Colors.white,
                                                        filled: true,
                                                        border: const OutlineInputBorder(),
                                                      ),
                                                      // controller: _pw,
                                                    ),
                                                    SizedBox( height: 20, ),
                                                    TextField(
                                                      // obscureText: _obscureTextPw,
                                                      // focusNode: _focusPw,
                                                      keyboardType: TextInputType.number,
                                                      decoration: InputDecoration(
                                                        hintText: 'CVC',
                                                        fillColor: Colors.white,
                                                        filled: true,
                                                        border: const OutlineInputBorder(),
                                                      ),
                                                      // controller: _pw,
                                                    ),
                                                  ],
                                                ),
                                                SizedBox( height: 25, ),
                                                isLoad ? LoadingWidget(color: Colors.yellow.shade700,) : RoundedButton(
                                                  onPressed: () async { 
                                                    setState(() {
                                                      isLoad = true;
                                                    });
                                                    final rs = await updateMember(user_id: puser!.user!.idTK, id_level: '${sale['Id']}');
                                          
                                                    final reloadUser = await loginRequest(username: puser!.user!.username, password: puser!.user!.password);
                                                    if (reloadUser != null) {
                                                      Provider.of<PUser>(context, listen: false).login(reloadUser);
                                                    }
                                          
                                                    messageAlert(
                                                      context, 
                                                      rs,
                                                      color: rs == 'Error' ? null : Colors.blue.shade400,
                                                      onPressOK: rs == 'Error' ? null : () {   
                                                        Navigator.of(context).pop();     
                                                      }
                                                    );
                                          
                                                    setState(() {
                                                      isLoad = false;
                                                    });
                                                  },
                                                  color: Colors.yellow.shade700, 
                                                  title: 'Thanh toán')
                                              ],
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 0,
                                          right: 0,
                                          child: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                _paymentMethod = '';
                                              });
                                              Navigator.of(context).pop();
                                            }, 
                                            icon: Icon(Icons.close, color: Colors.red,)
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }
                              ),
                            ),
                          );
                        },
                    )
                  ],
                );
              }).toList()
            ),
          ),
        ),
        if (isLoad) 
          Container(
            height: _height,
            width: _width,
            color: Colors.black54,
            child: Center(
              child: LoadingWidget(),
            ),
          )
      ],
    );
  }
}