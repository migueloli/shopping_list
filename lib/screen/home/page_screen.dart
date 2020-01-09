import 'package:flutter/material.dart';
import 'package:shopping_list/screen/home/pages/completed_page.dart';
import 'package:shopping_list/screen/home/pages/pending_page.dart';
import 'package:shopping_list/screen/new_item/new_item_screen.dart';
import 'package:shopping_list/util/constants.dart';

class PageScreen extends StatefulWidget {
  @override
  _PageScreenState createState() => _PageScreenState();
}

class _PageScreenState extends State<PageScreen> {

  final PageController _pageController = PageController();
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: (page) {
          setState(() {
            _page = page;
          });
        },
        children: <Widget>[
          PendingPage(),
          CompletedPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _page,
        onTap: (page) {
          _pageController.animateToPage(
              page,
              duration: Duration(
                  milliseconds: 300
              ),
              curve: Curves.ease);
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.inbox),
            title: Text(status[0]),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            title: Text(status[1]),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => NewItemScreen(),
        )),
      ),
    );
  }
}
