import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:practice_7/constant/textstyle.dart';
import 'package:practice_7/routes/routes.dart';
import 'package:practice_7/utils/extension.dart';
import 'package:badges/badges.dart' as badges;
import 'package:practice_7/utils/file_add_to_cart_helper.dart';
import 'package:practice_7/utils/login_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({
    super.key,
  });

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  void initState() {
    super.initState();
    _updateCartCount();
    getUserName();
  }

  String username = "";

  void getUserName() async {
    var pref = await SharedPreferences.getInstance();
    var username1 = pref.getString('username');
    setState(() {
      username = username1!;
    });

    var name = await LoginHelper.getUserDetails(username);

    setState(() {
      fullName = "${name?["first_name"]} ${name?["last_name"]}";
    });
  }

  int cartCount = 0;
  var fullName = "";

  Future<void> _updateCartCount() async {
    // Fetch the cart count using Add2Cart
    final count = await AddToCart.countItemsInCart();
    setState(() {
      cartCount = count;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Setting',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: false,
        actions: [
          Padding(
            padding: EdgeInsets.only(
              right: context.scrnWidth * 0.04,
            ),
            child: badges.Badge(
              badgeContent: Text(
                '$cartCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    Routes.cart,
                  );
                },
                child: SvgPicture.asset(
                  'assets/svg/cart 02.svg',
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: context.scrnHeight * 0.015,
            ),
            child: Container(
              color: Colors.white,
              height: context.scrnHeight * 0.1,
              width: double.infinity,
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: context.scrnWidth * 0.05,
                    ),
                    child: Container(
                      width: context.scrnWidth * 0.16,
                      height: context.scrnHeight * 0.08,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          fullName.isNotEmpty
                              ? '${fullName[0]}${fullName.split(" ").last[0]}'
                              : '',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: context.scrnWidth * 0.05),
                  SizedBox(
                    height: context.scrnHeight * 0.06,
                    width: context.scrnWidth * 0.7,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          fullName,
                          style: pfnameStyle,
                        ),
                        Text(
                          username,
                          style: pfdobStyle,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, Routes.myOrder, arguments: false);
            },
            child: Padding(
              padding: EdgeInsets.only(
                top: context.scrnHeight * 0.015,
                bottom: 0,
              ),
              child: Container(
                padding: EdgeInsets.zero,
                color: Colors.white,
                height: context.scrnHeight * 0.06,
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: context.scrnWidth * 0.05,
                      ),
                      child: SvgPicture.asset(
                        'assets/svg/bill.svg',
                      ),
                    ),
                    SizedBox(width: context.scrnWidth * .025),
                    const Text(
                      'My Orders',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.grey.shade300,
            thickness: 1,
            height: 1,
          ),
          Padding(
            padding: EdgeInsets.zero,
            child: Container(
              padding: EdgeInsets.zero,
              color: Colors.white,
              height: context.scrnHeight * 0.06,
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: context.scrnWidth * 0.05,
                    ),
                    child: SvgPicture.asset(
                      'assets/svg/globe.svg',
                    ),
                  ),
                  SizedBox(width: context.scrnWidth * .025),
                  const Text(
                    'Change Language',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: context.scrnHeight * 0.015,
              bottom: 0,
            ),
            child: Container(
              padding: EdgeInsets.zero,
              color: Colors.white,
              height: context.scrnHeight * 0.06,
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: context.scrnWidth * 0.05,
                    ),
                    child: SvgPicture.asset(
                      'assets/svg/information.svg',
                    ),
                  ),
                  SizedBox(width: context.scrnWidth * .025),
                  const Text(
                    'About',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(
            color: Colors.grey.shade300,
            thickness: 1,
            height: 1,
          ),
          Padding(
            padding: EdgeInsets.zero,
            child: Container(
              padding: EdgeInsets.zero,
              color: Colors.white,
              height: context.scrnHeight * 0.06,
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: context.scrnWidth * 0.05,
                    ),
                    child: SvgPicture.asset(
                      'assets/svg/bag-1-svgrepo-com.svg',
                    ),
                  ),
                  SizedBox(width: context.scrnWidth * .025),
                  const Text(
                    'Privicy',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: context.scrnHeight * 0.015,
              bottom: 0,
            ),
            child: GestureDetector(
              onTap: () async {
                bool? confirmLogout = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      title: const Text('Logout'),
                      content: const Text('Are you sure you want to logout?'),
                      actions: <Widget>[
                        ElevatedButton(
                          style: eleBttnStyle(context),
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          child: const Text('Cancel'),
                        ),
                        SizedBox(height: context.scrnHeight * 0.01),
                        ElevatedButton(
                          style: eleBttnStyle(context),
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          child: const Text('Logout'),
                        )
                      ],
                    );
                  },
                );

                if (confirmLogout == true) {
                  var pref = await SharedPreferences.getInstance();
                  await pref.clear();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    Routes.login,
                    (Route<dynamic> route) => false,
                  );
                }
              },
              child: Container(
                padding: EdgeInsets.zero,
                color: Colors.white,
                height: context.scrnHeight * 0.06,
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: context.scrnWidth * 0.05,
                      ),
                      child: SvgPicture.asset(
                        'assets/svg/logout 01.svg',
                      ),
                    ),
                    SizedBox(width: context.scrnWidth * .025),
                    const Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
