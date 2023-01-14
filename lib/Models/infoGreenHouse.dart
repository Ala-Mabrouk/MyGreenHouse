class InfoGreenHouse{
  String temperature='';
  String humidity='';
  String waterVan='closed';
  String UVlight='off';
  String timeCheck='00:00:00';
  InfoGreenHouse();
  InfoGreenHouse.args(String temp,String hum,String water,String light,String time){
    temperature=temp;
    humidity=hum;
    waterVan=water;
    UVlight=light;
    timeCheck=time;
  }
  InfoGreenHouse.fromJSON(Map<String,dynamic> mapData) {
    temperature=mapData['temp'].toString() ;
    humidity=mapData['hum'].toString();
    waterVan=mapData['water'].toString();
    UVlight=mapData['light'].toString();
    timeCheck=mapData['timeCheck'].toString();
  }
  Map<String,dynamic> InfoGreenHouseToMap(InfoGreenHouse info){
    Map<String,dynamic> result={};
    result['temp']=info.temperature;
    result['hum']=info.humidity;
    result['light']=info.UVlight;
    result['water']=info.waterVan;
    result['timeCheck']=info.timeCheck;
    return result;
  }
}