class customer{
  String? Name;
  String? Category;
  String? Phone;
  String? CompanyName;
  String? Email;
  String? Location;
  String? Address;

  customer({
    this.Name,
    this.Email,
    this.Category,
    this.Location,
    this.Address,
    this.CompanyName,
    this.Phone
});

  customer.fromJson(Map<String, dynamic> json){
    json["name"]==null ? Name='':Name = json["name"];
    json["category"]==null? Category='':Category = json["category"];
    json["phone"]==null? Phone='':Phone = json["phone"];
    json["email"]==null? Email='':Email = json["email"];
    json["location"]==null? Location='':Location= json["location"];
    json["address"]==null? Address='':Address = json["address"];
    json["company_name"]==null? CompanyName='':CompanyName = json["company_name"];

  }
  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();

    return data;
  }


}