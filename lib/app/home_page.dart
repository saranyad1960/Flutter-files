import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  PageController _pageController = PageController();
  List<String> _titles = ['Dashboard', 'Orders', 'Products', 'Store Details'];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red.shade600,
        automaticallyImplyLeading: false,
        title: Center(child: Text(_titles[_currentIndex])),
      ),
      body: PageView(
        controller: _pageController,
        children: <Widget>[
          Center(
            child: Text('Dashboard Content'),
          ),
          Center(
            child: Text('Orders Content'),
          ),
          Center(
            child: Text('Products Content'),
          ),
          Center(
            child: Text('Store Details Content'),
          ),
        ],
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.green,
        onTap: _onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard,
              color: _currentIndex == 0 ? Colors.green : Colors.grey,),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment,
              color: _currentIndex == 1 ? Colors.green : Colors.grey,),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart,
              color: _currentIndex == 2 ? Colors.green : Colors.grey,),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store,
              color: _currentIndex == 3 ? Colors.green : Colors.grey,),
            label: 'Store Details',
          ),
        ],
      ),
    );
  }
}
