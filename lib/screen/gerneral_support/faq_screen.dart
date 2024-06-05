// ignore_for_file: empty_catches, prefer_typing_uninitialized_variables
import 'dart:convert';
import 'package:carlink/model/faqdata_modal.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:carlink/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/Colors.dart';
import '../../utils/Dark_lightmode.dart';
import '../../utils/common.dart';
import '../../utils/fontfameli_model.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  late ColorNotifire notifire;
  late FaqData fData;
  bool isLoading = true;

  @override
  void initState() {
    save();
    super.initState();
  }

  var name;
  save() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    name = jsonDecode(prefs.getString('UserLogin')!);
    faq();
  }

  Future faq() async {
    Map body = {
      "uid" : name['id'],
    };
    try{
      var response = await http.post(Uri.parse(Config.baseUrl+Config.faq),  body: jsonEncode(body), headers: {
        'Content-Type': 'application/json',
      });
      if(response.statusCode == 200){
        setState(() {
          fData = faqDataFromJson(response.body);
          isLoading = false;
        });
        var data = jsonDecode(response.body.toString());
        return data;
      } else {}
    } catch(e){}
  }
  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      backgroundColor: notifire.getbgcolor,
      appBar: AppBar(
        backgroundColor: onbordingBlue,
        centerTitle: true,
        elevation: 0,
        title: Text("FAQ".tr, style: TextStyle(fontFamily: FontFamily.europaBold, color: WhiteColor, fontSize: 16)),
      ),
      body: isLoading ? loader() : SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: fData.faqData.length,
                itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.withOpacity(0.20)),
                  ),
                  child: ExpansionTile(
                    collapsedIconColor: notifire.getwhiteblackcolor,
                    iconColor: onbordingBlue,
                    textColor: onbordingBlue,
                    shape: RoundedRectangleBorder(side: BorderSide(color: onbordingBlue), borderRadius: BorderRadius.circular(10)),
                    title: Text(fData.faqData[index].question, style:  TextStyle(fontFamily: FontFamily.europaBold, color: notifire.getwhiteblackcolor)),
                    children: <Widget>[
                      ListTile(
                        title: Text(fData.faqData[index].answer, style:  TextStyle(fontFamily: FontFamily.europaWoff, color: notifire.getwhiteblackcolor)),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                );
            }),
          ],
        ),
      ),
    );
  }
}
