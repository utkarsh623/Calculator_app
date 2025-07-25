import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Rounded_Button extends StatelessWidget{
  final String btn_name;
  final Icon ? icon ;
  final Color ? bgcolor;
  final TextStyle ? textstyle;
  final VoidCallback ? callback;


  @override
  Widget build(BuildContext context) {
  return ElevatedButton(
      onPressed: (){
        callback!();
      },
      child: icon!=null? Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon!,
          Container(
            width: 12,
          ),
          Text(btn_name, style: textstyle,)
        ],
      ) : Text(btn_name, style: textstyle,),
      style: ElevatedButton.styleFrom(
        backgroundColor:bgcolor,
        shadowColor: bgcolor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))
        )
  )
  );
    throw UnimplementedError();
  }

  const Rounded_Button({
    super.key,
    required this.btn_name,
    this.icon,
    this.bgcolor=Colors.blue,
    this.textstyle,
    this.callback
  }
  );
}