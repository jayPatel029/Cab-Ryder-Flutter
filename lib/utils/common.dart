import 'dart:ui';
import 'package:flutter/material.dart';
import 'App_content.dart';
import 'Colors.dart';
import 'fontfameli_model.dart';

loader(){
  return Center(child: CircularProgressIndicator(color: onbordingBlue));
}

blurTitle({required String title, context}){
  return ClipRRect(
    borderRadius: BorderRadius.circular(20),
    child: Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.4), borderRadius: BorderRadius.circular(20)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Text(title, style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white, fontSize: 12, fontFamily: FontFamily.europaBold)),
      ),
    ),
  );
}

blurRating({required String rating, required Color color, context}){
  return ClipRRect(
    borderRadius: BorderRadius.circular(20),
    child: Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.4), borderRadius: BorderRadius.circular(20)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        // child: Text(title, style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white, fontSize: 12)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 3, 0),
              child: Image.asset(Appcontent.star1, height: 16),
            ),
            Text(rating, style:   TextStyle(fontFamily: FontFamily.europaWoff, color: color)),
          ],
        ),
      ),
    ),
  );
}