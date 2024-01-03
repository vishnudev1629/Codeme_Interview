
import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:interviewtask/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'list_screen.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {
  String? username, password;
  bool processing=false;
  final GlobalKey<FormState>_formkey = GlobalKey<FormState>();
  @override
  void initState(){
    super.initState();
    _loadCounter();
  }
  void _loadCounter()async{
    final prefs = await SharedPreferences.getInstance();
    bool? isLoggedIn = prefs.getBool('isLoggedIn')??false;
    log("isLoggedIn =" + isLoggedIn.toString());
    if(isLoggedIn){
      Navigator.push(context, MaterialPageRoute(builder: (context){
        return ListScreen();
      }));
    }
  }
  login(String username,String password)async {
    print('webservice');
    print(username);
    print(password);
    var result;
    final Map<String, dynamic>loginData = {
      'username': username,
      'password': password,
    };
    final response = await http.post(
      Uri.parse('https://crm-beta-api.vozlead.in/api/v2/account/login/'),
      body: loginData,
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      if (response.body.contains("success")) {
        log("login successfully completed");
        final prefs = await SharedPreferences.getInstance();
        prefs.setBool("isLoggedIn", true);
        prefs.setString("username", username.toString());
        Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return ListScreen();
            }));
      } else {
        log("login failed");
      }
    } else {
      result = {log(json.decode(response.body)['error'].toString())};
    }
    return result;
  }
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              Stack(
                children: [
                 Container(
                  height: MediaQuery.of(context).size.width *0.8,
                 width: MediaQuery.of(context).size.width,
                 // color: Colors.yellow,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(200)),
                    // color: Colors.yellow
                  image: DecorationImage(
                    image: NetworkImage(
                       'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTviDClq8NP98N0umq-gITko3T7NMkS0ECqJgJ_-BFKETaNmsuBHeRwg5BMjmWN47lrtaA&usqp=CAU'
                    ),
                    fit: BoxFit.fill,
                  ),
                ),
                 )
        ]
              ),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.only(right: 250.0),
                child: Text("Sign In",textAlign:TextAlign.start, style: TextStyle(
                  color: Colors.blue.shade900,
                  fontSize: 28,fontWeight: FontWeight.bold,

                ),),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text("Welcome back ! Please enter your credentials to login",
                  textAlign: TextAlign.center,),
              ),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.only(left: 20.0,right: 20,bottom: 10),
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Color(0xffE8E8E8),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: TextFormField(
                        style: TextStyle(
                          fontSize: 15,
                        ),
                        decoration: InputDecoration.collapsed(
                            hintText: 'Username'
                        ),
                        onChanged:(text){
                          setState(() {
                            username=text;
                          });
                        },
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Enter your username text';
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 20.0,right: 20),
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Color(0xffE8E8E8),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: TextFormField(
                        obscureText: true,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                        decoration: InputDecoration.collapsed(
                            hintText: 'password'
                        ),
                        onChanged:(text){
                          setState(() {
                            password=text;
                          });
                        },
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Enter your password';
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.only(left: 200.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Forgot your",
                      style: TextStyle(fontSize: 13),),
                    GestureDetector(
                      onTap: (){

                      },
                      child: Text(
                        "Password?",
                        style: TextStyle(fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade900),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 25),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: TextButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)
                    ),
                    primary: Colors.white,
                    backgroundColor: maincolor,
                  ),
                  onPressed: (){
                    if(_formkey.currentState!.validate()){
                      login(username.toString(), password.toString());
                    }
                  }, child: Text(
                  "Sign In",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                ),
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?",
                    style: TextStyle(fontSize: 16),),
                  GestureDetector(
                    onTap: (){

                    },
                    child: Text(
                      "Sign Up",
                      style: TextStyle(fontSize: 16,
                          fontWeight: FontWeight.bold,
                      color: Colors.blue.shade900),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
