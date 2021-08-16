import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../api/Client.dart';

import '../api/Resource.dart';

class User {
  String? id;
  String? token;
  String? refreshToken;
  String? expiryTime;
  List? roles;
  String? fullname;
  String? firstName;
  String? lastName;
  String? email;
  String? profilePictureUrl;
  String? gender;
  String? dateOfBirth;
  bool? isSubscribedToEmailNotification;
  bool? isSubscribedToSMSNotification;
  bool? isSubscribedToPushNotification;
  String? phoneNumber;
  double? profileCompletionPercentage;
  bool? isPartner = false;
  bool? isAdmin = false;
  String? timeCreated;
  bool? isSocialSignUp = false;

  User({
    this.id,
    this.token,
    this.refreshToken,
    this.expiryTime,
    this.roles,
    this.fullname,
    this.firstName,
    this.lastName,
    this.email,
    this.profilePictureUrl,
    this.gender,
    this.dateOfBirth,
    this.isSubscribedToEmailNotification,
    this.isSubscribedToSMSNotification,
    this.isSubscribedToPushNotification,
    this.phoneNumber,
    this.profileCompletionPercentage,
    this.isPartner,
    this.isAdmin,
    this.timeCreated,
    this.isSocialSignUp,
  });

  // Map user fields as form fields
  static Map editables = <String, String>{
    'First Name': 'firstName',
    'Last Name': 'lastName',
    'Gender': 'gender',
    'Email Address': 'email',
    'Password': '*' * 10,
    'Phone Number': 'phoneNumber',
    'DOB': 'dateOfBirth',
    'Address Book': 'View all',
  };

  factory User.fromJson(Map json) {
    return User(
      id: json['id'],
      token: json['token'],
      refreshToken: json['refreshToken'],
      expiryTime: json['expiryTime'],
      roles: json['roles'],
      fullname: json['fullname'] ?? "${json['firstName']} ${json['lastName']}",
      firstName: json['firstName'] ?? json['fullname'].split(' ')[0],
      lastName: json['lastName'] ??
          json['fullname'].split(' ')[1], // TODO: check error,
      email: json['email'],
      profilePictureUrl: json['profilePictureUrl'],
      gender: json['gender'],
      dateOfBirth: json['dateOfBirth'],
      isSubscribedToEmailNotification: json['isSubscribedToEmailNotification'],
      isSubscribedToSMSNotification: json['isSubscribedToPushNotification'],
      isSubscribedToPushNotification: json['isSubscribedToPushNotification'],
      phoneNumber: json['phoneNumber'],
      profileCompletionPercentage: json['profileCompletionPercentage'],
      isPartner: json['isPartner'],
      isAdmin: json['isAdmin'],
      timeCreated: json['timeCreated'],
      isSocialSignUp: json['isSocialSignUp'],
    );
  }

  Map toMap() {
    final data = Map<String, dynamic>();

    data['id'] = id;
    data['token'] = token;
    data['refreshToken'] = refreshToken;
    data['expiryTime'] = expiryTime;
    data['roles'] = roles;
    data['fullname'] = fullname;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['email'] = email;
    data['profilePictureUrl'] = profilePictureUrl;
    data['gender'] = gender;
    data['dateOfBirth'] = dateOfBirth;
    data['isSubscribedToEmailNotification'] = isSubscribedToEmailNotification;
    data['isSubscribedToSMSNotification'] = isSubscribedToSMSNotification;
    data['isSubscribedToPushNotification'] = isSubscribedToPushNotification;
    data['phoneNumber'] = phoneNumber;
    data['profileCompletionPercentag'] = profileCompletionPercentage;
    data['isPartner'] = isPartner;
    data['isAdmin'] = isAdmin;
    data['timeCreated'] = timeCreated;
    data['isSocialSignUp'] = isSocialSignUp;

    return data;
  }

  static Resource signIn(Map payload) {
    return Resource(
      url: 'accounts/login',
      data: payload,
      parse: (response) {
        return User.fromJson(response["data"]);
      },
    );
  }

  static Resource register(Map payload) {
    return Resource(
      url: 'accounts/register',
      data: payload,
      // queryParameters: {"redirectUrl": deepLink},
      parse: (response) {
        return User.fromJson(response["data"]);
      },
    );
  }

  static Resource forgotPassword(Map payload) {
    return Resource(
      url: 'accounts/password/forgot',
      data: payload,
      parse: (response) {
        return response;
      },
    );
  }

  static Resource registerUserFromSocial(fb.User user) {
    return Resource(
      url: 'accounts/external/login',
      data: {
        "displayName": user.displayName,
        "email": user.email,
        "photoUrl": user.photoURL,
        "phoneNumber": user.phoneNumber,
        "emailVerified": user.emailVerified,
        "uid": user.uid,
        "issuer": user.providerData[0].providerId,
      },
      parse: (response) {
        print(response);
        var _user = User.fromJson(response["data"]);

        return _user;
      },
    );
  }

  static Resource getCurrentUser(User user) {
    return Resource(
      url: 'users/${user.id}',
      parse: (response) {
        return User.fromJson(response["data"]);
      },
    );
  }

  Future<void> saveId() async {
    print(this.toMap());
    Client _client = Client();
    FlutterSecureStorage _store = FlutterSecureStorage();

    // save user
    await _store.write(key: 'user', value: json.encode(this.toMap()));

    // save user id
    await _store.write(key: 'userId', value: this.id);

    // save token
    var data = <String, dynamic>{
      "token": this.token,
      "refreshToken": this.refreshToken
    };

    await _client.writeTokens(data);
  }

  static Resource updateUser(Map attributes, String userId) {
    return Resource(
      url: 'users/$userId',
      data: attributes,
      parse: (response) {
        return User.fromJson(
          response['data'],
        );
      },
    );
  }
}
