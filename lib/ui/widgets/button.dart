import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:todo_algoriza/ui/theme.dart';

class MyButton extends StatelessWidget {
  final String label ;
  final Function()? onTap;
  const MyButton({Key? key,required this.label,required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(

      onTap: onTap,
      child: Container(

        width: 120,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: primaryClr,
        ),
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(  textAlign: TextAlign.center,

            label,
            style: const TextStyle(

              fontSize: 20,
              color: Colors.white,
  ),
),
          ),
      ) ,
    );
  }
}
