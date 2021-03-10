import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomBar extends StatefulWidget {

    dynamic changePageHandler;
    dynamic changeCurrentIndex;

    BottomBar({this.changePageHandler,this.changeCurrentIndex});

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {

  int _selectedIndex = 2;

  _onItemTapped(int selectedOption){
    print(selectedOption);
    // if(_selectedIndex == 0){
    //   widget.changePageHandler("products");
    //   widget.changePageHandler("products");

    // }else if(_selectedIndex == 3){
    //   widget.changePageHandler("orders");
  
    // }else if(_selectedIndex == 1){
    //   widget.changePageHandler("customers");
    // }else if(_selectedIndex == 4){
    //   widget.changePageHandler("settings");
    // }else if(_selectedIndex == 2){
    //   widget.changePageHandler("overview");
    // }

    widget.changeCurrentIndex(selectedOption);
    
    setState(() {
      _selectedIndex = selectedOption;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        backgroundColor: Colors.white,
        unselectedItemColor: Color(0xFFCBC6C6),
        unselectedLabelStyle: TextStyle(color: Colors.black),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.boxes),
            label: 'المنتجات',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.users),
            label: 'العملاء',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.home),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.cartArrowDown),
            label: 'الطلبات',
          ),

          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.store),
            label: 'المتجر',
          ),

        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: (index) => _onItemTapped(index),
      );
  }
}