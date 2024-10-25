//  "id": "1",
//   "name": "Faizan",
//   "day": "Thursday",
//   "date": "24/10/2024",
//   "img": "assets/images/propic.png",
//   "isMissed": false,
//   "called": false,
//   "number": "8421121734"
class LandingDataModel {
  String? id;
  String? name;
  String? day;
  String? date;
  String? img;
  bool? isMissed;
  bool? called;
  String? number;
  LandingDataModel(
      {required this.id,
      required this.name,
      required this.day,
      required this.date,
      required this.img,
      required this.isMissed,
      required this.called,
      required this.number});
}
