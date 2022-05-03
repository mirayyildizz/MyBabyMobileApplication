
import 'package:cloud_firestore/cloud_firestore.dart';

class Following{
  late final String id;


  Following({
    required this.id,

  });
  factory Following.fromDocument(DocumentSnapshot doc){
    return Following(
        id: doc['id'],
    );
  }
}