import 'dart:convert';

class EventDataModel {
  var EventID;
  var EventImage;
  var Heading;
  var EventDate;
  var created_at;
  var updated_at;
  var Host;
  var cohost;
  var host_user;



  EventDataModel({
    required this.EventID,
    required this.EventImage,
    required this.Heading,
    required this.EventDate,
    required this.created_at,
    required this.updated_at,
    required this.Host,
    required this.cohost,
    required this.host_user,

  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'EventID': EventID,
      'EventImage': EventImage,
      'Heading': Heading,
      'EventDate': EventDate,
      'created_at': created_at,
      'updated_at': updated_at,
      'Host': Host,
      'cohost': cohost,
      'host_user': host_user,

    };
  }

  factory EventDataModel.fromMap(Map<String, dynamic> map) {
    return EventDataModel(
      EventID: map['EventID'],
      EventImage: map['EventImage'],
      Heading: map['Heading'],
      EventDate: map['EventDate'],
      created_at: map['created_at'],
      updated_at: map['updated_at'],
      Host : map['Host'],
      cohost : map['cohost'],
      host_user: map['host_user'],

    );
  }

  String toJson() => json.encode(toMap());

  factory EventDataModel.fromJson(String source) =>
      EventDataModel.fromMap(json.decode(source) as Map<String, dynamic>);
}