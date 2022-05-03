import 'package:cloud_firestore/cloud_firestore.dart';

class Disease{
  late final String id;
  late final int counter;
  late final String hast1;
  late final String hast2;
  late final String hast3;
  late final String hast4;
  late final String hast5;
  late final String hast6;
  late final String hast7;
  late final String hast8;


  Disease({
    required this.id,
    required this.counter,
    required this.hast1,
    required this.hast2,
    required this.hast3,
    required this.hast4,
    required this.hast5,
    required this.hast6,
    required this.hast7,
    required this.hast8,




  });
  factory Disease.fromDocument(DocumentSnapshot doc){
    return Disease(
      id: doc['id'],
      counter: doc['counter'],
      hast1 : doc['Alerji'],
      hast2 : doc['Bronşit'],
      hast3 : doc['Grip'],
      hast4 : doc['Kabızlık'],
      hast5 : doc['Orta Kulak İltihabı'],
      hast6 : doc['Sarılık'],
      hast7 : doc['Solunum Yolu Enfeksiyonu'],
      hast8 : doc['İshal'],

    );
  }
}