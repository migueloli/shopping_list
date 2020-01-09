import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shopping_list/controllers/shopping_list.dart';
import 'package:shopping_list/screen/home/page_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

    return Provider<ShoppingList>(
      create: (context) => ShoppingList(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Shoppinglist',
        theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.deepOrange,
          primaryColor: Colors.deepOrange,
          primaryColorDark: Colors.black,
          accentColor: Colors.deepOrangeAccent
        ),
        home: PageScreen(),
      ),
      dispose: (context, list) {
        list.dispose();
      },
    );
  }

}