class Lead {
  String? Name;
  String? Category;
  String? Note;
  String? PhoneNo;
  String? Email;
  String? Address;
  String? location;

  Lead(
      {this.Name,
      this.Category,
      this.Address,
      this.Email,
      this.location,
      this.Note,
      this.PhoneNo});

  Lead.fromJson(Map<String, dynamic> json) {
    String temp = json["name"];
    int? ind;
    for (int i = 0; i < temp.length; i++) {
      if (temp[i] == '(') ind = i;
    }
    // temp.substring(0,ind)
    json["name"] == null ? Name = '' : Name = temp.substring(0, ind);

    json["category"] == null ? Category = '' : Category = json["category"];

    json["address"] == null ? Address = '' : Address = json["address"];
    json["email"] == null ? Email = '' : Email = json["email"];
    json["location"] == null ? location = '' : location = json["location"];
    json["note"] == null ? Note = '' : Note = json["note"];
    json["phone"] == null ? PhoneNo = '' : PhoneNo = json["phone"];
  }
}
