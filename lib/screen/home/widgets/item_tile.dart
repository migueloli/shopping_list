import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shopping_list/models/item/item.dart';
import 'package:shopping_list/screen/new_item/new_item_screen.dart';

class ShoppingTile extends StatelessWidget {

  final Item item;
  final DismissDirectionCallback onDismiss;

  ShoppingTile(this.item, {this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key("${item.id} - ${item.description}"),
      child: ListTile(
        leading: item.status == 0
            ? Icon(Icons.fastfood)
            : Icon(Icons.check),
        title: Text(item.getTitle()),
        subtitle: item.location.isNotEmpty ? Text(item.location) : null,
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => NewItemScreen(item: item,),
        )),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: onDismiss,
      background: Container(),
      dragStartBehavior: DragStartBehavior.start,
      secondaryBackground: Container(
        margin: const EdgeInsets.all(8),
        color: Colors.green,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            item.status == 0
                ? Text("Comprado")
                : Text("Comprar"),
            const SizedBox(width: 20,),
            Icon(Icons.compare_arrows),
            const SizedBox(width: 30,),
          ],
        ),
      ),
    );
  }
}
