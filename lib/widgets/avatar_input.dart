import 'package:flutter/material.dart';
import '../helpers/path.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/avatar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AvatarInput extends StatefulWidget {
  @override
  _AvatarInputState createState() => _AvatarInputState();
}

class _AvatarInputState extends State<AvatarInput> {
  var _isLoading = false;

//  @override
//  void initState() {
//    super.initState();
//    Provider.of<Avatar>(context, listen: false).fetchAvatarUrl();
//  }

  @override
  Widget build(BuildContext context) {
    final avatar = Provider.of<Avatar>(context);

    return Builder(
      builder: (context) => Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: <Widget>[
            Container(
              width: 100,
              height: 100,
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: Colors.grey,
                ),
              ),
              child: Stack(
                children: <Widget>[
                  Consumer<Avatar>(
                    builder: (ctx, avatar, child) => SizedBox(
                      width: 100,
                      height: 100,
                      child: (avatar.imageFile == null &&
                              avatar.avatarUrl == null)
                          ? Image.asset(Path.avatarImageDefault)
                          : ((avatar.imageFile != null)
                              ? Image.file(avatar.imageFile, fit: BoxFit.cover)
                              : Image.network(
                                  avatar.avatarUrl,
                                  fit: BoxFit.cover,
                                )),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: GestureDetector(
                      onTap: () async {
                        avatar.getImage();
                      },
                      child: Icon(
                        Icons.add_circle,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  )
                ],
              ),
            ),
            _isLoading
                ? SpinKitFadingCircle(
                    color: Theme.of(context).primaryColor,
                  )
                : RaisedButton(
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text('APPLY'),
                    textColor: Theme.of(context).primaryTextTheme.button.color,
                    onPressed: avatar.imageFile == null
                        ? null
                        : () {
                            setState(() {
                              _isLoading = true;
                            });
                            Provider.of<Avatar>(context, listen: false)
                                .uploadAvatar()
                                .then(
                                  (_) => Scaffold.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Avatar updated'),
                                    ),
                                  ),
                                )
                                .then((_) {
                              setState(() {
                                avatar.resetImageFile();
                                _isLoading = false;
                              });
                            });
                          },
                  )
          ],
        ),
      ),
    );
  }
}
