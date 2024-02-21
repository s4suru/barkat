class AllahName {
  List<AllahData>? data;

  AllahName({this.data});

  AllahName.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <AllahData>[];
      json['data'].forEach((v) {
        data!.add(AllahData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AllahData {
  String? name;
  String? transliteration;
  int? number;
  String? found;
  En? en;
  En? fr;

  AllahData(
      {this.name,
      this.transliteration,
      this.number,
      this.found,
      this.en,
      this.fr});

  AllahData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    transliteration = json['transliteration'];
    number = json['number'];
    found = json['found'];
    en = json['en'] != null ? En.fromJson(json['en']) : null;
    fr = json['fr'] != null ? En.fromJson(json['fr']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = this.name;
    data['transliteration'] = this.transliteration;
    data['number'] = this.number;
    data['found'] = this.found;
    if (this.en != null) {
      data['en'] = this.en!.toJson();
    }
    if (this.fr != null) {
      data['fr'] = this.fr!.toJson();
    }
    return data;
  }
}

class En {
  String? meaning;
  String? desc;

  En({this.meaning, this.desc});

  En.fromJson(Map<String, dynamic> json) {
    meaning = json['meaning'];
    desc = json['desc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['meaning'] = this.meaning;
    data['desc'] = this.desc;
    return data;
  }
}
