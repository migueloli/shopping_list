import 'package:barcode_scan/barcode_scan.dart';
import 'package:brasil_fields/formatter/real_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shopping_list/controllers/shopping_list.dart';
import 'package:shopping_list/models/item/item.dart';
import 'package:shopping_list/util/constants.dart';
import 'package:shopping_list/util/format_field.dart';

class NewItemScreen extends StatefulWidget {

  final Item item;

  NewItemScreen({this.item});

  @override
  _NewItemScreenState createState() => _NewItemScreenState();

}

class _NewItemScreenState extends State<NewItemScreen> {

  Item _item;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _barcodeController = TextEditingController(text: "");

  @override
  void initState() {
    super.initState();

    if(widget.item != null && _item == null){
      _item = widget.item;
    }

    if(_item == null){
      _item = Item();
    }

    _barcodeController.text = _item.barcode;
  }

  @override
  Widget build(BuildContext context) {
    const _spacing = SizedBox(height: 16,);

    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.only(top: 8, left: 16, right: 16,),
          children: <Widget>[
            TextFormField(
              initialValue: _item.description,
              decoration: InputDecoration(
                fillColor: Colors.white,
                icon: const Icon(Icons.fastfood),
                labelText: "Descrição",
                labelStyle: TextStyle(color: Colors.white),
              ),
              validator: (description) {
                if(description.length < 3) {
                  return "O descrição precisa ter ao menos 3 caracteres.";
                }

                return null;
              },
              onSaved: (description) {
                _item.description = description;
              },
            ),
            _spacing,
            TextFormField(
              initialValue: _item.quantity?.toString(),
              keyboardType: TextInputType.numberWithOptions(decimal: false, signed: false),
              inputFormatters: [
                WhitelistingTextInputFormatter.digitsOnly,
                RealInputFormatter(centavos: false),
              ],
              decoration: InputDecoration(
                fillColor: Colors.white,
                icon: const Icon(Icons.inbox),
                labelText: "Quantidade",
                labelStyle: TextStyle(color: Colors.white),
              ),
              onSaved: (quantity) {
                if(quantity.isEmpty){
                  _item.quantity = null;
                } else {
                  _item.quantity = int.tryParse(getSanitizedText(quantity));
                }
              },
            ),
            _spacing,
            TextFormField(
              initialValue: _item.value?.toString(),
              keyboardType: TextInputType.numberWithOptions(decimal: true, signed: false),
              inputFormatters: [
                RealInputFormatter(centavos: true),
              ],
              decoration: InputDecoration(
                fillColor: Colors.white,
                icon: const Icon(Icons.attach_money),
                labelText: "Preço",
                labelStyle: TextStyle(color: Colors.white),
              ),
              onSaved: (value) {
                if(value.isEmpty){
                  _item.value = null;
                } else {
                  _item.value = double.tryParse(value);
                }
              },
            ),
            _spacing,
            TextFormField(
              initialValue: _item.location,
              decoration: InputDecoration(
                fillColor: Colors.white,
                icon: const Icon(Icons.location_searching),
                labelText: "Local",
                labelStyle: TextStyle(color: Colors.white),
              ),
              onSaved: (location) {
                _item.location = location;
              },
            ),
            _spacing,
            Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    controller: _barcodeController,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      icon: const Icon(Icons.bookmark),
                      labelText: "Código de Barras",
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    onSaved: (barcode) {
                      _item.barcode = barcode;
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.camera),
                  onPressed: () async {
                    try {
                      _item.barcode = await BarcodeScanner.scan();
                      _barcodeController.text = _item.barcode;
                    } catch (e) {
                      if (e.code == BarcodeScanner.CameraAccessDenied) {
                        setState(() {
                          print('The user did not grant the camera permission!');
                        });
                      } else {
                        print('Unknown error: $e');
                      }
                    }
                  },
                )
              ],
            ),
            _spacing,
            Row(
              children: <Widget>[
                Icon(Icons.format_list_bulleted),
                const SizedBox(width: 16,),
                Expanded(
                  child: FormField<int>(
                      initialValue: _item.status,
                      builder: (state) {
                        return DropdownButton(
                          value: status[state.value],
                          isExpanded: true,
                          onChanged: (value) {
                            _item.status = status.indexOf(value);
                            state.didChange(_item.status);
                          },
                          underline: Container(
                            padding: const EdgeInsets.only(top: 44),
                            height: 30,
                            child: Divider(color: Colors.white,),
                          ),
                          items: status.map<DropdownMenuItem>((title) {
                            return DropdownMenuItem(
                              child: Text(title),
                              value: title,
                            );
                          }).toList(),
                        );
                      }
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30,),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if(!_formKey.currentState.validate()){
            return;
          }

          _formKey.currentState.save();

          if(_item.id > 0){
            await Provider.of<ShoppingList>(context, listen: false).updateItem(_item);
          } else {
            await Provider.of<ShoppingList>(context, listen: false).addItem(_item);
          }

          Navigator.of(context).pop();
        },
        label: widget.item == null ? Text("Cadastrar") : Text("Atualizar"),
      ),
    );
  }
}
