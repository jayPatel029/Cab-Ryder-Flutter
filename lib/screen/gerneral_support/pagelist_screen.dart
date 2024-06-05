// ignore_for_file: empty_catches
import 'dart:convert';
import 'package:carlink/utils/Dark_lightmode.dart';
import 'package:http/http.dart' as http;
import 'package:carlink/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import '../../model/policy_modal.dart';
import '../../utils/Colors.dart';
import '../../utils/common.dart';
import '../../utils/fontfameli_model.dart';

class PageListScreen extends StatefulWidget {
  final String title;
  final String description;
  const PageListScreen({super.key, required this.title, required this.description});

  @override
  State<PageListScreen> createState() => _PageListScreenState();
}

class _PageListScreenState extends State<PageListScreen> {
  late ColorNotifire notifire;
  late PolicyPage pPage;
  bool loading = true;
  Future policy() async {
    try{
      var response = await http.post(Uri.parse(Config.baseUrl+Config.policy), headers: {
        'Content-Type': 'application/json',
      });
      if(response.statusCode == 200){
        setState(() {
          pPage = policyPageFromJson(response.body);
          loading = false;
        });
        var data = jsonDecode(response.body.toString());
        return data;
      } else {}
    } catch(e){}
  }
  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context);
    return Scaffold(
      backgroundColor: notifire.getbgcolor,
      appBar: AppBar(
        backgroundColor: onbordingBlue,
        centerTitle: true,
        elevation: 0,
        title: Text(widget.title, style: TextStyle(fontFamily: FontFamily.europaBold, color: WhiteColor, fontSize: 16)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(13),
          child: Center(
            child: HtmlWidget(
              renderMode: RenderMode.column,
              onLoadingBuilder: (context, element, loadingProgress) {
                return SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: loader());
              },
              widget.description,
              textStyle: TextStyle(color: notifire.getwhiteblackcolor, fontSize: 17, fontFamily: FontFamily.europaWoff),
            ),
          ),
        ),
      ),
    );
  }
}
