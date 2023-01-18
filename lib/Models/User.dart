import 'package:my_greenhouse/Widgets/Constants.dart';

class UserApp {
  String userUID = '0';
  String userName = 'foulen';
  String userLastName = 'ben foulen';
  String userAvatar = DAvatarImg;
  String userCoverImg = DCoverImg;
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
    userAvatar = map['avatarPath'] ?? DAvatarImg;
    userPhone = map['Phone'] ?? '';
    userCoverImg = map['coverImage'] ?? DCoverImg;
    userDateNaissance = map['dateNaissance'] ?? '--/--/----';
  }
  Map<String, dynamic> userToMap(UserApp user) {
    Map<String, dynamic> data = <String, dynamic>{};
    data['e-mail'] = user.userMail;
    data['Name'] = user.userName;
    data['LastName'] = user.userLastName;
    data['avatarPath'] = user.userAvatar;
    data['coverImage'] = user.userCoverImg;
    data['Phone'] = user.userPhone;
    data['dateNaissance'] = user.userDateNaissance;
    return data;
  }
}
