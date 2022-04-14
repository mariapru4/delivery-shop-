import 'package:flutter/material.dart';

class AddNewProduct extends StatelessWidget {
  static const String id = 'add-new-product';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: Column(
          children: [
            Material(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Container(
                        child: Text('Products / Add'),
                      ),
                    ),
                    FlatButton.icon(
                      icon: Icon(Icons.save_alt_outlined),
                      label: Text(
                        'Save',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Theme.of(context).primaryColor,
                      onPressed: () {},
                    )
                  ],
                ),
              ),
            ),
            TabBar(
                indicatorColor: Theme.of(context).primaryColor,
                labelColor: Colors.black54,
                tabs: [
                  Tab(
                    text: 'PUBLISHED',
                  ),
                  Tab(
                    text: 'UN PUBLISHED',
                  ),
                ]),
            Expanded(
              child: Container(
                child: TabBarView(children: [
                  Center(
                    child: Text('Published Products'),
                  ),
                  Center(
                    child: Text('Un Published Products'),
                  ),
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
