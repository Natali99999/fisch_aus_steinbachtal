import 'dart:io';
import 'package:fisch_aus_steinbachtal/helper/base.dart';
import 'package:fisch_aus_steinbachtal/helper/colors.dart';
import 'package:fisch_aus_steinbachtal/helper/input_deco_design.dart';
import 'package:fisch_aus_steinbachtal/helper/text.dart';
import 'package:fisch_aus_steinbachtal/models/product.dart';
import 'package:fisch_aus_steinbachtal/provider/product_provider.dart';
import 'package:fisch_aus_steinbachtal/services/authentification_service.dart';
import 'package:fisch_aus_steinbachtal/widgets/sliver_scafold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class EditProduct extends StatefulWidget {
  final Product product;
  EditProduct({this.product});

  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  Product existingProduct;
  bool init = false;
  List<ProductUnit> selectedUnits;

  @override
  void initState() {
    selectedUnits = [];
    /* var productProvider = Provider.of<ProductProvider>(context, listen: false);

    if (productProvider.saved != null &&
        productProvider.saved == true &&
        context != null) {
      Fluttertoast.showToast(
          msg: "Produkt gespeichert",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: AppColors.lightblue,
          textColor: Colors.white,
          fontSize: 16.0);
      productProvider.setSaved(false);
      Navigator.of(context).pop();
    }*/

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var productProvider = Provider.of<ProductProvider>(context);
    existingProduct = widget.product;

    var authBloc = Provider.of<AuthenticationService>(context);
    if (!init) {
     
      productProvider.loadValues(widget.product, authBloc.userId);
      init = true;
    }

    var pageLabel =
        (existingProduct != null) ? 'Produkt ändern' : 'Produkt hinzufügen';

    return (Platform.isIOS)
        ? AppSliverScaffold.cupertinoSliverScaffold(
            navTitle: pageLabel,
            pageBody: pageBody(true, productProvider, context, existingProduct),
            context: context,
          )
        : AppSliverScaffold.materialSliverScaffold(
            navTitle: pageLabel,
            pageBody:
                pageBody(false, productProvider, context, existingProduct),
            context: context);
  }

  Widget pageBody(bool isIOS, ProductProvider productProvider,
      BuildContext context, Product existingProduct) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: AppColors.red),
        child: TextButton(
            onPressed: () async {
              if (formKey.currentState.validate()) {
                await productProvider.saveProduct();
                if (productProvider.saved != null &&
                    productProvider.saved == true &&
                    context != null) {
                  Fluttertoast.showToast(
                      msg: "Produkt gespeichert",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 2,
                      backgroundColor: AppColors.lightblue,
                      textColor: Colors.white,
                      fontSize: 16.0);
                  productProvider.setSaved(false);
                  Navigator.of(context).pop();
                }
              }
            },
            child: Text(
              "Produkt speichern",
              style: TextStyle(fontSize: 20, color: Colors.white),
            )),
      ),
      // backgroundColor: Colors.grey[400],
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: BaseStyles.listPadding,
                child: Divider(color: AppColors.darkblue),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                child: TextFormField(
                  initialValue: productProvider.productName,
                  keyboardType: TextInputType.text,
                  decoration: buildInputDecoration(
                      FontAwesomeIcons.shoppingBasket, "Produktname"),
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Bitte den Produktnamen eingeben';
                    }
                    return null;
                  },
                  onChanged: (String value) {
                    productProvider.changeProductName(value);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                child: TextFormField(
                  maxLines: 4,
                  initialValue: productProvider.description,
                  keyboardType: TextInputType.text,
                  decoration: buildInputDecoration(
                      FontAwesomeIcons.clipboard, "Beschreibung"),
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Bitte die Produktbeschreibung eingeben';
                    }
                    return null;
                  },
                  onChanged: (String value) {
                    productProvider.changeProductDescription(value);
                  },
                ),
              ),
              /* Padding(
                      padding: const EdgeInsets.only(
                          bottom: 15, left: 10, right: 10),*/

              /*  Padding(
                padding: const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                child: DropDownField(
                  onValueChanged: (dynamic value) {
                    productProvider.changeProductCategory(value);
                  },
                  value: productProvider.productCategory,
                  required: false,
                  hintText: '',
                  labelText: 'Kategorie',
                  strict: false,
                  icon: Icon(FontAwesomeIcons.productHunt),
                  items: productProvider.itemsCategory,
                  //  itemsVisibleInDropdown: productProvider.itemsCategory.length,
                ),
              ),*/
              //  ),

              /*Menge*/
               Padding(
                padding: const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                child: TextFormField(
                  initialValue: productProvider.availableUnits,
                  keyboardType: TextInputType.number,
                  decoration:
                      buildInputDecoration(FontAwesomeIcons.cubes, "Menge"),
                  onChanged: (String value) {
                    productProvider.changeAvailableUnits(value);
                    //phone = value;
                  },
                ),
              ),
              Divider(thickness: 2,),
              Padding(
                  padding: const EdgeInsets.only(bottom: 1, left: 10, right: 10),
                  child: getProductUnitList(context, productProvider),
               ),
              Divider(thickness: 2,),
              Text(
                'Bilder',
                style: TextStyles.listTitle,
              ),
              SizedBox(
                height: 5,
              ),

              
              if (productProvider.isUploading == true)
                Center(
                  child: (Platform.isIOS)
                      ? CupertinoActivityIndicator()
                      : CircularProgressIndicator(),
                ),
              // Bilder
              Container(
                  width: double.infinity,
                  height: 300,
                  padding: EdgeInsets.all(4),
                  child: GridView.builder(
                      primary: false,
                      shrinkWrap: true,
                      itemCount: productProvider.imageUrl.length + 1,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3),
                      itemBuilder: (context, index) {
                        return index == productProvider.imageUrl.length
                            ? Center(
                                child: /*IconButton(
                                    icon: Icon(Icons.add),*/
                                     FloatingActionButton(
                                      heroTag: 3,
                                      mini: true,
                                      backgroundColor: AppColors.lightblue,
                                      child: Icon(Icons.add, color: Colors.white, size: 25.0),
                                      onPressed: () =>
                                        !productProvider.isUploading
                                            ? productProvider.pickImage()
                                            : null),
                              )
                            : ImageTile(index, productProvider.imageUrl[index],
                                () {
                                productProvider.deleteImage(index);
                              });
                      })),
            
            ],
          ),
        ),
      ),
    );
  }

  onSelectedRow(bool selected, ProductUnit productUnit) async {
    setState(() {
      if (selected) {
        selectedUnits.add(productUnit);
      } else {
        selectedUnits.remove(productUnit);
      }
    });
    print(selectedUnits);
  }

  Widget getProductUnitList(
      BuildContext context, ProductProvider productProvider) {
    return Column(
      children: [
        Text(
          'Einheit',
          style: TextStyles.listTitle,
        ),
        SizedBox(
          height: 5,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            showCheckboxColumn: true,
            //dataRowHeight: 50,
            //dividerThickness: 5,
            columns: [
              DataColumn(label: Text('Einheit'), tooltip: 'Einheit'),
              DataColumn(numeric: true, label: Text('Preis'), tooltip: 'Preis'),
              DataColumn(
                  numeric: false,
                  label: Text('Text'),
                  tooltip: 'in der Produktbeschreibung angezeigte Text'),
            ],
            rows: productProvider.units.map((productUnit) {
              return DataRow(
                  selected: selectedUnits.contains(productUnit),
                  onSelectChanged: (b) {
                    print("Onselect");
                    onSelectedRow(b, productUnit);
                  },
                  cells: [
                    DataCell(
                      Container(
                        width: 70,
                        child: TextFormField(
                          initialValue: '${productUnit.name}',
                          keyboardType: TextInputType.text,
                          onChanged: (val) {
                            productUnit.name = val;
                          },
                        ),
                      ),
                      // showEditIcon: true,
                    ),
                    DataCell(
                      TextFormField(
                        initialValue: '${productUnit.price.toStringAsFixed(2)}',
                        keyboardType: TextInputType.number,
                        onChanged: (val) {
                          //  print('onSubmited $val');
                          productUnit.price = double.parse(val);
                        },
                      ),
                      // showEditIcon: true
                    ),
                    DataCell(
                      Container(
                        width: 150,
                        child: TextFormField(
                          initialValue: '${productUnit.text}',
                          keyboardType: TextInputType.text,
                          onChanged: (val) {
                            // print('onSubmited $val');
                            productUnit.text = val;
                          },
                        ),
                      ),
                      //   showEditIcon: true,
                    ),
                  ]);
            }).toList(),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.all(20.0),
              child: FloatingActionButton(
                heroTag: 1,
                mini: true,
                backgroundColor: AppColors.lightblue,
                child: Icon(Icons.add, color: Colors.white, size: 25.0),
                onPressed: () {
                  productProvider.changeUnit(
                      ProductUnit(price: 0.00, name: ' ', text: ' '));
                },
              ),
            ),
            FloatingActionButton(
              heroTag: 2,
              mini: true,
              backgroundColor: AppColors.lightblue,
              child: Icon(Icons.delete, color: Colors.white, size: 25.0),
              onPressed: () {
                setState(() {
                  selectedUnits.forEach((element) {
                    productProvider.removeUnit(element);
                  });
                });
              },
            )
          ],
        ),
      ],
    );
  }
}

class ImageTile extends StatelessWidget {
  final int _index;
  final dynamic _callback;
  final String _imagePath;

  ImageTile(this._index, this._imagePath, this._callback);

  get index => _index;

  Future<bool> _confirmDelete(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Bild entfernen"),
              //content: Text("Wollen Sie das Bild entfernen?"),
              actions: <Widget>[
                TextButton(
                  child: Text("Nein"),
                  onPressed: () => Navigator.pop(context, false),
                ),
                TextButton(
                  child: Text("Ja"),
                  onPressed: () => Navigator.pop(context, true),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: Card(
          child: InkResponse(
              onLongPress: () async {
                if (await _confirmDelete(context)) {
                  _callback();
                }
              },
              child: Center(
                child: Container(
                    child: Image.network("$_imagePath", fit: BoxFit.cover)),
              ))),
    );
  }
}
