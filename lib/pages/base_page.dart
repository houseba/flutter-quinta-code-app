import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:quinta_code/constants.dart';
import 'package:quinta_code/pages/home_page.dart';
import 'package:quinta_code/pages/mis_eventos_page.dart';

class BasePage extends StatefulWidget {
  const BasePage({super.key});

  @override
  State<BasePage> createState() => _BasePageState();
}
class _BasePageState extends State<BasePage> {
  int _paginaSeleccionada = 0;
  final List<Widget> _paginas = [HomePage(), MisEventosPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 0), 
        child: IndexedStack(
          index: _paginaSeleccionada,
          children: _paginas,
        ),
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: Colors.transparent,
          backgroundColor: Colors.transparent, // <-- fondo transparente
          labelTextStyle: WidgetStateProperty.all(
            TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          iconTheme: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
              return IconThemeData(color: Colors.white, size: 25);
            }
            return IconThemeData(color: Colors.grey, size: 25);
          }),
        ),
        child: NavigationBar(
          backgroundColor: Constants.background_color,
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Eventos',
            ),
            NavigationDestination(
              icon: Icon(MdiIcons.accountMultipleOutline),
              selectedIcon: Icon(MdiIcons.accountMultiple),
              label: 'Mis eventos',
            ),
          ],
          selectedIndex: _paginaSeleccionada,
          onDestinationSelected: (index) {
            setState(() {
              _paginaSeleccionada = index;
            });
          },
        ),
      ),
    );
  }
}