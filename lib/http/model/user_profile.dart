class UserModel {
  String? email;
  String? phoneNUmber;
  String? hobby;
  String? password;
  String? uid;

  UserModel(
      {this.email, this.uid, this.phoneNUmber, this.hobby, this.password});

  //data to server
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
      'phoneNumber': phoneNUmber,
      'hobby': hobby,
      'uid': uid,
    };
  }

  //data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      email: map['email'] ?? '',
      phoneNUmber: map['phoneNumber'] ?? '',
      hobby: map['hobby'] ?? '',
      uid: map['uid'] ?? '',
    );
  }
}
