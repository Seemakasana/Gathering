// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class DatabaseService{
//   final String? uid;
//
//   DatabaseService({this.uid});
//
//   final CollectionReference user= FirebaseFirestore.instance.collection('users');
//   final CollectionReference chat= FirebaseFirestore.instance.collection('chat');
//   final CollectionReference group= FirebaseFirestore.instance.collection('group');
//
//
//   Future updateUserData( String name, String email, String userName, String phone ) async{
//
//     print("hello!!!!!!!!!!!!!!!!!!!!");
//     return await user.doc(uid).update({
//       "name": name,
//       "email": email,
//       "userName": userName,
//       "phone_no": phone,
//       "id": uid
//     });
//   }
//
//   Future updateUserProfilePic(String profilePic) async{
//     print("hello!!!!!!!!!!!!!");
//     return await user.doc(uid).update({
//       "profileImg": profilePic,
//     });
//   }
//
//
//
//
//   Future gettingUserData(String email) async{
//     var snap= await user.where("email", isEqualTo: email).get();
//     var u= await user.doc(snap.docs[0].id).get();
//     print("snap: ${u.data()}");
//     return user.doc(snap.docs[0].id).snapshots();
//   }
//
//
//
//   Future getUserChat() async {
//     var snap = await user.where("email", isEqualTo: uid).get();
//
//     return user.doc(snap.docs[0].id).snapshots();
//   }
//
//
//   Future createChat(String userName, String id, String userName2) async {
//     var allGroupColl = await chat.get();
//     var allGroupCollDocs = allGroupColl.docs.where((element) =>
//     (element.data() as Map<String, dynamic>)["members"][0]
//         .toString()
//         .split("_")[0] ==
//         id);
//     var userData = await user.doc(uid).get();
//     var user2Data = await user.doc(id).get();
//
//     if (allGroupCollDocs.isEmpty) {
//       DocumentReference groupDocumentReference = await chat.add({
//         "chatName": "${id}_$uid",
//         "chatIcon": "",
//         "admin": "${uid}_$userName",
//         "members": [],
//         "chatId": "",
//         "recentMessage": "",
//         "recentMessageSender": "",
//         "recentMessageTime": ""
//       });
//
//       await groupDocumentReference.update({
//         "members":
//         FieldValue.arrayUnion(["${uid}_$userName", "${id}_$userName2"]),
//         "chatId": groupDocumentReference.id,
//       });
//
//       DocumentReference userDocumentReference = user.doc(uid);
//       DocumentReference user2DocumentReference = user.doc(id);
//       await userDocumentReference.update({
//         "chat":
//         FieldValue.arrayUnion(["${groupDocumentReference.id}_$userName2"]),
//       });
//       await user2DocumentReference.update({
//         "chat":
//         FieldValue.arrayUnion(["${groupDocumentReference.id}_$userName"]),
//       });
//
//       return [
//         groupDocumentReference.id,
//         userName2,
//         userName,
//         (user2Data.data() as Map<String, dynamic>)['profilePic'],
//         (userData.data() as Map<String, dynamic>)['profilePic'],
//       ];
//     } else {
//       var allGroupCollDocs1 = allGroupColl.docs.where((element) =>
//       (element.data() as Map<String, dynamic>)['chatName'].toString() ==
//           "${id}_$uid");
//       if (allGroupCollDocs1.length == 1) {
//         return [
//           (allGroupCollDocs1.first.data() as Map<String, dynamic>)['chatId'],
//           userName2,
//           userName,
//           (user2Data.data() as Map<String, dynamic>)['profilePic'],
//           (userData.data() as Map<String, dynamic>)['profilePic'],
//         ];
//       }
//
//       return [];
//     }
//   }
//
//
//
//   Future getUserChatRecentMessageTime() async {
//     var snap = await user.where("email", isEqualTo: uid).get();
//     var u = await user.doc(snap.docs[0].id).get();
//     print("u1: ${u.data()}");
//     // var u = await user.doc(uid).get();
//     List<String> recentMsgTime = [];
//     for (var element in u['chat']) {
//       var newGroupId = element.toString().split("_")[0];
//       print("newGroupId: $newGroupId");
//
//       var g = await chat.doc(newGroupId).get();
//       //print("g: ${g['recentMessageTime']}");
//
//       // var gmsg =
//       //     await groupCollection.doc(newGroupId).collection("messages").get();
//       recentMsgTime.add(g['recentMessageTime']);
//       print("recentMsgTime: $recentMsgTime");
//
//       // print(gmsg.docs[0]['seen']);
//     }
//     return recentMsgTime;
//   }
//
//   Future getUserChatRecentMessage() async {
//     print("email $uid");
//     var snap = await user.where("email", isEqualTo: uid).get();
//     var u = await user.doc(snap.docs[0].id).get();
//     print("u2: ${u.data()}");
//     // var u = await user.doc(uid).get();
//     List<String> recentMessages = [];
//     for (var element in u['chat']) {
//       var newGroupId = element.toString().split("_")[0];
//       var g = await chat.doc(newGroupId).get();
//       // var gmsg =
//       //     await groupCollection.doc(newGroupId).collection("messages").get();
//       recentMessages.add(g['recentMessage']);
//
//       // print(gmsg.docs[0]['seen']);
//     }
//     return recentMessages;
//   }
//
//   Future<List<String>> getChatUserId() async {
//     List<String> allUserId = [];
//     print("UID: $uid");
//     var snap = await user.where("email", isEqualTo: uid).get();
//     var d = await user.doc(snap.docs[0].id).get();
//     print("D: ${d.data()}");
//     for (var element in d['chat']) {
//       var newGroupId = element.toString().split("_")[0];
//       var g = await chat.doc(newGroupId).get();
//       var newUserId = g['chatName'].toString().split("_")[0] == uid
//           ? g['chatName'].toString().split("_")[1]
//           : g['chatName'].toString().split("_")[0];
//       var newUserData = await user.doc(newUserId).get();
//       // var pp =
//       //     (newUserData.data() as Map<String, dynamic>)['profilePic'].toString();
//       allUserId.add(newUserId);
//       print(allUserId);
//     }
//     return allUserId;
//   }
//
//
//   sendMessage(String groupId, Map<String, dynamic> chatMessageData) async {
//     chat.doc(groupId).collection("messages").add(chatMessageData);
//     chat.doc(groupId).update({
//       "recentMessage": chatMessageData['message'],
//       "recentMessageSender": chatMessageData['sender'],
//       "recentMessageTime": chatMessageData['time'].toString(),
//     });
//   }
//
//   getChats(String groupId) async {
//     print("groupId $groupId");
//     return chat
//         .doc(groupId)
//         .collection("messages")
//         .orderBy("time")
//         .snapshots();
//   }
//
//   Future getChatAdmin(String groupId) async {
//     DocumentReference d = chat.doc(groupId);
//     DocumentSnapshot documentSnapshot = await d.get();
//     return documentSnapshot['admin'];
//   }
//
//   getMembers(String groupId) async {
//     return chat.doc(groupId).snapshots();
//   }
//
//
//   Future createGroup(
//       List<dynamic>? members, String groupName, String id) async {
//     dynamic membersId = [];
//     for (int i = 0; i < members!.length; i++) {
//       membersId.add(members[i].toString().split("_")[0]);
//     }
//     print("MembersId: $membersId");
//
//     var allGroupColl = await group.get();
//     var allGroupCollDocs = allGroupColl.docs.where((element) =>
//     (element.data() as Map<String, dynamic>)["members"][0]
//         .toString()
//         .split("_")[0] ==
//         id);
//     var userData = await user.doc(id).get();
//     dynamic membersData = [];
//     for (int i = 0; i < members!.length; i++) {
//       membersData = await user.doc(membersId[i]).get();
//       print("membersData: ${membersData.data()}");
//     }
//     print("$allGroupCollDocs");
//
//     // membersData.add(user.data()) ;
//     if (allGroupCollDocs.isEmpty) {
//       DocumentReference GroupDocumentReference =
//       await group.add({
//         "groupName": "$groupName",
//         "groupIcon": "",
//         "admin": "${id}_${userData["username"]}",
//         "members": [...members, "${id}_${userData["username"]}"],
//         "groupId": "",
//         "recentMessage": "",
//         "recentMessageSender": "",
//         "recentMessageTime": ""
//       });
//
//       await GroupDocumentReference.update({
//         "groupId": GroupDocumentReference.id,
//       });
//
//       DocumentReference userDocumentReference = user.doc(id);
//
//       await userDocumentReference.update({
//         "group": FieldValue.arrayUnion(
//             ["${GroupDocumentReference.id}_${groupName}"]),
//       });
//
//       for (int i = 0; i < membersId!.length; i++) {
//         DocumentReference user2DocumentReference =
//         user.doc(membersId[i]);
//
//         await user2DocumentReference.update({
//           "group": FieldValue.arrayUnion(
//               ["${GroupDocumentReference.id}_${groupName}"]),
//         });
//
//         // DatabaseService(uid: membersId).updateNotification(
//         //     "${userData["username"]} has created ${groupName} group_${DateTime.now()}");
//       }
//
//       return [
//         GroupDocumentReference.id,
//         membersData["username"],
//         userData["username"],
//         // (user2Data.data() as Map<String, dynamic>)['profilePic'],
//         // (userData.data() as Map<String, dynamic>)['profilePic'],
//       ];
//     } else {
//       var allGroupCollDocs1 = allGroupColl.docs.where((element) =>
//       (element.data() as Map<String, dynamic>)['groupName'].toString() ==
//           "$groupName");
//       if (allGroupCollDocs1.length == 1) {
//         return [
//           (allGroupCollDocs1.first.data() as Map<String, dynamic>)['groupId'],
//           membersData["username"],
//           userData["username"],
//           // (user2Data.data() as Map<String, dynamic>)['profilePic'],
//           // (userData.data() as Map<String, dynamic>)['profilePic'],
//         ];
//       }
//
//       return [];
//     }
//   }
//
//   Future getUserGroup() async {
//     var snap = await user.where("email", isEqualTo: uid).get();
//
//     return user.doc(snap.docs[0].id).snapshots();
//   }
//
//
//   Future getUserGroupRecentMessageTime() async {
//     var snap = await user.where("email", isEqualTo: uid).get();
//     var u = await user.doc(snap.docs[0].id).get();
//     print("u1: ${u.data()}");
//     // var u = await user.doc(uid).get();
//     List<String> recentMsgTime = [];
//     for (var element in u['group']) {
//       var newGroupId = element.toString().split("_")[0];
//       print("newGroupId: $newGroupId");
//
//       var g = await group.doc(newGroupId).get();
//       print("g: ${g['recentMessageTime']}");
//
//       // var gmsg =
//       //     await groupCollection.doc(newGroupId).collection("messages").get();
//       recentMsgTime.add(g['recentMessageTime']);
//       print("recentMsgTime: $recentMsgTime");
//
//       // print(gmsg.docs[0]['seen']);
//     }
//     return recentMsgTime;
//   }
//
//   Future getUserGroupRecentMessage() async {
//     var snap = await user.where("email", isEqualTo: uid).get();
//     var u = await user.doc(snap.docs[0].id).get();
//     print("u2: ${u.data()}");
//     // var u = await user.doc(uid).get();
//     List<String> recentMessages = [];
//     for (var element in u['group']) {
//       var newGroupId = element.toString().split("_")[0];
//       var g = await group.doc(newGroupId).get();
//       // var gmsg =
//       //     await groupCollection.doc(newGroupId).collection("messages").get();
//       recentMessages.add(g['recentMessage']);
//
//       // print(gmsg.docs[0]['seen']);
//     }
//     return recentMessages;
//   }
//
//   Future<List<String>> getUserGroupId() async {
//     List<String> allUserId = [];
//     var snap = await user.where("email", isEqualTo: uid).get();
//     var d = await user.doc(snap.docs[0].id).get();
//     for (var element in d['group']) {
//       var newGroupId = element.toString().split("_")[0];
//       var g = await group.doc(newGroupId).get();
//       var newUserId = g['members'].toString().split("_")[0];
//       var newUserData = await user.doc(newUserId).get();
//       // var pp =
//       //     (newUserData.data() as Map<String, dynamic>)['profilePic'].toString();
//       allUserId.add(newUserId);
//     }
//     return allUserId;
//   }
//
//   // Future<List<String>> getUserGroupId() async {
//   //   List<String> allUserId = [];
//   //   print("UID: $uid");
//   //   var snap = await user.where("email", isEqualTo: uid).get();
//   //   var d = await user.doc(snap.docs[0].id).get();
//   //   print("D: ${d.data()}");
//   //   for (var element in d['group']) {
//   //     var newGroupId = element.toString().split("_")[0];
//   //     var g = await group.doc(newGroupId).get();
//   //     var newUserId = g['groupName'].toString().split("_")[0] == uid
//   //         ? g['groupName'].toString().split("_")[1]
//   //         : g['groupName'].toString().split("_")[0];
//   //     var newUserData = await user.doc(newUserId).get();
//   //     // var pp =
//   //     //     (newUserData.data() as Map<String, dynamic>)['profilePic'].toString();
//   //     allUserId.add(newUserId);
//   //     print(allUserId);
//   //   }
//   //   return allUserId;
//   // }
//
//
//   sendGroupMessage(String groupId, Map<String, dynamic> chatMessageData) async {
//     group.doc(groupId).collection("messages").add(chatMessageData);
//     group.doc(groupId).update({
//       "recentMessage": chatMessageData['message'],
//       "recentMessageSender": chatMessageData['sender'],
//       "recentMessageTime": chatMessageData['time'].toString(),
//     });
//   }
//
//   getGroupChats(String groupId) async {
//     print("groupId $groupId");
//     return group
//         .doc(groupId)
//         .collection("messages")
//         .orderBy("time")
//         .snapshots();
//   }
//
//   Future getGroupAdmin(String groupId) async {
//     DocumentReference d = group.doc(groupId);
//     DocumentSnapshot documentSnapshot = await d.get();
//     return documentSnapshot['admin'];
//   }
//
//   getGroupMembers(String groupId) async {
//     return group.doc(groupId).snapshots();
//   }
//
//
//
//
//
// }