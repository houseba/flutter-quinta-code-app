// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:quinta_code/constants.dart';
import 'package:quinta_code/services/fs_service.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AgregarEventoPage extends StatefulWidget {
  const AgregarEventoPage({super.key});

  @override
  State<AgregarEventoPage> createState() => _AgregarEventoPageState();
}

class _AgregarEventoPageState extends State<AgregarEventoPage> {

  final formKey = GlobalKey<FormState>();
  TextEditingController tituloController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController fechaHoraController = TextEditingController();
  TextEditingController lugarController = TextEditingController();
  String? categoriaSeleccionada;

  // Lógica de parseo centralizada para evitar duplicación
  DateTime? _parseFechaHora(String valor) {
    final trimmed = valor.trim();
    // Trata de parsear la fecha
    final fecha = DateTime.tryParse(trimmed);
    if (fecha != null) return fecha;

    // Formatos comunes
    final formatos = ['dd/MM/yyyy HH:mm', 'dd-MM-yyyy HH:mm'];
    for (final f in formatos) {
      try {
        final dt = DateFormat(f).parseStrict(trimmed);
        // ignore: unnecessary_null_comparison
        if (dt != null) return dt;
      } catch (_) {
        // Intentar siguiente formato
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(MdiIcons.arrowLeft, color: Constants.text_color),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.transparent,
        title: const Text(
          'Agregar Evento',
          style: TextStyle(
              color: Constants.text_color,
              fontWeight: FontWeight.bold,
              fontSize: 25),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Constants.primary_color, Constants.secondary_color],
          )
        ),
        child: Center(
          child: Card(
            color: Constants.primary_color.withOpacity(0.8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Container(
              // reducir padding superior para acercar el contenido al borde
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Constants.secondary_color.withOpacity(0.8),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Form(
                key: formKey,
                child: ListView(
                  padding: EdgeInsets.zero, // quita el espacio superior extra
                  shrinkWrap: true, // evita que la lista expanda todo el espacio
                  children: [
                    TextFormField(
                      controller: tituloController,
                      style: TextStyle(color: Constants.text_color),
                      decoration: InputDecoration(
                        labelText: 'Título',
                        labelStyle: TextStyle(color: Constants.text_color),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Constants.text_color),
                        ),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 6),
                      ),
                      validator: (titulo) {
                        if (titulo == null || titulo.isEmpty) {
                          return 'Por favor ingresa un título';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: areaController,
                      style: TextStyle(color: Constants.text_color),
                      decoration: InputDecoration(
                        labelText: 'Área',
                        labelStyle: TextStyle(color: Constants.text_color),
                        
                      ),
                      validator: (area) {
                        if (area == null || area.isEmpty) {
                          return 'Por favor ingresa un área';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: lugarController,
                      style: TextStyle(color: Constants.text_color),
                      decoration: InputDecoration(
                        labelText: 'Lugar',
                        labelStyle: TextStyle(color: Constants.text_color),
                        
                      ),
                      validator: (lugar) {
                        if (lugar == null || lugar.isEmpty) {
                          return 'Por favor ingresa un lugar';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: fechaHoraController,
                      style: TextStyle(color: Constants.text_color),
                      decoration: InputDecoration(
                        labelText: 'Fecha y Hora',
                        labelStyle: TextStyle(color: Constants.text_color),
                        
                      ),
                      validator: (fechaHora) {
                        if (fechaHora == null || fechaHora.trim().isEmpty) {
                          return 'Por favor ingresa una fecha y hora';
                        }
                        final parsed = _parseFechaHora(fechaHora);
                        if (parsed != null) return null;
                        return 'Formato inválido. Ej: 01/01/2025 18:30';
                      },
                    ),
                    FutureBuilder(
                      future: FsService().categorias(), 
                      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
                          return Text('Cargando categorías...');
                        }
                        var categorias = snapshot.data!.docs;
                        return DropdownButtonFormField(
                          value: categoriaSeleccionada,
                          dropdownColor: Constants.secondary_color,
                          validator: (categoria) {
                            if (categoria == null || categoria.toString().isEmpty) {
                              return 'Por favor selecciona una categoría';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Categoría',
                            labelStyle: TextStyle(color: Constants.text_color),
                          ),
                          items: categorias.map((categoria) {
                            final nombre = categoria['nombre'] ?? 'Sin nombre';
                            return DropdownMenuItem(
                              value: categoria.id,
                              child: Text(
                                nombre,
                                style: TextStyle(color: Constants.text_color),
                              ),
                            );
                          }).toList(),
                          onChanged: (valor) {
                            categoriaSeleccionada = valor;
                          },
                        );
                      }
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Constants.input_cancel_color,
                      ),
                      child: Text('Cancelar', style: TextStyle(color: Constants.text_color)),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          // Procesar datos
                          final titulo = tituloController.text.trim();
                          final lugar = lugarController.text.trim();
                          final fechaHoraStr = fechaHoraController.text.trim();
                          final categoriaId = categoriaSeleccionada ?? 'charla';
                          
                          // Usar la función de parseo de fecha
                          final fechaHora = _parseFechaHora(fechaHoraStr);
                          
                          if (fechaHora != null) {
                            FsService().agregarEvento(
                              titulo,
                              lugar,
                              fechaHora,
                              categoriaId,
                            ).then((_) {
                              Navigator.pop(context);
                            });
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Constants.input_accept_color,
                      ),
                      child: Text('Agregar', style: TextStyle(color: Constants.text_color)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}