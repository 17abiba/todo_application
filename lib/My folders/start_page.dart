import 'package:flutter/material.dart';
import 'package:todo_app/My%20folders/home_page.dart';

Color customColor1 = const Color(0XFFF2F3E7);
Color customColor2 = const Color(0XFF4C4646);
Color customColor3 = const Color(0XFFFF7F00);
Color customColor4 = const Color(0XFF005F6A);

class StartPage extends StatelessWidget {
  const StartPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
             Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: customColor4
          ),
          child: Text('Start',style: TextStyle(color:customColor1))
        ),
      ),

    );
  }
}
