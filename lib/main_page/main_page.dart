import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../loans/loan_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  // IOWebSocketChannel? channel;
  bool isConnected = false;
  bool hasError = false;
  // ProfileBloc profileBloc = ProfileBloc();
  Map<String, dynamic>? content;

  static const List<Widget> _widgetOptions = <Widget>[
    LoanPage(),
    // TermsPage(),
    // BirthdayPage(),
    // MemoryPage(),
    // TrackerPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }




  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SizedBox(
        height: 0.12.sh,
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          iconSize: 30,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xff16171B),
          unselectedItemColor: const Color(0xffFFFFFF),
          items: const [
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.clipboardList),
              label: "Loan",
            ),
            // BottomNavigationBarItem(
            //   icon: FaIcon(FontAwesomeIcons.houseLaptop),
            //   label: "Alarms",
            // ),
            // BottomNavigationBarItem(
            //   icon: FaIcon(FontAwesomeIcons.bell),
            //   label: "AlertManager",
            // ),
            // BottomNavigationBarItem(
            //   icon: FaIcon(FontAwesomeIcons.user),
            //   label: "Account",
            // ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
    );
  }

}