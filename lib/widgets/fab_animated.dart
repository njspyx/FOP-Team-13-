import 'package:flutter/material.dart';

/*
Animated FAB tutorial at:
https://medium.com/@agungsurya/create-a-simple-animated-floatingactionbutton-in-flutter-2d24f37cfbcc
*/

class FabAnimated extends StatefulWidget {
  FabAnimated({Key key, this.cameraClicked, this.uploadClicked})
      : super(key: key);
  Function() cameraClicked;
  Function() uploadClicked;

  @override
  _FabAnimatedState createState() => _FabAnimatedState();
}

class _FabAnimatedState extends State<FabAnimated>
    with SingleTickerProviderStateMixin {
  bool isMenuOpen = false;
  AnimationController _animationController;
  Animation<Color> _animationColor;
  Animation<double> _animationIcon;
  Animation<double> _translateButton;
  double _height = 56.0;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() {
            setState(() {});
          });

    _animationIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animationColor = ColorTween(
      begin: Colors.blue,
      end: Colors.red,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.00,
        1.00,
        curve: Curves.linear,
      ),
    ));

    _translateButton = Tween<double>(
      begin: _height,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.0, 0.75, curve: Curves.easeOut),
    ));

    super.initState();
  }

  _animate() {
    if (!isMenuOpen) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isMenuOpen = !isMenuOpen;
  }

  Widget cameraButton() {
    return new Container(
      child: FloatingActionButton(
        onPressed: () {
          widget.cameraClicked();
          _animate();
        },
        tooltip: 'Take a picture',
        child: Icon(Icons.camera),
      ),
    );
  }

  Widget uploadButton() {
    return new Container(
      child: FloatingActionButton(
        onPressed: () {
          widget.uploadClicked();
          _animate();
        },
        tooltip: 'Upload a picture',
        child: Icon(Icons.file_upload),
      ),
    );
  }

  Widget toggle() {
    return Container(
      child: FloatingActionButton(
        onPressed: _animate,
        backgroundColor: _animationColor.value,
        child: AnimatedIcon(
          icon: AnimatedIcons.menu_close,
          progress: _animationIcon,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 2.0,
            0.0,
          ),
          child: cameraButton(),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value,
            0.0,
          ),
          child: uploadButton(),
        ),
        toggle(),
      ],
    );
  }
}
