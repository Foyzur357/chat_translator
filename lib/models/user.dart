import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  UserData({
    required this.id,
    this.name,
    this.userName,
    this.email,
    this.avatar,
    this.bio,
    this.birthDate,
    this.phoneNumber,
    this.country,
    this.gender,
    this.nativeLanguage,
    this.learningLanguage,
    this.firebaseToken,
  });

  late String id;
  String? name;
  String? userName;
  String? email;
  String? avatar;
  String? bio;
  DateTime? birthDate;
  String? phoneNumber;
  String? country;
  String? gender;
  String? nativeLanguage;
  String? learningLanguage;
  String? firebaseToken;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'userName': userName,
      'email': email,
      'avatar': avatar,
      'aboutMe': bio,
      'birthDate': Timestamp.fromDate(birthDate!),
      'phoneNumber': phoneNumber,
      'country': country,
      'gender': gender,
      'nativeLanguage': nativeLanguage,
      'learningLanguage': learningLanguage,
      'firebaseToken': firebaseToken,
    };
  }

  UserData.fromJson(Map<String, dynamic> doc) {
    id = doc['id'] as String;
    name = doc['name'] as String?;
    userName = doc['userName'] as String?;
    email = doc['email'] as String?;
    avatar = doc['avatar'] as String?;
    bio = doc['aboutMe'] as String?;
    birthDate = (doc['birthDate'] as Timestamp?)?.toDate();
    phoneNumber = doc['phoneNumber'] as String?;
    country = doc['country'] as String?;
    gender = doc['gender'] as String?;
    nativeLanguage = doc['nativeLanguage'] as String?;
    learningLanguage = doc['learningLanguage'] as String?;
    firebaseToken = doc['firebaseToken'] as String?;
  }

  @override
  String toString() {
    return 'UserData{id: $id, name: $name, userName: $userName, email: $email, avatar: $avatar, aboutMe: $bio,  birthDate: $birthDate, phoneNumber: $phoneNumber, country: $country, gender: $gender, nativeLanguage: $nativeLanguage, learningLanguage: $learningLanguage, firebaseToken: $firebaseToken}';
    // age: $age,
  }
}
