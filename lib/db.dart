// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables, no_leading_underscores_for_local_identifiers

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseManager {
  final CollectionReference playerList =
      FirebaseFirestore.instance.collection('Player');

  final CollectionReference ownerList =
      FirebaseFirestore.instance.collection('GOwner');

  final CollectionReference groundList =
      FirebaseFirestore.instance.collection('Ground');

  Future<void> createUserData(String name, String gender, int age, uid) async {
    return await playerList
        .doc(uid)
        .set({'name': name, 'age': age, 'gender': gender});
  }

  // To save device token
  Future<void> saveToken(String token, uid) async {
    return await playerList.doc(uid).update({'token': token});
  }

  // Update User Data
  Future<void> updateUserData(String name, String gender, int age, uid) async {
    return await playerList
        .doc(uid)
        .update({'name': name, 'age': age, 'gender': gender});
  }

  Future getUserData(uid) async {
    List userData = [];
    try {
      await playerList.doc(uid).get().then((value) {
        userData = value as List;
      });
      return userData;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> createVenderData(String name, int age, uid) async {
    return await ownerList.doc(uid).set({'name': name, 'age': age});
  }

// For saving schedule data
  Future<void> addGroundLocData(
      latitude, longitute, var address, gid, uid) async {
    return await groundList.doc(gid).set({
      'OwnerId': uid,
      'latitude': latitude,
      'longitude': longitute,
      'Address': address
    });
  }

// for ground location add
  Future<void> addScheduleDate(
      gName, sport, date, time, var address, gid, uid) async {
    return await playerList.doc(uid).collection('Schedule').doc(gid).set({
      'Ground Name': gName,
      'Ground Location': address,
      'Sport': sport,
      'Date': date,
      'time': time,
      'Ground Id': gid
    });
  }

// for ground other information adding
  Future<void> addGroundData(name, fees, availSports, groundType,
      organizationType, openingTym, closingTym, gid) async {
    return await groundList.doc(gid).update({
      'Ground Name': name,
      'Fees': fees,
      'Available Sports': availSports,
      'Ground Type': groundType,
      'Organization Type': organizationType,
      'Opening Time': openingTym,
      'Closing Time': closingTym
    });
  }

  // To fetch perticular player's schedule data
  Future getScheduleDataList(uid) async {
    List scheduleList = [];
    try {
      await playerList
          .doc(uid)
          .collection('Schedule')
          .get()
          .then((querySnapshot) {
        for (var element in querySnapshot.docs) {
          scheduleList.add(element);
        }
      });
      return scheduleList;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // To get ground List
  Future getGroundList() async {
    List _groundList = [];
    try {
      await groundList.get().then((querySnapshot) {
        for (var element in querySnapshot.docs) {
          _groundList.add(element);
        }
      });
      return _groundList;
    } catch (e) {
      print(e.toString());
    }
  }

  // For getting players list that are registered themselves in the ground
  Future getPlayerInGroundList(gid, uid) async {
    List _playerList = [];
    try {
      await groundList
          .doc(gid)
          .collection('Players').where('playerId', isNotEqualTo: uid)
          .get()
          .then((querySnapshot) {
        for (var element in querySnapshot.docs) {
          _playerList.add(element);
        }
      });
      return _playerList;
    } catch (e) {
      print(e.toString());
    }
  }

  Future getPlayerDetails(uid) async {
    var name;
    var age;
    var gender;
    try {
      await playerList.doc(uid).get().then((snapShot) async {
        name = snapShot.get("name");
        age = snapShot.get("age");
        gender = snapShot.get("gender");
      });
      return [name, age, gender];
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
