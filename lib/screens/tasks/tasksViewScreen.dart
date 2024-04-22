import 'package:flutter/material.dart';
import '../../models/taskItem.dart';
import 'taskexpandedview.dart';


class TaskListTile extends StatefulWidget {
  const TaskListTile({
    required this.obj,
    required this.onEdit,
    required this.onDelete,
    Key? key,
  }) : super(key: key);

  final TaskHive obj;
  final Function(TaskHive) onEdit;
  final Function(TaskHive) onDelete;

  @override
  State<TaskListTile> createState() => _TaskListTileState();
}

class _TaskListTileState extends State<TaskListTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.of(context, rootNavigator: true)
            .push(MaterialPageRoute(builder: (BuildContext)=>
            TaskExpandedView(widget.obj)));
      },
      child: Card(
        // color: Theme.of(context).brightness == Brightness.dark
        //     ? null
        //     : secondPrimary,
          child:  Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.obj.subject),
                Text(widget.obj.status),
                Container(
                  child: IconButton(
                    color: Colors.blueAccent,
                  onPressed: (){
                    widget.onEdit(widget.obj);
                  },
                  icon: const Icon(Icons.edit)
                  ),
                ),
                IconButton(
                  onPressed: () {
                    widget.onDelete(widget.obj);
                  },
                  icon: const Icon(Icons.delete),
                  color: Colors.red,
                ),
              ],
            ),
          ),
      ),
    );
  }
}
