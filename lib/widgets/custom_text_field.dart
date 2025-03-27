import 'package:flutter/material.dart';

Widget buildUsernameField() {
  return Container(
    height: 56,
    decoration: BoxDecoration(
      color: Color(0xFFf1faee),
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextFormField(
              decoration: const InputDecoration(
                hintText: '请选择用户名', // "Please select username"
                border: InputBorder.none,
                fillColor: Color(0xFFf1faee),
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(right: 16.0),
          child: Icon(Icons.arrow_drop_down, color: Colors.grey),
        ),
      ],
    ),
  );
}

Widget buildPasswordField() {
  return Container(
    height: 56,
    decoration: BoxDecoration(
      color: Color(0xFFf1faee),
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextFormField(
              obscureText: true,
              decoration: const InputDecoration(
                hintText: '输入密码', // "Enter password"
                border: InputBorder.none,
                fillColor: Color(0xFFf1faee),
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget buildCodeField() {
  return Container(
    height: 56,
    decoration: BoxDecoration(
      color: Color(0xFFf1faee),
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextFormField(
              decoration: const InputDecoration(
                hintText: '输入验码', // "Enter verification code"
                border: InputBorder.none,
                fillColor: Color(0xFFf1faee),
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}