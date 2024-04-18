import 'package:flutter/material.dart';
import '../utils/themes.dart';

class TaskListTile extends StatelessWidget {
  final Map<String, dynamic> taskData;

  const TaskListTile(this.taskData, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(builder: (BuildContext) => TaskExpandedView(taskData)),
          );
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(taskData['subject']),
                Text(taskData['start_date'] ?? 'N/A'), // Adjust key names as per your data
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TaskExpandedView extends StatelessWidget {
  final Map<String, dynamic> taskData;

  const TaskExpandedView(this.taskData, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Task', style: headerTextStyle),
        ),
        body: Container(
          decoration: ExpandedViewDecor,
          margin: const EdgeInsets.all(20.0),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDataRow('Subject', taskData['subject']),
                _buildDataRow('Start Date', taskData['start_date'] ?? 'N/A'), // Adjust key names as per your data
                _buildDataRow('Priority', taskData['priority']),
                _buildDataRow('Description', taskData['description']),
                _buildDataRow('Assigned To', taskData['assigned_to']),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDataRow(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: titleStyle),
        const SizedBox(height: 5.0),
        Text(value, style: normalStyle),
        const SizedBox(height: 10.0),
      ],
    );
  }
}
