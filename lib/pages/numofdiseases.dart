import 'package:cloud_firestore/cloud_firestore.dart';

class NumOfDiseases{
  late final String id;
  late int num;


  NumOfDiseases({
    required this.id,
    required this.num,

  });
  factory NumOfDiseases.fromDocument(DocumentSnapshot doc){
    return NumOfDiseases(
      id: doc['id'],
      num: doc['num'],
    );
  }
}