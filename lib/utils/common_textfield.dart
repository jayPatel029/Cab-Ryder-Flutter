import 'package:flutter/material.dart';
import 'Colors.dart';
import 'fontfameli_model.dart';

Widget textfield1({required String title,Color? textColor, required String enterName,TextEditingController? controller, TextInputType? textInputType, required Color fillcolor, Color? color}){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title,style:  TextStyle(color: color,fontFamily: FontFamily.europaBold,fontSize: 15)),
      const SizedBox(height: 10),
      SizedBox(
        height: 50,
        child: TextField(
          style: TextStyle(color: textColor),
          controller: controller,
          readOnly: true,
          keyboardType: textInputType,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(8),
            filled: true,
            fillColor: fillcolor,
            enabledBorder: OutlineInputBorder(borderSide: BorderSide.none,borderRadius: BorderRadius.circular(10)),
            disabledBorder: OutlineInputBorder(borderSide:BorderSide.none,borderRadius: BorderRadius.circular(10)),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide.none,borderRadius: BorderRadius.circular(10)),
            hintText: enterName,
            hintStyle: TextStyle(color: greyScale,fontSize: 13),
          ),
        ),
      ),
      const SizedBox(height: 13),
    ],
  );
}

Widget textarea({required String title, Color? textColor,Color? colors, required String enterName,TextEditingController? controller, TextInputType? textInputType,required Color color, String? validator}){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title,style:  TextStyle(color: colors,fontFamily: FontFamily.europaBold,fontSize: 15)),
      const SizedBox(height: 10),
      TextFormField(
        style: TextStyle(color: textColor),
        controller: controller,
        keyboardType: textInputType,
        validator: (value) {
          if(value ==null || value.isEmpty){
            return validator;
          }
          return null;
        },
        maxLines: 6,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: color),borderRadius: BorderRadius.circular(10)),
          disabledBorder: OutlineInputBorder(borderSide:BorderSide(color: color),borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: onbordingBlue),borderRadius: BorderRadius.circular(10)),
          errorBorder: OutlineInputBorder(borderSide: BorderSide(color: onbordingBlue),borderRadius: BorderRadius.circular(10)),
          focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: onbordingBlue),borderRadius: BorderRadius.circular(10)),
          hintText: enterName,
          hintStyle: TextStyle(color: greyScale,fontSize: 13),
        ),
      ),
      const SizedBox(height: 13),
    ],
  );
}
