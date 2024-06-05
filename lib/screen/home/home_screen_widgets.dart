import 'package:flutter/material.dart';

class HomeOperatorButton extends StatelessWidget {

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;


  const HomeOperatorButton({super.key, required this.label, required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {


    return GestureDetector(
      onTap: onTap,

      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(2,2),
            ),
          ],
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color,),
            SizedBox(height: 10,),
            Text(label, style: TextStyle(color: Colors.black),)
          ],
        ),
      ),
    );
  }
}
