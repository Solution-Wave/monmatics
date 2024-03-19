class Tasks {
  String? Subject;
  String? StDate;
  String? DueDate;
  String? Status;
  String? Priority;
  String? Description;

  Tasks({
    this.Subject,
    this.StDate,
    this.Priority,
    this.Description,
    this.DueDate,
    this.Status,
  });

  Tasks.fromJson(Map obj) {
    // print('json in item class: $json');
    Subject = obj["Subject"] ?? '';
    StDate = obj["StDate"] ?? '';
    DueDate = obj["DueDate"] ?? '';
    Status = obj["Status"] ?? '';
    Priority = obj["Priority"] ?? '';
    Description = obj["Description"] ?? '';
  }
}
