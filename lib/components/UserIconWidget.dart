import 'package:flutter/material.dart';

class UserIconWidget extends StatelessWidget{
  final bool isNetwork;
  final String image;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final EdgeInsetsGeometry padding;

  UserIconWidget({this.isNetwork, this.image, this.onPressed, this.width = 30.0, this.height = 30.0, this.padding});

  @override
  Widget build(BuildContext context) {
    return new RawMaterialButton(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ///? 用来进行null的判断，??用来进行赋值，表示当padding为null的时候 才赋值为后面的值，否则使用本身的值不用赋值
      padding: padding?? const EdgeInsets.only(top: 4.0, right: 5.0, left: 5.0),

      constraints: const BoxConstraints(minWidth: 0.0, minHeight: 0.0),
      child:
      new ClipRRect(
        borderRadius: new BorderRadius.all(
            new Radius.circular(5.0)),
        child: this.isNetwork ? new FadeInImage.assetNetwork(
          placeholder: 'static/images/default_nor_avatar.png',
          //预览图
          fit: BoxFit.fitWidth,
          image: image,
          width: width,
          height: height,
        ) : new Image.asset(
          image,
          fit: BoxFit.cover,
          width: width,
          height: height,
        ),
      ),
      onPressed: onPressed,
    );
  }

}