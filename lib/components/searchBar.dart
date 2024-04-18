import 'package:flutter/material.dart';

class searchBar extends StatefulWidget {
  searchBar({Key? key}) : super(key: key);

  @override
  State<searchBar> createState() => _searchBarState();
}

class _searchBarState extends State<searchBar> {
  @override
  bool selected = false;

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selected = true;
        });
      },
      child: Container(
        decoration: BoxDecoration(
            // color: Theme.of(context).brightness == Brightness.light
            //     ? searchBarLightCol
            //     : searchBarDarkCol,
            borderRadius: BorderRadius.circular(30.0)),
        constraints: BoxConstraints(minHeight: 50.0, minWidth: 50.0
          // maxWidth: 20.0
        ),
        child: selected == false
            ? Icon(
          Icons.search,
        )
            : Padding(
          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.search,
              ),
              SizedBox(
                width: 10,
              ),
              Flexible(
                child: TextField(
                  onSubmitted: (val) {
                    setState(() {
                      selected = false;
                      print(val);
                    });
                  },
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Colors.white,
                      hintText: 'Search Contact',
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                      )),
                  onChanged: (newVal) {},
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    selected = false;
                  });
                },
                icon: Icon(Icons.close),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
