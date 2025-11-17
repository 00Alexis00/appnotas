import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class Screen extends StatelessWidget {
  const Screen ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Center(child: Text('Notas', style: TextStyle(color: Colors.white, fontSize: 25.sp, fontWeight: FontWeight.bold),)),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              ElevatedButton(onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: Text('Button'))
            ],
          )
      ),
    )
  );
  }
}