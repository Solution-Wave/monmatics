import 'package:flutter/material.dart';

import '../../utils/themes.dart';

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
        body: SingleChildScrollView(
          child: Container(
            decoration: ExpandedViewDecor,
            margin: const EdgeInsets.all(20.0),
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width,
                maxHeight: MediaQuery.of(context).size.height
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 25.0,bottom: 25.0, left: 12.0, right: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Subject:', style: titleStyle),
                        Container(
                            width: MediaQuery.of(context).size.width*0.5,
                            child: Text(task_item.subject, style: normalStyle)),
                      ],
                    ),
                    const SizedBox(height: 10.0,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Start Date:',style: titleStyle,),
                        Container(
                            width: MediaQuery.of(context).size.width*0.5,
                            child: Text(task_item.startDate, style: normalStyle,)),
                      ],
                    ),
                    const SizedBox(height: 10.0,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Due Date:',style: titleStyle,),
                        Container(
                            width: MediaQuery.of(context).size.width*0.5,
                            child: Text(task_item.dueDate, style: normalStyle,)),
                      ],
                    ),
                    const SizedBox(height: 10.0,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Status:',style: titleStyle,),
                        Container(
                            width: MediaQuery.of(context).size.width*0.5,
                            child: Text(task_item.status, style: normalStyle,)),
                      ],
                    ),
                    const SizedBox(height: 10.0,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Priority:',style: titleStyle,),
                        Container(
                            width: MediaQuery.of(context).size.width*0.5,
                            child: Text(task_item.priority, style: normalStyle,)),
                      ],
                    ),
                    const SizedBox(height: 10.0,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Related To:',style: titleStyle,),
                        Container(
                            width: MediaQuery.of(context).size.width*0.5,
                            child: Text(task_item.type, style: normalStyle,)),
                      ],
                    ),
                    const SizedBox(height: 10.0,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Contact:',style: titleStyle,),
                        Container(
                            width: MediaQuery.of(context).size.width*0.5,
                            child: Text(task_item.contact, style: normalStyle,)),
                      ],
                    ),
                    const SizedBox(height: 10.0,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Description:', style: titleStyle,),
                        Container(
                            width: MediaQuery.of(context).size.width*0.5,
                            child: Text(task_item.description, style: normalStyle,)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}