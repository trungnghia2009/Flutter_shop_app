import 'package:flutter/material.dart';
import '../helpers/path.dart';
import 'package:provider/provider.dart';
import '../providers/avatar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:io';

class AvatarInput extends StatefulWidget {
  @override
  _AvatarInputState createState() => _AvatarInputState();
}

class _AvatarInputState extends State<AvatarInput> {
  var _isLoading = false;

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
                    builder: (ctx, avatar, child) => GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => DetailAvatar(
                                  imageUrl: avatar.avatarUrl,
                                  imageFile: avatar.imageFile,
                                )));
                      },
                      child: Hero(
                        tag: 'avatarImage',
                        child: SizedBox(
                          width: 100,
                          height: 100,
                          child: (avatar.imageFile == null &&
                                  avatar.avatarUrl == null)
                              ? Image.asset(Path.avatarImageDefault)
                              : ((avatar.imageFile != null)
                                  ? Image.file(avatar.imageFile,
                                      fit: BoxFit.cover)
                                  : Image.network(
                                      avatar.avatarUrl,
                                      fit: BoxFit.cover,
                                    )),
                        ),
                      ),
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

class DetailAvatar extends StatelessWidget {
  final String imageUrl;
  final File imageFile;
  DetailAvatar({this.imageUrl, this.imageFile});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'avatarImage',
            child: imageUrl == null
                ? Image.asset(Path.avatarImageDefault)
                : (imageFile != null
                    ? Image.file(imageFile)
                    : Image.network(
                        imageUrl,
                      )),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
