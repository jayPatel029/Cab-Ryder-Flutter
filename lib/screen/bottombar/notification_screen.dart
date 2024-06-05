// ignore_for_file: empty_catches
import 'dart:convert';
import 'package:carlink/utils/Colors.dart';
import 'package:carlink/utils/common_ematy.dart';
import 'package:carlink/utils/config.dart';
import 'package:carlink/utils/fontfameli_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/notificationlist_modal.dart';
import '../../utils/App_content.dart';
import '../../utils/Dark_lightmode.dart';
import 'package:http/http.dart' as http;
import '../../utils/common.dart';

class NotificationScreen extends StatefulWidget {
  final String? uid;
  const NotificationScreen({super.key, this.uid});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late ColorNotifire notifire;
  NotificatonListModal? notificatonListModal;
  bool loading = true;
  Future notification(uid) async {
    Map body ={
      "uid": uid,
    };
    try{
      var response = await http.post(Uri.parse(Config.baseUrl+Config.notificationList), body: jsonEncode(body), headers: {
        'Content-Type': 'application/json',
      });
      if(response.statusCode == 200){
        setState(() {
          notificatonListModal = notificatonListModalFromJson(response.body);
          loading =false;
        });
        var data = jsonDecode(response.body.toString());
        return data;
      } else {
        var data = jsonDecode(response.body.toString());
        return data;
      }
    } catch(e){}
  }

  @override
  void initState() {
    validate();
    super.initState();
  }


  validate() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var id = widget.uid == "0" ? "0" :jsonDecode(preferences.getString('UserLogin')!);
    notification(widget.uid == "0" ? "0" : id['id']);
  }
  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      backgroundColor: notifire.getbgcolor,
      appBar: AppBar(
        backgroundColor: notifire.getbgcolor,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back, color:  notifire.getwhiteblackcolor,),
        ),
        centerTitle: true,
        title: Text('Notifications'.tr, style: TextStyle(fontSize: 18, fontFamily: FontFamily.europaBold, color:  notifire.getwhiteblackcolor,),),
      ),
      body: loading ? loader() : notificatonListModal!.notificationData.isEmpty ? ematy(title: 'Notifications'.tr) : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 15),
          shrinkWrap: true,
          itemCount: notificatonListModal!.notificationData.length,
          separatorBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Divider(
                color: greyScale,
                indent: 3,
                endIndent: 3,
              ),
            );
          },
          itemBuilder: (context, index) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: greyScale.withOpacity(0.40))
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Image.asset(Appcontent.notification, color: notifire.getwhiteblackcolor),
                      ),
                    ),
                    title: Text(notificatonListModal!.notificationData[index].title, style: TextStyle(fontSize: 18, fontFamily: FontFamily.europaBold,  color:  notifire.getwhiteblackcolor,),),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(notificatonListModal!.notificationData[index].description, style: TextStyle(fontSize: 15, fontFamily: FontFamily.europaWoff,  color:  greyScale)),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Image.asset(Appcontent.clock, height: 16, width: 16, color: greyScale,),
                            const SizedBox(width: 8),
                            Text(DateFormat.yMd().add_jm().format(DateTime.parse(notificatonListModal!.notificationData[index].datetime.toString())), style: TextStyle(fontSize: 12, fontFamily: FontFamily.europaWoff,  color:  greyScale)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },),
      ),
    );
  }
}
