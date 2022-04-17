import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_app/screens/edit_view_screen.dart';
import 'package:delivery_app/services/firebase_services.dart';
import 'package:flutter/material.dart';

class UnPublishedProduct extends StatelessWidget {
  const UnPublishedProduct({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseServices _services = FirebaseServices();
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream:
            _services.products.where('published', isEqualTo: false).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Somhing went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return SingleChildScrollView(
            child: FittedBox(
              child: DataTable(
                showBottomBorder: true,
                dataRowHeight: 75,
                headingRowColor: MaterialStateProperty.all(Colors.grey),
                columns: <DataColumn>[
                  DataColumn(label: Expanded(child: Text('Product '))),
                  DataColumn(label: Expanded(child: Text('Image'))),
                  DataColumn(label: Expanded(child: Text('Info'))),
                  DataColumn(label: Expanded(child: Text('Actions'))),
                ],
                rows: productDetails(snapshot.data, context),
              ),
            ),
          );
        },
      ),
    );
  }

  List<DataRow> productDetails(QuerySnapshot? snapshot, context) {
    List<DataRow> newList = snapshot!.docs.map((DocumentSnapshot document) {
      return DataRow(cells: [
        DataCell(Container(
            child: ListTile(
          contentPadding: EdgeInsets.zero,
          title: Row(
            children: [
              Text(
                'Name: ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              Expanded(
                  child: Text(
                document['productName'],
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ))
            ],
          ),
          subtitle: Row(
            children: [
              Text(
                'SKU:   ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              Text(
                document['sku'],
                style: TextStyle(fontSize: 15),
              )
            ],
          ),
        ))),
        DataCell(
          Container(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(
              document['productImage'] ?? "default data",
              width: 50,
            ),
          )),
        ),
        DataCell(IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditViewProduct(
                          productId: document['productId'],
                        )),
              );
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) =>
              //             EditViewProduct(produtId: document['productId'])));
            },
            icon: Icon(Icons.info_outline))),
        DataCell(popUpButton(document.data())),
      ]);
    }).toList();
    return newList;
  }

  Widget popUpButton(data, {BuildContext? cotext}) {
    FirebaseServices _services = FirebaseServices();
    return PopupMenuButton<String>(
        onSelected: (String value) {
          if (value == 'publish') {
            _services.publishProduct(id: data['productId']);
          }
          if (value == 'delete') {
            _services.deleteProduct(id: data['productId']);
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                  value: 'publish',
                  child: ListTile(
                    leading: Icon(Icons.check),
                    title: Text('Publish'),
                  )),
              const PopupMenuItem<String>(
                  value: 'delete',
                  child: ListTile(
                    leading: Icon(Icons.delete_outline),
                    title: Text('Delete'),
                  )),
            ]);
  }
}
