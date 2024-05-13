import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../models/taskItem.dart';
import '../../utils/colors.dart';
import '../../utils/themes.dart';
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
      onTap: () {
        Navigator.of(context, rootNavigator: true)
            .push(MaterialPageRoute(
            builder: (context) => TaskExpandedView(widget.obj)));
      },
      child: Container(
        margin: const EdgeInsets.only(top: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: primaryColor),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.obj.subject,
                      style: listViewTextStyle,
                      maxLines: 1,
                      softWrap: false,
                    ),
                    Text(
                      widget.obj.status,
                      style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 1,
                      softWrap: false,
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    color: Colors.blueAccent,
                    onPressed: () {
                      widget.onEdit(widget.obj);
                    },
                    icon: const Icon(Icons.edit),
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
            ],
          ),
        ),
      ),
    );
  }
}