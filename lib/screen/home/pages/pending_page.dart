import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_list/controllers/shopping_list.dart';
import 'package:shopping_list/models/item/item.dart';
import 'package:shopping_list/screen/home/widgets/item_tile.dart';

class PendingPage extends StatefulWidget {
  @override
  _PendingPageState createState() => _PendingPageState();
}

class _PendingPageState extends State<PendingPage> {

  ShoppingList _shopList;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    var shopList = Provider.of<ShoppingList>(context);
    if(_shopList != shopList){
      _shopList = shopList;
      _shopList.getPendingItens();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ProcessStatus>(
      stream: _shopList.outStPend,
      builder: (context, snapshot) {
        if(snapshot.data == ProcessStatus.LOAD){
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.indigoAccent
              ),
            ),
          );
        } else {
          return RefreshIndicator(
            onRefresh: _shopList.getPendingItens,
            child: StreamBuilder<List<Item>>(
              stream: _shopList.outPend,
              initialData: [],
              builder: (context, snapshot) {
                return ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) =>
                    ShoppingTile(
                      snapshot.data[index],
                      onDismiss: (direction) {
                        Item item = snapshot.data[index];
                        if(item.status == 0) {
                          item.setCompletion();
                          _shopList.updateItem(item);
                        }
                      },
                    ),
                  separatorBuilder: (context, index) => Divider(),
                  itemCount: snapshot.data.length
                );
              }
            ),
          );
        }
      },
    );
  }
}
