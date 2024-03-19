class Contact{
  String? Name;
  String? phone;
  String? Email;

  Contact({
   this.Name,
   this.Email,
   this.phone
});

  Contact.fromJson(Map<String, dynamic> json){
    Name =  '${json["first_name"]} ${json["last_name"]}';
    json["mobile"]==null? phone='':phone=  json["mobile"] ;
    json["email"] ==null? Email='':Email= json["email"]  ;

  }
  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.Name;
    data['mobile']= this.phone;
    data['email'] = this.Email;
   return data;
  }

}