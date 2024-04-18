import 'package:flutter/material.dart';
import 'taskexpandedview.dart';


class taskListTile extends StatelessWidget {
  const taskListTile(this.obj,{Key? key}) : super(key: key);
  final obj;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: GestureDetector(
        onTap: (){
          Navigator.of(context, rootNavigator: true)
              .push(MaterialPageRoute(builder: (BuildContext)=>TaskExpandedView(obj)));
        },
        child: Card(
          // color: Theme.of(context).brightness == Brightness.dark
          //     ? null
          //     : secondPrimary,
            child:  Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(obj.subject),
                  Text(obj.startDate),
                  Text(obj.priority),
                ],
              ),
            ),

        ),
      ),
    );
  }
}
