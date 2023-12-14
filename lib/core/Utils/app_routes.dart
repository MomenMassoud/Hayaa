import 'package:flutter/material.dart';
import 'package:hayaa_main/features/friend_list/widget/friend_requset.dart';
import 'package:hayaa_main/features/search/view/search_view.dart';
import 'package:hayaa_main/features/setting/views/setting_view.dart';
import '../../features/Badges/Badgespage.dart';
import '../../features/VIP/view/vip_view.dart';
import '../../features/auth/choice between registration and login/views/choice_between_registration_and_login_view.dart';
import '../../features/auth/choice between registration and login/views/privacy_terms_view.dart';
import '../../features/auth/choice between registration and login/views/user_agreement_view.dart';
import '../../features/auth/login/views/login_view.dart';
import '../../features/auth/login/views/password_recovery.dart';
import '../../features/auth/sinup/view/signup_view.dart';
import '../../features/chat/group/view/family_view.dart';
import '../../features/chat/one_to_one/view/chat_view.dart';
import '../../features/chat/widget/one_to_one/chat_setting.dart';
import '../../features/friend_list/view/friend_list_view.dart';
import '../../features/friend_list/view/visitor_view.dart';
import '../../features/games/views/games_view.dart';
import '../../features/history_recharge/view/history_recharge_view.dart';
import '../../features/home/views/all_rooms_view.dart';
import '../../features/home/views/home_view.dart';
import '../../features/messages/views/messages_view.dart';
import '../../features/profile/views/profile_edit_view.dart';
import '../../features/profile/views/profile_view.dart';
import '../../features/recharge_coins/views/recharge_view.dart';
import '../../features/salery/view/salery_view.dart';
import '../../features/splash/views/splash_view.dart';
import '../../features/store/ListViewStore.dart';
import '../../features/user_leve/FirstList.dart';


Map<String, Widget Function(BuildContext)> appRoutes = {
  SplashView.id: (context) => const SplashView(),
  ChoiceBetweenRegistrationAndLogin.id: (context) =>
      const ChoiceBetweenRegistrationAndLogin(),
  UserAgreementView.id: (context) => const UserAgreementView(),
  PrivacyTermsView.id: (context) => const PrivacyTermsView(),
  LoginView.id: (context) => const LoginView(),
  PasswordRecoveryView.id: (context) => const PasswordRecoveryView(),
  RechargeView.id:(context) => const RechargeView(),
  HistoryRechargeView.id:(context) => const HistoryRechargeView(),
  ChatView.id:(context) => const ChatView(),
  ChatSetting.id:(context) => ChatSetting(),
  FriendListView.id:(context) =>const FriendListView(),
  HomeView.id: (context) => const HomeView(),
  MessagesView.id: (context) => const MessagesView(),
  GamesView.id: (context) => const GamesView(),
  AllRoomsView.id: (context) => const AllRoomsView(),
  FamilyView.id: (context) => const FamilyView(),
  VisitorView.id:(context)=>const VisitorView(),
  ProfileEditView.id:(context)=>const ProfileEditView(),
  ListViewStore.id:(context)=>const ListViewStore(),
  VipView.id :(context)=>const VipView(),
  SaleryView.id:(context)=>const SaleryView(),
  Badges.id:(context)=>const Badges(),
  FirstList.id:(context)=>const FirstList(),
  SignupView.id:(context)=>const SignupView(),
  SettingView.id:(context)=> SettingView(),
  SearchView.id:(context)=>SearchView(),
  FriendReuest.id:(context)=>FriendReuest(),
};
