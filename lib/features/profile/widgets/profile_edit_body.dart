import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/Utils/app_images.dart';

class ProfileEditBody extends StatefulWidget{
  _ProfileEditBody createState()=>_ProfileEditBody();
}


class _ProfileEditBody extends State<ProfileEditBody>with SingleTickerProviderStateMixin{
  late TabController _tabController ;
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController=TabController(length: 2, vsync: this);
  }
  @override
  Widget build(BuildContext context) {
    final double screenHight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppImages.momen), // Replace with your image path
                fit: BoxFit.cover,
              ),
            ),
          ),
          Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              title: Text("Momen Mohamed",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
              actions: [
                IconButton(onPressed: (){}, icon: Icon(Icons.edit_calendar))
              ],
            ),
            backgroundColor: Colors.transparent,
            body: ListView(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 220.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(26),
                      color: Colors.white
                    ),
                  ),
                ),
                Row(
                  children: [
                    Column(
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage(AppImages.momen,),
                          radius: 60,
                        ),
                        Text("Momen Mohamed",style: TextStyle(color: Colors.white),),
                        Row(children: [Icon(Icons.male,color: Colors.white,),Text("22",style: TextStyle(color: Colors.white),)
                        ],),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text("ID: 5689sj",style: TextStyle(color: Colors.white),),
                              SizedBox(width: 6,),
                              Text("|",style: TextStyle(color: Colors.white)),
                              SizedBox(width: 6,),
                              Text("مصر",style: TextStyle(color: Colors.white),),
                              SizedBox(width: 6,),
                              Text("|",style: TextStyle(color: Colors.white)),
                              SizedBox(width: 6,),
                              Text("المشجعون",style: TextStyle(color: Colors.white),).tr(args: ['المشجعون']),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 28.0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(height: 12,),
                        ListTile(
                          title: Text("جينس").tr(args: ['جينس']),
                          trailing: IconButton(onPressed: (){}, icon: Icon(Icons.arrow_forward_ios_rounded,size: 12,)),
                        ),
                        SizedBox(height: 12,),
                        ListTile(
                          title: Text("الشارات",style: TextStyle(fontSize: 18,color: Colors.black),).tr(args: ['الشارات']),
                          subtitle: Text("لا توجد اي شارات").tr(args: ['لا توجد اي شارات']),
                          trailing: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("رؤية المزيد").tr(args: ['رؤية المزيد']),
                              IconButton(onPressed: (){}, icon: Icon(Icons.arrow_forward_ios_rounded,size: 12,)),
                            ],
                          ),
                        ),
                        SizedBox(height: 12,),
                        ListTile(
                          title: Text("السيارات").tr(args: ['السيارات']),
                          trailing: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("ادارة").tr(args: ['ادارة']),
                              IconButton(onPressed: (){}, icon: Icon(Icons.arrow_forward_ios_rounded,size: 12,)),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: IconButton(onPressed: (){}, icon: Icon(Icons.add,size: 12,)),
                                  radius: 30,
                                ),
                                Text("يشتري",style: TextStyle(color: Colors.greenAccent),).tr(args: ['يشتري'])
                              ],
                            ),
                            SizedBox(width: 30,),
                            Text("لا توجد سيارات").tr(args: ['لا توجد سيارات'])
                          ],
                        ),
                        SizedBox(height: 19,),
                        ListTile(
                          title: Text("هدية").tr(args: ['هدية']),
                          subtitle: Text("لا توجد هدايا متاحة حاليا").tr(args: ['لا توجد هدايا متاحة حاليا']),
                        ),
                        SizedBox(height: 12,),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(children: [Text("معلومة عني").tr(args: ['معلومة عني'])],),
                        ),
                        SizedBox(height: 12,),
                        ListTile(
                          title: Text("انقر لاضافة بطاقة").tr(args: ['انقر لاضافة بطاقة']),
                          subtitle: Text("دع الاخرين يعرفون من تكون").tr(args: ['دع الاخرين يعرفون من تكون']),
                          leading: Icon(Icons.info_outline),
                          trailing: IconButton(onPressed: (){}, icon: Icon(Icons.arrow_forward_ios_rounded,size: 12,)),
                        ),
                      ],
                    )
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

}