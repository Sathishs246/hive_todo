import 'package:flutter/material.dart';
import 'package:hive_todo/utils/app_colors.dart';

import '../../../utils/app_strings.dart';

class RepTextField extends StatelessWidget {
  const RepTextField({
    super.key,
    required this.controller,
    this.isForDescription = false,
    required this.onFieldSubmitted,
    required this.onChanged,
  });
  final TextEditingController? controller;
  final Function(String)? onFieldSubmitted;
  final Function(String)? onChanged;
  final bool isForDescription;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ListTile(
        title: TextFormField(
          controller: controller,
          maxLines: !isForDescription ? 6 : null,
          cursorHeight: !isForDescription ? 40 : null,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            //fillColor: Colors.red,
            border: isForDescription ? InputBorder.none : null,
            counter: Container(),
            hintText: isForDescription ? AppStrings.addNote : null,
            prefixIcon:
                isForDescription
                    ? const Icon(Icons.bookmark_border, color: Colors.grey)
                    : null,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primaryColor),
              borderRadius: BorderRadius.circular(20),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primaryColor),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onFieldSubmitted: onFieldSubmitted,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
