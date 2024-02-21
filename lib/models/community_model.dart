class Community {
  String? email;
  String? name;
  String? createdAt;
  String? phone;
  String? photo;
  int? id;

  Community(
      {this.email, this.name, this.createdAt, this.phone, this.photo, this.id});

  Community.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    name = json['name'];
    createdAt = json['created_at'];
    phone = json['phone'];
    id = json['id'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['name'] = name;
    data['created_at'] = createdAt;
    data['phone'] = phone;
    data['id'] = id;
    data['photo'] = photo;
    return data;
  }
}
