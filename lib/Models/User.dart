class UserApp {
  String userUID = '';
  String userName = '';
  String userLastName = '';
  String userAvatar =
      'https://www.kindpng.com/picc/m/78-785827_user-profile-avatar-login-account-male-user-icon.png'; //url to img in the firebase storage
  String userMail = '';
  String userPass = '';
  String userPhone = '';
  String userDateNaissance = '';
  bool userIsSubscribed = false;

  UserApp();
  UserApp.args(String usermail, String username, String userlastname,
      String useravatar, String userphone, bool subscribtion) {
    userAvatar = useravatar;
    userName = username;
    userLastName = userlastname;
    userMail = usermail;
    userPhone = userphone;
    userIsSubscribed = subscribtion;
  }
  UserApp.fromJSON(Map<String, dynamic> map) {
    userMail = map['e-mail'] ?? '';
    userName = map['Name'] ?? '';
    userLastName = map['LastName'] ?? '';
    userAvatar = map['avatarPath'] ?? '';
    userPhone = map['Phone'] ?? '';
    userIsSubscribed = map['subscribed'] ?? false;
    userDateNaissance = map['dateNaissance'] ?? '--/--/----';
  }
  Map<String, dynamic> userToMap(UserApp user) {
    Map<String, dynamic> data = <String, dynamic>{};
    data['e-mail'] = user.userMail;
    data['Name'] = user.userName;
    data['LastName'] = user.userLastName;
    data['avatarPath'] = user.userAvatar;
    data['Phone'] = user.userPhone;
    data['subscribed'] = user.userIsSubscribed;
    data['dateNaissance'] = user.userDateNaissance;
    return data;
  }
}
