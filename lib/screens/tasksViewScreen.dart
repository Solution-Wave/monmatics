import 'package:flutter/material.dart';
import 'package:monmatics/utils/themes.dart';

import '../models/taskItem.dart';
import '../utils/colors.dart';


class taskListTile extends StatelessWidget {
  const taskListTile(this.obj,{Key? key}) : super(key: key);
  final obj;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: GestureDetector(
        onTap: (){
          Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (BuildContext)=>TaskExpandedView(obj)));
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
                  Text(obj['Subject']),

                  Text(obj['StDate']),
                ],
              ),
            ),

        ),
      ),
    );
  }
}

class TaskExpandedView extends StatelessWidget {
  const TaskExpandedView(this.task_item,{super.key});
 final task_item;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(

          title: Text('Task',
            style:  headerTextStyle ,
          ),
        ),
        body: Container(
          decoration: ExpandedViewDecor,
          margin: const EdgeInsets.all(20.0),
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width,
              maxHeight: MediaQuery.of(context).size.height
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 25.0,bottom: 25.0, left: 12.0, right: 12.0),
              child: Row(
                children: [
                  //Title's column
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Subject', style: titleStyle),
                          const SizedBox(width: 35.0,),
                          Container(
                              width: MediaQuery.of(context).size.width*0.5,
                              child: Text(task_item['Subject'], style: normalStyle)),
                        ],
                      ),
                      const SizedBox(height: 10.0,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Start Date',style: titleStyle,),
                          const SizedBox(width: 15.0,),
                          Container(
                              width: MediaQuery.of(context).size.width*0.5,
                              child: Text(task_item['StDate'], style: normalStyle,)),
                        ],
                      ),
                      const SizedBox(height: 10.0,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Due Date',style: titleStyle,),
                          const SizedBox(width: 20.0,),
                          Container(
                              width: MediaQuery.of(context).size.width*0.5,
                              child: Text(task_item['DueDate'], style: normalStyle,)),
                        ],
                      ),
                      const SizedBox(height: 10.0,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Status',style: titleStyle,),
                          const SizedBox(width: 40.0,),
                          Container(
                              width: MediaQuery.of(context).size.width*0.5,
                              child: Text(task_item['Status'], style: normalStyle,)),
                        ],
                      ),
                      const SizedBox(height: 10.0,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Priority',style: titleStyle,),
                          const SizedBox(width: 30.0,),
                          Container(
                              width: MediaQuery.of(context).size.width*0.5,
                              child: Text(task_item['Priority'], style: normalStyle,)),
                        ],
                      ),
                      const SizedBox(height: 10.0,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Description', style: titleStyle,),
                          const SizedBox(width: 15.0,),
                          Container(
                              width: MediaQuery.of(context).size.width*0.5,
                              child: Text(task_item['Description'], style: normalStyle,)),
                        ],
                      ),
                    ],
                  ),


                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
