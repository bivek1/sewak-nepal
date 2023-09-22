import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
class MyNumber extends StatefulWidget {
  const MyNumber({super.key});
  @override
  State<MyNumber> createState() => _MyNumberState();
}

class _MyNumberState extends State<MyNumber> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade100,
      body: 
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
               
                
                SizedBox(height: 8),
                Text("Add Number and Address", style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20.00, right: 20.00, top: 20.00),
                  child: TextField(
                    decoration: InputDecoration(
                      fillColor: Colors.grey.shade100,
                      filled:true,
                      hintText: 'Number',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))
                    ),
                  ),
                ),
                Container(
                    padding: EdgeInsets.only(left: 20.00, right: 20.00, top: 20.00),
                    child: TextField(
                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled:true,
                        hintText: 'Address',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))
                      ),
                    ),
                  ),
        
                Padding(
                  padding: EdgeInsets.all(15.00),
                  child: Row(
                    
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                
                    TextButton(
                    onPressed: () {},  
                    child: 
                      Text('Next', style: TextStyle(
                          color: Colors.black87,
                          fontSize: 20,
                          fontWeight: FontWeight.w400
                      ),
                      ),
                      ),
                      CircleAvatar(
                       radius: 30,
                       backgroundColor: Colors.blueAccent, 
                       child: IconButton(
                        color: Colors.white,
                        onPressed: () {
                          Navigator.pushNamed(context, 'dashboard');
                        },
                        icon: Icon(Icons.arrow_forward
                        ),
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(20.00),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: (){
                          Navigator.pushNamed(context, 'home');
                        },
                        child: Text('Goto Login', style: TextStyle(
                          fontSize: 15,
                          color: Colors.amber
                        ),), 
                      
                      ),
                    
                    ]
                  ),
                )
                
              ],
            ),
          )
    );
  }
}