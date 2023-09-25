
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/http_exception.dart';
import 'package:shop_app/providers/auth.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [
                Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0, 1],
            )),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                      child: Container(
                    margin: EdgeInsets.only(bottom: 20),
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 94),
                    transform: Matrix4.rotationZ(-8 * pi / 180),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepOrange.shade900,
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 8,
                              color: Colors.black26,
                              offset: Offset(0, 2))
                        ]),
                    child: Text(
                      'My Shop',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 50,
                          fontFamily: 'Anton'),
                    ),
                  )),
                  Flexible(
                    child: AuthCard(),
                    flex: deviceSize.width > 600 ? 2 : 1,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({super.key});

  @override
  State<AuthCard> createState() => _AuthCardState();
}

enum AuthMode { Login, SignUp }

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();

  Map<String, String> _authData = {'email': '', 'password': ''};

  var _isLoading = false;
  final _passwordController = TextEditingController();
  AuthMode _authMode = AuthMode.Login;

  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, -0.15),
      end: Offset(0, 0),
    ).animate(
        CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn));

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }
Future<void> _submit() async{
  if(!_formKey.currentState!.validate()) {
    return ;
  }
  FocusScope.of(context).unfocus();
  _formKey.currentState!.save();
  setState(() {
    _isLoading = true ;
  });
  try {
    if (_authMode == AuthMode.Login) {
      await Provider.of<Auth>(context , listen: false).login(_authData['email']!, _authData['password']!);
    }
    else {
            await Provider.of<Auth>(context , listen: false).signUp(_authData['email']!, _authData['password']!);

    }

  }on HttpException catch (error) {
    var errorMessage ='Authentication failed';
    if (error.toString().contains('EMAIL_EXIST')){
      errorMessage = 'This email address is alreadt in use.';
    }else if (error.toString().contains('EMAIL_EXIST')){
      errorMessage = 'This email address is alreadt in use.';
    }
    else if (error.toString().contains('INVALID_EMAIL')){
      errorMessage = 'This is not a valid email address.';
    }
    else if (error.toString().contains('WEAK_PASSWORD')){
      errorMessage = 'This password is too weak.';
    }
    else if (error.toString().contains('EMAIL_NOT_FOUND')){
      errorMessage = 'Could not find a user with that email.';
    }
    else if (error.toString().contains('INVALID_PASSWORD')){
      errorMessage = 'Invalid password.';
    }
    _showErrorDialog(errorMessage);
    }
  
  catch(error) {
    const errorMessage = 'Could not authenticate you. Please try agian later.';
    _showErrorDialog(errorMessage);

  }
  setState(() {
    _isLoading = false;
  });

}
void _showErrorDialog(String message) {
  showDialog(context: context,
  builder: ((ctx) => AlertDialog(
    title: Text('An Error Occurred!'),
    content: Text(message),

    actions: [
      TextButton(onPressed: () => Navigator.of(ctx).pop(), child: Text('okay!'))
    ],
  )
  )
  );
}

void _switchAuthMode () {
  if (_authMode == AuthMode.Login) {
    setState(() {
      _authMode =AuthMode.SignUp;
    });
    _controller.forward();
  }
  else{
    setState(() {
      _authMode = AuthMode.Login;
    });
    _controller.reverse();
  }
}


  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 8.0,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
        height: _authMode == AuthMode.SignUp ? 320 : 260,
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) {
                    if (val!.isEmpty || !val.contains('@')) {
                      return 'Invalid email';
                    }
                    return null;
                  },
                  onSaved: (val) {
                    _authData['email'] = val!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (val) {
                    if (val!.isEmpty || val.length < 5) {
                      return 'password too short!';
                    }
                    return null;
                  },
                  onSaved: (val) {
                    _authData['password'] = val!;
                  },
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                  constraints: BoxConstraints(
                    minHeight: _authMode == AuthMode.SignUp ? 60 : 0,
                    maxHeight: _authMode == AuthMode.SignUp ? 120 : 0,
                  ),
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(labelText: 'Confirm Password'),
                        validator: _authMode == AuthMode.SignUp ?(val) {
                          if (val != _passwordController.text) {
                            return 'Password do not match';
                          }
                          return null;
                        }: null,
                      ),
                    ),
                  ),
                ),

              SizedBox(height: 20,),
              if(_isLoading == true)  CircularProgressIndicator()
              else
              ElevatedButton(
                style: ButtonStyle(
                  textStyle: MaterialStatePropertyAll(TextStyle(color: Colors.white)),
                  backgroundColor: MaterialStatePropertyAll(Theme.of(context).colorScheme.primary),
                  padding: MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 8 , horizontal: 30)),
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)
                    ),
                    ),
                
                ),
                onPressed: _submit, 
                child: Text( _authMode == AuthMode.Login ? 'LOGIN' : 'SIGNUP'  ,),
              
              ),
              TextButton(
                style: ButtonStyle(
                  textStyle: MaterialStatePropertyAll(TextStyle(color: Theme.of(context).colorScheme.primary)),
                  padding: MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 8 , horizontal: 30)),
                ),
                onPressed: _switchAuthMode, 
                child: 
              Text('${_authMode == AuthMode.Login ? 'LOGIN' : 'SIGNUP'} INSTEAD'),
              ),
              
              
              
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  
}
