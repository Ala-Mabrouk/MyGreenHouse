class UserApp {
  String userUID = '0';
  String userName = 'foulen';
  String userLastName = 'ben foulen';
  String userAvatar =
      'https://e7.pngegg.com/pngimages/799/987/png-clipart-computer-icons-avatar-icon-design-avatar-heroes-computer-wallpaper-thumbnail.png'; //url to img in the firebase storage
  String userCoverImg='http://cdn.shopify.com/s/files/1/0200/5036/products/Greenhouse_1200x630.jpg?v=1505284719';
  String userMail = 'bf.foulen@mail.com';
  String userPass = '123456789';
  String userPhone = '+21600000000';
  String userDateNaissance = '00/00/0000';
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
