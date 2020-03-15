import 'dart:math';
import 'package:flutter/material.dart';
import '../providers/auth.dart';
import 'package:provider/provider.dart';
import '../models/http_exception.dart';
import '../enums/connectivity_status.dart';
import '../widgets/offline_auth_widget.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = 'auth_screen';

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();
    final deviceSize = MediaQuery.of(context).size;
    final connectionStatus = Provider.of<ConnectivityStatus>(context);

    return (connectionStatus == ConnectivityStatus.Offline)
        ? OfflineAuthWidget()
        : Scaffold(
            body: SafeArea(
              child: Stack(
                children: <Widget>[
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
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Container(
                      height: deviceSize.height,
                      width: deviceSize.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Flexible(
                            child: Container(
                              margin: EdgeInsets.only(bottom: 20.0),
                              padding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 94.0),
                              // TODO: understand .. key
                              transform: Matrix4.rotationZ(-8 * pi / 180)
                                ..translate(-10.0),
                              // ..translate(-10.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.deepOrange.shade900,
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 8,
                                    color: Colors.black26,
                                    offset: Offset(0, 10),
                                  ),
                                ],
                              ),

                              child: Text(
                                'G-Shop',
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .accentTextTheme
                                      .title
                                      .color,
                                  fontSize: 50,
                                  fontFamily: 'Anton',
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            flex: deviceSize.width > 600 ? 2 : 1,
                            child: AuthCard(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();
  var _obscurePassword = true;

  AnimationController _animationController;
  Animation<Offset> _slideAnimation;
  Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    _slideAnimation = Tween<Offset>(begin: Offset(0, -1.0), end: Offset(0, 0))
        .animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));
    // TODO: use AnimatedBuilder instead

    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

//    _heightAnimation.addListener(() {
//      setState(() {});
//    });
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('An error occurred'),
              content: Text('Reason: $message'),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Text('Ok'))
              ],
            ));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      print('failed here !!');
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _obscurePassword = true;
      _isLoading = true;
    });

    try {
      if (_authMode == AuthMode.Login) {
        await Provider.of<Auth>(context, listen: false).login(
          _authData['email'],
          _authData['password'],
        );
      } else {
        await Provider.of<Auth>(context, listen: false).signup(
          _authData['email'],
          _authData['password'],
        );
      }
    } on HttpException catch (error) {
      final errorMessage = error.toString();
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage =
          'Could not authenticate you right now, please try again !';
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
      _animationController.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      _animationController.reverse();
    }
  }

  void _togglePasswordVisible() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 10.0,
      // TODO: AnimatedBuilder => only build for height container, not for child, use animation more efficient
      // TODO: don't need use addListener
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.linear,
        height: _authMode == AuthMode.Signup ? 320 : 260,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 320 : 260),
        width: deviceSize.width * 0.80,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'e-mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@')) {
                      return 'Invalid email!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value;
                  },
                ),
                Stack(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: _obscurePassword,
                      controller: _passwordController,
                      validator: (value) {
                        if (value.isEmpty || value.length < 5) {
                          return 'Password is too short!';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _authData['password'] = value;
                      },
                    ),
                    Positioned(
                      top: 5,
                      right: 0,
                      child: FlatButton(
                          splashColor: Colors.white,
                          highlightColor: Colors.white,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          onPressed: _togglePasswordVisible,
                          child: _obscurePassword
                              ? Icon(
                                  Icons.remove_red_eye,
                                  color: Colors.grey,
                                )
                              : Text(
                                  'Hide',
                                  style: TextStyle(color: Colors.grey),
                                )),
                    ),
                  ],
                ),
                if (_authMode == AuthMode.Signup)
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                    constraints: BoxConstraints(
                      minHeight: _authMode == AuthMode.Signup ? 60 : 0,
                      maxHeight: _authMode == AuthMode.Signup ? 120 : 0,
                    ),
                    child: FadeTransition(
                      opacity: _opacityAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: TextFormField(
                            enabled: _authMode == AuthMode.Signup,
                            decoration:
                                InputDecoration(labelText: 'Confirm Password'),
                            obscureText: true,
                            validator: (value) {
                              if (value != _passwordController.text) {
                                return 'Passwords do not match!';
                              }
                              return null;
                            }),
                      ),
                    ),
                  ),
                SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  RaisedButton(
                    elevation: 5,
                    child:
                        Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
                    onPressed: () {
                      print('submit');
                      _submit();
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).primaryTextTheme.button.color,
                  ),
                FlatButton(
                  child: Text(
                      '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                  onPressed: _switchAuthMode,
                  padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
