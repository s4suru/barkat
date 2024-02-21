class Hadith {
  String? hArabic, hhindi, hNepali;
  String? hadeeth, title, attribution, grade, explanation;
  List? hints;
  Hadith.fromJson(Map<String, dynamic> json) {
    // hArabic = json['h_ar'];
    // hhindi = json['h_hi'];
    // hNepali = json['h_np'];
    hadeeth = json['hadeeth'];
    title = json['title'];
    attribution = json['attribution'];
    grade = json['grade'];
    hints = json['hints'];
    explanation = json['explanation'];
  }
}
