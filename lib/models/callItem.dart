class Call {
  String? ContactName;
  String? Subject;
  String? Status;
  String? Date;
  String? Time;
  String? RelatedTo;
  String? Description;

  Call(
      {this.ContactName,
      this.Subject,
      this.Status,
      this.Date,
      this.Time,
      this.RelatedTo,
      this.Description});

  Call.fromObject(Map json) {
   ContactName = json["ContactName"];
   Subject = json["Subject"];
   Status = json["Status"];
   Time = json['Time'];
   Date = json['Date'];
   RelatedTo = json["RelatedTo"];
   Description = json["Description"];
  }
}
