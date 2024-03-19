class Note{
String? Subject;
String? Description;
String? RelatedTo;

Note({
  this.Subject, this.Description , this.RelatedTo
});

Note.fromJson(Map<String, dynamic> json){
  json["subject"] == null ? Subject = '' : Subject=json["subject"];
  json["description"] == null ? Description  = ''  : Description = json["description"];
  json["related_to_type"] == null ? RelatedTo = '': RelatedTo=json["related_to_type"];

}

}