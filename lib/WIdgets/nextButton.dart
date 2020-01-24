import 'package:flutter/material.dart';

class RedButton extends StatelessWidget {
  final double screenWidth;
  final String title;
  final Function onTap;
  const RedButton({Key key, this.screenWidth, this.title, this.onTap}):assert(
  screenWidth!=null,
  title!=null,
  //onTap!=null
  ) , super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: screenWidth,
        height: 50,
        color: Theme.of(context).primaryColor,
        child: Center(
          child: Text(title),
        ),
      ),
    );
  }
}
