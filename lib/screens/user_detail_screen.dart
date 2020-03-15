import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../models/http_exception.dart';
import 'package:intl/intl.dart';
import '../widgets/avatar_input.dart';

class UserDetailScreen extends StatefulWidget {
  static const String routeName = 'user_detail_screen';

  @override
  _UserDetailScreenState createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _newPasswordController = TextEditingController();
  var _isNextButton = false;
  Map<String, String> _password = {
    'currentPassword': '',
    'newPassword': '',
  };
  var _isNewPassword = false;
  var _isNextLoading = false;

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

  Future<void> _next() async {
    if (!_formKey.currentState.validate()) {
      // Invalid
      print('failed ...');
      return;
    }
    setState(() {
      _isNextLoading = true;
    });
    _formKey.currentState.save();
    print(_password['currentPassword']);
    final authData = Provider.of<Auth>(context, listen: false);
    try {
      await authData.login(authData.email, _password['currentPassword']);
      _isNewPassword = true;
    } on HttpException catch (error) {
      final errorMessage = error.toString();
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage =
          'Could not authenticate you right now, please try again !';
      _showErrorDialog(errorMessage);
    }
    setState(() {
      _isNextLoading = false;
      _newPasswordController.clear();
    });
  }

  Future<void> _apply() async {
    if (!_formKey.currentState.validate()) {
      // Invalid
      print('failed ...');
      return;
    }
    setState(() {
      _isNextLoading = true;
    });
    _formKey.currentState.save();
    print('New password: ${_password['currentPassword']}');
    final authData = Provider.of<Auth>(context, listen: false);
    try {
      await authData.changePassword(authData.email, _password['newPassword']);
      print('Changed password to : ${_password['newPassword']}');
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Password has changed'),
        behavior: SnackBarBehavior.floating,
      ));
    } on HttpException catch (error) {
      final errorMessage = error.toString();
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage =
          'Could not authenticate you right now, please try again !';
      _showErrorDialog(errorMessage);
    }
    setState(() {
      _isNextLoading = false;
      _isNewPassword = false;
      _newPasswordController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authData = Provider.of<Auth>(context, listen: false);
    print('UserDetailScreen() rebuild');
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('User Settings'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Card(
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Row(
                children: <Widget>[
                  AvatarInput(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        authData.email,
                        style: Theme.of(context).textTheme.title,
                      ),
                      Text(
                        'Last login: ${DateFormat('MMM d, yyyy').format(authData.loginDate)}',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.clip,
                      )
                    ],
                  )
                ],
              ),
            ),
            Card(
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Change Password',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            if (!_isNewPassword)
                              Column(
                                children: <Widget>[
                                  TextFormField(
                                    autovalidate: true,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                        labelText: 'Current Password'),
                                    validator: (value) {
                                      if (value.length < 6 &&
                                          value.length > 0) {
                                        Future.delayed(Duration.zero).then((_) {
                                          setState(() {
                                            _isNextButton = false;
                                          });
                                        });
                                        return 'Password is too short!';
                                      }
                                      if (value.length >= 6) {
                                        Future.delayed(Duration.zero)
                                            .then((_) => {
                                                  setState(() {
                                                    _isNextButton = true;
                                                  })
                                                });
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      _password['currentPassword'] = value;
                                    },
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  _isNextLoading
                                      ? CircularProgressIndicator()
                                      : ActionButton(
                                          label: 'NEXT',
                                          onPressed: _isNextButton
                                              ? () {
                                                  _next();
                                                }
                                              : null,
                                        ),
                                ],
                              ),

                            // TODO: for newPass
                            if (_isNewPassword)
                              Column(
                                children: <Widget>[
                                  TextFormField(
                                    obscureText: true,
                                    controller: _newPasswordController,
                                    decoration: InputDecoration(
                                        labelText: 'New Password'),
                                    validator: (value) {
                                      if (value.isEmpty || value.length < 6) {
                                        return 'Password is too short!';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      _password['newPassword'] = value;
                                    },
                                  ),
                                  TextFormField(
                                    obscureText: true,
                                    decoration: InputDecoration(
                                        labelText: 'Confirm New Password'),
                                    validator: (value) {
                                      if (_newPasswordController.text !=
                                          value) {
                                        return 'Passwords do not match!';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  _isNextLoading
                                      ? CircularProgressIndicator()
                                      : ActionButton(
                                          label: 'APPLY',
                                          onPressed: () {
                                            _apply().then((_) {
                                              setState(() {
                                                _isNextButton = false;
                                              });
                                            });
                                          },
                                        ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      drawer: AppDrawer(),
    );
  }
}

class ActionButton extends StatelessWidget {
  final String label;
  final Function onPressed;
  ActionButton({this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RaisedButton(
          padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(label),
          textColor: Theme.of(context).primaryTextTheme.button.color,
          onPressed: onPressed),
    );
  }
}
