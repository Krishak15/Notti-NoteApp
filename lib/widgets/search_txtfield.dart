import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField(
      {super.key,
      required this.searchController,
      required this.onChangeSearchText});

  final TextEditingController searchController;
  final Function(String) onChangeSearchText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: searchController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.search,
      onChanged: onChangeSearchText,
      cursorColor: Colors.white,
      style: GoogleFonts.poppins(color: Colors.white),
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.all(Radius.circular(25))),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white)),
        labelText: 'Search notes',
        labelStyle: GoogleFonts.poppins(color: Colors.white),
      ),
    );
  }
}
