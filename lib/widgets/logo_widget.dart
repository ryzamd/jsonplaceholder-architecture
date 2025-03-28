import 'package:flutter/material.dart';

Widget buildLogoWidget() {
  return Column(
    children: [
      Container(
        height: 120,
        width: 120,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0xFF1d3557).withValues(alpha: 0.5 ),
              blurRadius: 10,
              // spreadRadius: ,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 13.0),
          child: Image.asset(
            'assets/images/zucca-logo.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
      const SizedBox(height: 16),
      Text(
        'PRO WELL',
        style: TextStyle(
            color: Color(0xFFFFFFFF),
            fontSize: 30,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins'
        )
      ),
    ],
  );
}
