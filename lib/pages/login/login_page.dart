import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:quinta_code/constants.dart';
import 'package:quinta_code/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Iniciar sesión', 
        style: TextStyle(
          color: Constants.text_color,
          fontWeight: FontWeight.bold,
          fontSize: 25),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Constants.primary_color,
              Constants.secondary_color,
            ],
          )
        ),
        child: Center(
          child: SizedBox(
            width: double.infinity,
            height: 400,
            child: Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Constants.accent_color,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage(
                        'assets/images/icons/icon_adaptative.png',
                      ), 
                      fit: BoxFit.contain,
                      width: 150,
                      height: 150,
                    ),
                    const SizedBox(height: 20,),
                    ElevatedButton.icon(
                      onPressed: () {
                        authService.handleSignIn();
                      }, 
                      icon: Icon(
                        MdiIcons.google,
                        color: Constants.text_color,
                        size: 30,
                        fontWeight: FontWeight.bold,
                      ),
                      label: const Text(
                        'Iniciar sesión con Google',
                        style: TextStyle(
                          color: Constants.text_color,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Constants.button_color,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        )
      ),
      
    );
  }
}