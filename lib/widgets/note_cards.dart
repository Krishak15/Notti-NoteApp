import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_noteapp/constants/appstyles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget noteCard(
    Function()? onTap, QueryDocumentSnapshot doc, Function()? onLongPress) {
  return InkWell(
    onLongPress: onLongPress,
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(bgImages[doc['image_id']]), fit: BoxFit.cover),
          color: cardsColori[doc['color_id']],
          borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15)),
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doc['title'],
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: GoogleFonts.poppins(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Expanded(
                        child: SizedBox(
                            child: Text(
                          doc['description'],
                          overflow: TextOverflow.ellipsis,
                          maxLines: 4,
                          style: GoogleFonts.poppins(fontSize: 12),
                        )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Text(
            doc['created'].toString(),
            style: GoogleFonts.poppins(fontSize: 10),
          )
        ],
      ),
    ),
  );
}
