import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hayaa_main/features/setting/views/setting_view.dart';
import '../../../core/Utils/app_colors.dart';
import '../../../core/Utils/app_images.dart';
import '../../Badges/Badgespage.dart';
import '../../VIP/view/vip_view.dart';
import '../../chat/group/view/family_view.dart';
import '../../friend_list/view/visitor_view.dart';
import '../../friend_list/widget/friend_list_body.dart';
import '../../recharge_coins/views/recharge_view.dart';
import '../../salery/view/salery_view.dart';
import '../../store/ListViewStore.dart';
import '../../user_leve/FirstList.dart';
import '../views/profile_edit_view.dart';

class ProfileViewBody extends StatelessWidget {
  const ProfileViewBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.appInformationColors100,
            AppColors.appInformationColors700
          ],
          begin: Alignment.topLeft,
          end: Alignment.topRight,
          stops: [0.0, 0.8],
          tileMode: TileMode.clamp,
        ),
      ),
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 90.0,bottom: 30),
            child: ListTile(
              title: Text("Momen Mohamed",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
              leading: CircleAvatar(
                  backgroundImage: AssetImage(AppImages.momen),
                radius: 30,
              ),
              subtitle: Text("ID:658ds99"),
              trailing: IconButton(onPressed: (){
                Navigator.pushNamed(context, ProfileEditView.id);
              }, icon: Icon(Icons.arrow_forward_ios_rounded,color: Colors.white,)),
            ),
          ),
          Container(
            color: Colors.white,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: (){
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => FriendListBody()));
                        },
                        child: Column(
                          children: [
                            Text("10",style: TextStyle(fontSize: 22,),),
                            Text("اصدقاء",style: TextStyle(fontSize: 22,)).tr(args: ['اصدقاء'])
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => FriendListBody()));
                        },
                        child: Column(
                          children: [
                            Text("10",style: TextStyle(fontSize: 22)),
                            Text("تمت المتابعة",style: TextStyle(fontSize: 22,)).tr(args: ['تمت المتابعة'])
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => FriendListBody()));
                        },
                        child: Column(
                          children: [
                            Text("10",style: TextStyle(fontSize: 22)),
                            Text("المعجبون",style: TextStyle(fontSize: 22)).tr(args: ['المعجبون'])
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          Navigator.pushNamed(context, VisitorView.id);
                        },
                        child: Column(
                          children: [
                            Text("10",style: TextStyle(fontSize: 22)),
                            Text("عدد الزوار",style: TextStyle(fontSize: 22)).tr(args: ['عدد الزوار'])
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text("اعادة الشحن").tr(args: ['اعادة الشحن']),
                    trailing: Icon(Icons.arrow_forward_ios_rounded,color: Colors.grey,size: 12,),
                    leading: Icon(Icons.wallet,color: Colors.yellow,),
                    onTap: (){
                      Navigator.pushNamed(context, RechargeView.id);
                    },
                  ),
                ),
                Divider(thickness: 0.2,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text("دخل").tr(args: ['دخل']),
                    trailing: Icon(Icons.arrow_forward_ios_rounded,color: Colors.grey,size: 12,),
                    leading: Icon(Icons.diamond_outlined,color: Colors.blue,),
                    onTap: (){
                      Navigator.pushNamed(context, SaleryView.id);
                    },
                  ),
                ),
                Divider(thickness: 0.2,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text("مستوي المستخدم").tr(args: ['مستوي المستخدم']),
                    trailing: Icon(Icons.arrow_forward_ios_rounded,color: Colors.grey,size: 12,),
                    leading: Icon(Icons.stars_sharp,color: Colors.purpleAccent,),
                    onTap: (){
                      Navigator.pushNamed(context, FirstList.id);
                    },
                  ),
                ),
                Divider(thickness: 0.2,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text("الوكالات").tr(args: ['الوكالات']),
                    trailing: Icon(Icons.arrow_forward_ios_rounded,color: Colors.grey,size: 12,),
                    leading: Icon(Icons.favorite,color: Colors.greenAccent,),
                  ),
                ),
                Divider(thickness: 0.2,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text("مركز VIP").tr(args: ['مركز VIP']),
                    trailing: Icon(Icons.arrow_forward_ios_rounded,color: Colors.grey,size: 12,),
                    leading: Icon(Icons.spa_outlined,color: Colors.brown,),
                    onTap: (){
                      Navigator.pushNamed(context, VipView.id);
                    },
                  ),
                ),
                Divider(thickness: 0.2,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text("الشارات").tr(args: ['الشارات']),
                    trailing: Icon(Icons.arrow_forward_ios_rounded,color: Colors.grey,size: 12,),
                    leading: Icon(Icons.badge,color: Colors.orange,),
                    onTap: (){
                      Navigator.pushNamed(context, Badges.id);
                    },
                  ),
                ),
                Divider(thickness: 0.2,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text("مركز تجاري").tr(args: ['مركز تجاري']),
                    trailing: Icon(Icons.arrow_forward_ios_rounded,color: Colors.grey,size: 12,),
                    leading: Icon(Icons.storefront_sharp,color: Colors.greenAccent,),
                    onTap: (){
                      Navigator.pushNamed(context, ListViewStore.id);
                    },
                  ),
                ),
                Divider(thickness: 0.2,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text("مظهري").tr(args: ['مظهري']),
                    trailing: Icon(Icons.arrow_forward_ios_rounded,color: Colors.grey,size: 12,),
                    leading: Icon(Icons.backpack,color: Colors.greenAccent,),
                  ),
                ),
                Divider(thickness: 0.2,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text("العائلة").tr(args: ['العائلة']),
                    trailing: Icon(Icons.arrow_forward_ios_rounded,color: Colors.grey,size: 12,),
                    leading: Icon(Icons.home_sharp,color: Colors.purple,),
                    onTap: (){
                      Navigator.pushNamed(context, FamilyView.id);
                    },
                  ),
                ),
                Divider(thickness: 0.2,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text("خدمة العملاء").tr(args: ['خدمة العملاء']),
                    trailing: Icon(Icons.arrow_forward_ios_rounded,color: Colors.grey,size: 12,),
                    leading: Icon(Icons.support_agent,color: Colors.grey,),
                  ),
                ),
                Divider(thickness: 0.2,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text("الاعدادات").tr(args: ['الاعدادات']),
                    trailing: Icon(Icons.arrow_forward_ios_rounded,color: Colors.grey,size: 12,),
                    leading: Icon(Icons.settings,color: Colors.grey,),
                    onTap: (){
                      Navigator.pushNamed(context, SettingView.id);
                    },
                  ),
                ),
                Divider(thickness: 0.2,),
              ],
            )
          )
        ],
      ),
    );
  }
}
