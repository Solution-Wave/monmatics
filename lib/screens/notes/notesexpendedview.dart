import 'package:flutter/material.dart';

import '../../utils/themes.dart';

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
                      Text(notesObj.subject, style: normalStyle),
                      const SizedBox(height: 10.0,),
                      Text(notesObj.note, style: normalStyle,),
                      const SizedBox(height: 10.0,),
                      Text(notesObj.description, style: normalStyle, textAlign: TextAlign.justify,),
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