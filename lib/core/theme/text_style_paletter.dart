import 'package:flutter/material.dart'; // Reemplazado dart:ui

import 'package:uniride_driver/core/theme/color_paletter.dart';

class TextStylePaletter {
  //Estilo de texpo para titulos
  static final TextStyle title = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: ColorPaletter.textPrimary,
  );

  //Estilo de texto para subtitulos como indicar que dato 
  //es requerido en el input o opciones
  static final TextStyle subTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: ColorPaletter.textPrimary,
  );

  //Esilo para los parrafos de texto
  static final TextStyle body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: ColorPaletter.textPrimary,
  );

  //Estilo para el texto termino y condiciones
  static final TextStyle spam = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: ColorPaletter.textSecondary,
  );

  //Estilo para los textos dentro del input 
  static final TextStyle inputField = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: ColorPaletter.textinputField,
  );

  //Estilo para los textos del boton
  static final TextStyle button = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: ColorPaletter.buttonText,
  );

  //Estilo usado para seccion para ingresar codigo
  static final TextStyle subText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: ColorPaletter.subText,
  );

  //Estilo par los textos de los resultados de busqueda como horarios
  static final TextStyle textOptions = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: ColorPaletter.textPrimary,
  );
  //Estilo para los textos de las opciones de busqueda como horarios
  static final TextStyle subTextOptions = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: ColorPaletter.textPrimary,
  );


  //Estilos de texto para mensajes de error, exito y advertencia
  static final TextStyle error = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: ColorPaletter.error,
  );

  static final TextStyle success = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: ColorPaletter.success,
  );

  static final TextStyle warning = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: ColorPaletter.warning,
  );

  //Estilo para subtitulo de pantall de bienvenida
  static final TextStyle welcomeSubTitle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: ColorPaletter.textTertiary,
  );

}