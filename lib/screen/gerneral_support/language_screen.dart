import 'package:carlink/Localmodal_screen.dart';
import 'package:carlink/utils/App_content.dart';
import 'package:carlink/utils/Colors.dart';
import 'package:carlink/utils/Dark_lightmode.dart';
import 'package:carlink/utils/fontfameli_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  late ColorNotifire notifire;
  List country=[
    Appcontent.english,
    Appcontent.spain,
    Appcontent.arab,
    Appcontent.india,
    Appcontent.india,
    Appcontent.africa,
    Appcontent.bangladesh,
    Appcontent.indonesia,
  ];
  List name=[
    {"title" :'English' , "id" : "en_US"},
    {"title" :'Spanish' , "id" : "sp_SP"},
    {"title" :'Arabic' , "id" : "ar_AR"},
    {"title" :'Hindi' , "id" : "hi_IN"},
    {"title" :'Gujarati' , "id" : "gu_IN"},
    {"title" :'Afrikaans' , "id" : "af_AF"},
    {"title" :'Bengali' , "id" : "be_BE"},
    {"title" :'Indonesian' , "id" : "IE_ND"},
  ];


  fun() async {
    for(int a= 0 ;a<name.length;a++){
      if(name[a]["id"].toString().compareTo(Get.locale.toString()) == 0){
        setState(() {
          value = a;
        });

      }else{
      }
    }

    final prefs = await SharedPreferences.getInstance();
    localeModel = LocaleModel(prefs);
  }

  @override
  void initState() {
    fun();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    notifire =Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      backgroundColor: notifire.getbgcolor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: onbordingBlue,
        centerTitle: true,
        title:  Text('Language'.tr, style: const TextStyle(color: Colors.white, fontFamily: FontFamily.europaBold),),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
                itemCount: name.length,
                itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  child: InkWell(
                    onTap: ()  {
        
                      setState(() {
                        value = index;
                        switch (index) {
                          case 0:
                            localeModel!.set(const Locale('en', 'US'));
                            Get.updateLocale(
                                const Locale('en', 'US'));
        
                            Get.back();
                            break;
                          case 1:
                            localeModel!.set(const Locale('sp', 'SP'));
                            Get.updateLocale(
                                const Locale('sp', 'SP'));
        
                            Get.back();
                            break;
                          case 2:
                            localeModel!.set(const Locale('ar', 'AR'));
                            Get.updateLocale(
                                const Locale('ar', 'AR'));
        
                            Get.back();
                            break;
                          case 3:
                            localeModel!.set(const Locale('hi', 'IN'));
                            Get.updateLocale(
        
                                const Locale('hi', 'IN'));
        
                            Get.back();
                            break;
                          case 4:
                            localeModel!.set(const Locale('gu', 'IN'));
                            Get.updateLocale(
                                const Locale('gu', 'IN'));
        
                            Get.back();
                            break;
                          case 5:
                            localeModel!.set(const Locale('af', 'AF'));
                            Get.updateLocale(
        
                                const Locale('af', 'AF'));
                            Get.back();
                            break;
                          case 6:
                            localeModel!.set(const Locale('be', 'BE'));
                            Get.updateLocale(
                                const Locale('be', 'BE'));
        
                            Get.back();
                            break;
                          case 7:
                            localeModel!.set(const Locale('IE', 'ND'));
                            Get.updateLocale(const Locale('IE', 'ND'));
                            Get.back();
                        }
        
                      });
                    },
                    child: ListTile(
                      leading: Container(
                        height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(image: AssetImage(country[index]),fit: BoxFit.cover),
                          ),
                      ),
                      title: Text(name[index]["title"], style: TextStyle(color: notifire.getwhiteblackcolor,fontFamily: FontFamily.europaBold),),
                      trailing: Container(
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(
                          color:  (value == index) ? Colors.white : const Color(0xffE2E8F0),
                          shape: BoxShape.circle,
                          border: Border.all(color: (value == index) ? onbordingBlue : const Color(0xffE2E8F0),width: 7),
                        ),
                      ),
                    ),
                  ),
                );
            }),
          ],
        ),
      ),
    );
  }
  int value=0;
  LocaleModel? localeModel;
}
