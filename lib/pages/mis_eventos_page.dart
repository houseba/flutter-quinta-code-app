import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quinta_code/constants.dart';
import 'package:quinta_code/services/fs_service.dart';
import 'package:quinta_code/utils/app_utils.dart';

class MisEventosPage extends StatefulWidget {
  const MisEventosPage({super.key});

  @override
  State<MisEventosPage> createState() => _MisEventosPageState();
}

class _MisEventosPageState extends State<MisEventosPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        actions: [
          PopupMenuButton(
            icon: Icon(MdiIcons.accountCircle, color: Constants.text_color),
            itemBuilder: (context) => [
              PopupMenuItem(value: 'logout', child: Text('Cerrar sesión')),
            ],
            onSelected: (value) => FirebaseAuth.instance.signOut(),
          )
        ],
        backgroundColor: Colors.transparent,
        title: const Text(
          'Mis eventos',
          style: TextStyle(
              color: Constants.text_color,
              fontWeight: FontWeight.bold,
              fontSize: 25),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Constants.primary_color, Constants.secondary_color],
          ),
        ),
        child: Center(
          child: FutureBuilder<Map<String, String>>(
            future: FsService().categoriasMap(),
            builder: (context, asyncSnapshot) {
              if (!asyncSnapshot.hasData) {
                return CircularProgressIndicator(color: Constants.accent_color);
              }
              final catAssets = asyncSnapshot.data!;
              return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FsService().misEventos(FirebaseAuth.instance.currentUser?.email),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator(color: Constants.accent_color);
                  }
                  final docs = snapshot.data!.docs;
                  if (docs.isEmpty) {
                    return Center(
                      child: Text('No tienes eventos aún', style: TextStyle(color: Constants.text_color)),
                    );
                  }
                  return ListView.builder(
                    // Evitar que se sobreponga con el AppBar
                    padding: EdgeInsets.fromLTRB(10, MediaQuery.of(context).padding.top + 10, 10, 10),
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final doc = docs[index];
                      final data = doc.data();

                      final catId = (data['categoriaId'] ?? 'charla').toString();
                      final bgAsset = catAssets[catId] ?? 'assets/images/categorias/coloquio.png';

                      final titulo = data['titulo'] ?? 'Sin título';
                      final autor = data['autor'] ?? 'Sin autor';
                      final lugar = data['lugar'] ?? 'Sin lugar';
                      final area = data['area'] ?? 'Sin área';

                      final fechaVal = data['fechaHora'];
                      final fechaStr = (fechaVal is Timestamp)
                          ? DateFormat('dd/MM/yyyy HH:mm').format(fechaVal.toDate())
                          : (fechaVal is DateTime)
                          ? DateFormat('dd/MM/yyyy HH:mm').format(fechaVal)
                          : (fechaVal?.toString() ?? 'Sin fecha');

                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(bottom: 5),
                                  height: 300,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    image: DecorationImage(image: AssetImage(bgAsset), fit: BoxFit.cover),
                                  ),
                                  child: Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Color(0xAA333333)),
                                      ),
                                      Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              titulo,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(color: Constants.accent_color, fontWeight: FontWeight.bold, fontSize: 30),
                                            ),
                                            SizedBox(height: 15),
                                            Text(
                                              'Por $autor',
                                              style: TextStyle(color: Constants.text_color, fontSize: 25, fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(height: 10),
                                            Text('Lugar: $lugar', style: TextStyle(color: Constants.text_color, fontSize: 20)),
                                            SizedBox(height: 5),
                                            Text('Área: $area', style: TextStyle(color: Constants.text_color, fontSize: 20)),
                                            Text('Fecha y hora: $fechaStr', style: TextStyle(color: Constants.text_color, fontSize: 20)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size(double.infinity, 36),
                                    backgroundColor: Constants.input_cancel_color,
                                  ),
                                  onPressed: () async {
                                    bool confirmado = await AppUtils.mostrarConfirmacion(
                                      context,
                                      'Confirmar eliminación',
                                      '¿Estás seguro de que deseas eliminar este evento?',
                                    );
                                    if (confirmado) {
                                      // Lógica para eliminar el evento
                                    }
                                  },
                                  child: Text('Eliminar evento', style: TextStyle(color: Constants.accent_color)),
                                ),
                              ],
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(top: 5)),
                        ],
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}