import 'package:flutter/material.dart';
import '../../models/noteItem.dart';
import '../../utils/colors.dart';
import '../../utils/themes.dart';


class NotesTile extends StatefulWidget {
  const NotesTile({
    required this.obj,
    required this.onEdit,
    required this.onDelete,
    Key? key,
  }) : super(key: key);

  final NoteHive obj;
  final Function(NoteHive) onEdit;
  final Function(NoteHive) onDelete;

  @override
  State<NotesTile> createState() => _NotesTileState();
}

class _NotesTileState extends State<NotesTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          iconColor: primaryColor,
          // expandedAlignment: Alignment.centerLeft,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: primaryColor,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
          collapsedShape: RoundedRectangleBorder(
            side: BorderSide(
              color: primaryColor,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.obj.subject, style: listViewTextStyle),
              Text(widget.obj.relatedTo),
            ],
          ),
          childrenPadding: const EdgeInsets.only(
            top: 8.0,
            bottom: 8.0,
            left: 15.0,
            right: 15.0,
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  widget.onDelete(widget.obj);
                },
                icon: const Icon(Icons.delete),
                color: Colors.red,
              ),
              IconButton(
                onPressed: () {
                  widget.onEdit(widget.obj);
                },
                icon: const Icon(Icons.edit),
                color: Colors.blue,
              ),
              Icon(
                _isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
              ),
            ],
          ),
          onExpansionChanged: (bool val) {
            setState(() {
              _isExpanded = val;
            });
          },
          children: [
            Text("Description:", style: listViewTextStyle,),
            const SizedBox(height: 10.0,),
            Text(
              widget.obj.description,
              style: normalStyle1,
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}

