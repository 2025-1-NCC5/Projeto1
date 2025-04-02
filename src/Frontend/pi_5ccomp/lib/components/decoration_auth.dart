import 'package:flutter/material.dart';

InputDecoration getAuthenticationInputDecoration(String label) {
  return InputDecoration(
    hintText: label,
    fillColor: Color.fromARGB(1000, 217, 217, 217),
    filled: true,
    contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none
    ),
  );
}
