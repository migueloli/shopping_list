import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_list/controllers/shopping_list.dart';
import 'package:shopping_list/models/item/item.dart';
import 'package:shopping_list/screen/home/widgets/item_tile.dart';

class CompletedPage extends StatefulWidget {
  @override
  _CompletedPageState createState() => _CompletedPageState();
}

class _CompletedPageState extends State<CompletedPage> {

  ShoppingList _shopList;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    var shopList = Provider.of<ShoppingList>(context);
    if(_shopList != shopList){
      _shopList = shopList;
      _shopList.getCompletedItens();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ProcessStatus>(
      stream: _shopList.outStComp,
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
              stream: _shopList.outComp,
              initialData: [],
              builder: (context, snapshot) {
                return ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) =>
                    ShoppingTile(
                      snapshot.data[index],
                      onDismiss: (direction) {
                        Item item = snapshot.data[index];
                        if(item.status == 1) {
                          item.cancelCompletion();
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
