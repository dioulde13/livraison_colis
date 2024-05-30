import 'package:flutter/material.dart';

Widget tableau(
    String texte1,
    String texte2,
    Color color
    ) {
  return Table(
    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
    children: [
      TableRow(
        children: [
          TableCell(
            child: Text(texte1,
              style: TextStyle(
                  fontWeight: FontWeight.w300,
                  color: color
              ),
            ),
          ),

          TableCell(
            child: Text(texte2,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: color
                ),
            ),
          ),
        ],
      ),
    ],
  );
}