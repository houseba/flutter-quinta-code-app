import 'package:flutter/material.dart';
import 'package:quinta_code/constants.dart';

class AppUtils {
  static Future<bool> mostrarConfirmacion(
    BuildContext context,
    String titulo,
    String mensaje,
  ) async {
    final resultado = await showDialog<bool>(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Constants.primary_color,
          iconColor: Constants.secondary_color,
          title: Text(titulo),
          content: Text(mensaje),
          actions: [
            TextButton(
              child: Text('No borrar', style: TextStyle(color: Constants.accent_color)),
              onPressed: () => Navigator.pop(context, false),
            ),
            OutlinedButton(
              child: Text('Borrar', style: TextStyle(color: Constants.accent_color)),
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        );
      },
    );
    return resultado ?? false;
  }
}