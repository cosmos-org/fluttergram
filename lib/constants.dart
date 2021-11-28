import 'package:flutter/material.dart';

const primaryColor = Color(0xFF1565C0);
const secondaryColor = Colors.white;
const pressedColor = Color(0xFF0D47A1);
const warningColor = Colors.deepOrange;
const errorColor = Colors.red;

const defaultPadding = 20.0;

const usernameFontSize = 20.0;
const postContentFontSize = 16.0;
const lightFontWeight = FontWeight.w200;
const normalFontWeight = FontWeight.normal;
const boldFontWeight = FontWeight.bold;


const hostname = "http://localhost:8000";
//API For Users
const userSignUpEndpoint = "/api/v1/users/register/";
const userLogInEndpoint = "/api/v1/users/login/";
const userGetInforEndpoint = "/api/v1/users/show";

//API For Friend
const friendGetListEndpoint = "/api/v1/friends/list";

//API For Post
const postGetListEndpoint = "/api/v1/posts/list";