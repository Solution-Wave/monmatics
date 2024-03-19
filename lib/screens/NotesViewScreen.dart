import 'package:flutter/material.dart';

import '../models/noteItem.dart';
import '../utils/colors.dart';
import '../utils/themes.dart';


class NotesTile extends StatefulWidget {
  const NotesTile({ required this.obj,super.key});
  final obj;
  @override
  State<NotesTile> createState() => _NotesTileState();
}

class _NotesTileState extends State<NotesTile> {
  bool _isExpanded=false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          iconColor: primaryColor,
          expandedAlignment: Alignment.centerLeft,
          // expandedCrossAxisAlignment: CrossAxisAlignment.start,
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
          ) ,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.obj['Subject'], style: listViewTextStyle ,),
              Text(widget.obj['RelatedTo'], style: listViewTextStyle ,),
              // Text(
              //   widget.obj['Description'],
              //   style: listViewTextStyle.copyWith(
              //   ),
              //   textAlign: TextAlign.justify,
              //   overflow: TextOverflow.ellipsis,
              //   maxLines: 1,
              // )
            ],
          ),
          childrenPadding: const EdgeInsets.only(
            top: 8.0,
            bottom: 8.0,
            left: 15.0,
            right: 15.0 ,
          ),
          trailing: Icon(
              _isExpanded?
              Icons.arrow_drop_up :
              Icons.arrow_drop_down
          ),
          onExpansionChanged: (bool val){
            setState(() {
              _isExpanded = val;
            });
          },
          children: [
            // Text(widget.obj['Subject'], style: normalStyle,),
            // const SizedBox(height: 10.0,),
            Text(widget.obj['Description'], style: normalStyle, textAlign: TextAlign.justify,),
          ],
        ),
      ),
    );
  }
}




class NotesListTile extends StatelessWidget {
  const NotesListTile(
      this.obj,
      {
    super.key,
  });
 final  obj;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (BuildContext)=>NotesExpandedView(notesObj: obj,)));
      },
      child: Card(
        color: Theme.of(context).brightness == Brightness.dark
            ? null
            : Colors.green[50],
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Subject:',style: listViewTextStyle,),
                  Text('Related To:',style: listViewTextStyle,),
                  Text('Description:',style: listViewTextStyle,),
                ],
              ),
              const SizedBox(width: 100),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      obj['Subject'],
                      style: listViewTextStyle,
                    ),
                    Text(
                      obj['RelatedTo'],
                      style: listViewTextStyle,),
                    Text(
                      obj['Description'],
                      style: listViewTextStyle.copyWith(
                      ),
                    textAlign: TextAlign.justify,
                      overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    )
                  ],
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }
}

class NotesExpandedView extends StatelessWidget {
  const NotesExpandedView({required this.notesObj,super.key});
  final notesObj;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Notes',
            style:  headerTextStyle ,
          ),
        ),

        body: Container(
          decoration: ExpandedViewDecor,
          margin: const EdgeInsets.all(20.0),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            //minHeight: MediaQuery.of(context).size.height*0.4
          ),

          child: Padding(
            padding: const EdgeInsets.only(top: 25.0,bottom: 25.0, left: 12.0, right: 12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //Title's column
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Subject', style: titleStyle),
                    const SizedBox(height: 10.0,),
                    Text('Related To',style: titleStyle,),
                    const SizedBox(height: 10.0,),
                    Text('Description', style: titleStyle,),
                  ],
                ),
                const SizedBox(width: 15.0,),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(notesObj['Subject'], style: normalStyle),
                      const SizedBox(height: 10.0,),
                      Text(notesObj['RelatedTo'], style: normalStyle,),
                      const SizedBox(height: 10.0,),
                      Text(notesObj['Description'], style: normalStyle, textAlign: TextAlign.justify,),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
