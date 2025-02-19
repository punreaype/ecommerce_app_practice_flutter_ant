import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:practice_7/presentation/screens/screen.dart';

class NavigationBarScreen extends StatefulWidget {
  const NavigationBarScreen({super.key});

  @override
  State<NavigationBarScreen> createState() => _NavigationBarScreenState();
}

class _NavigationBarScreenState extends State<NavigationBarScreen> {
  late ScrollController _scrollController;
  bool _isNavBarVisible = true;
  int _selectNavBarIndex = 0;

  void onSelectNavBar(int index) {
    setState(() {
      _selectNavBarIndex = index;
    });
  }

  List<Widget> routes = [];

  var username = "";

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _scrollController.addListener(
      () {
        if (_scrollController.position.userScrollDirection ==
            ScrollDirection.reverse) {
          if (_isNavBarVisible) {
            setState(() {
              _isNavBarVisible = false;
            });
          }
        } else if (_scrollController.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (!_isNavBarVisible) {
            setState(() {
              _isNavBarVisible = true;
            });
          }
        }
      },
    );

    @override
    void dispose() {
      _scrollController.dispose();
      super.dispose();
    }

    routes = [
      HomeScreen(
        scrollController: _scrollController,
      ),
      const WhistlistScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // var username = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      body: _selectNavBarIndex == 2
          ? const SettingScreen()
          : routes[_selectNavBarIndex],
      bottomNavigationBar: AnimatedContainer(
        color: Colors.white,
        duration: const Duration(milliseconds: 500),
        height: _isNavBarVisible ? kBottomNavigationBarHeight : 0,
        child: Wrap(
          children: [
            if (_isNavBarVisible)
              BottomNavigationBar(
                enableFeedback: true,
                elevation: 12,
                backgroundColor: Colors.white,
                unselectedItemColor: Colors.grey,
                items: [
                  BottomNavigationBarItem(
                    icon: _selectNavBarIndex != 0
                        ? SvgPicture.asset('assets/svg/home 03.svg')
                        : SvgPicture.asset('assets/svg/home_solid.svg'),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: _selectNavBarIndex != 1
                        ? SvgPicture.asset('assets/svg/love.svg')
                        : SvgPicture.asset('assets/svg/love_solid.svg'),
                    label: 'Wishlist',
                  ),
                  BottomNavigationBarItem(
                    icon: _selectNavBarIndex != 2
                        ? SvgPicture.asset('assets/svg/setting.svg')
                        : SvgPicture.asset('assets/svg/setting_solid.svg'),
                    label: 'Setting',
                  ),
                ],
                currentIndex: _selectNavBarIndex,
                onTap: (value) => onSelectNavBar(value),
                // selectedItemColor: const Color(0xFFF67FAC),
                selectedItemColor: Colors.black,
              ),
          ],
        ),
      ),
    );
  }
}
