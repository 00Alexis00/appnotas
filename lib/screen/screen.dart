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
      body: Stack(
        children: [
          SizedBox(
            height: 100.h,
            width: 100.w,
            child: Image.asset('assets/imagenes/fondo-1.webp'),
          ),
          SafeArea(child: SingleChildScrollView(
            child: Center(child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(200),
                      ),
                      margin: EdgeInsets.only(top: 5.h),
                      padding: EdgeInsets.all(3.w),
                      height: 30.w,
                      width: 30.w,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(200),
                        child: Image.asset(
                          'assets/imagenes/logo-nota.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                )
              ],
            ),),
          ),)
        ],
    )
  );
  }
}