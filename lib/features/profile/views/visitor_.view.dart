import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/visitor_view_body.dart';

class VistorView extends StatefulWidget {
  String photo;
  String doc;
  VistorView(this.photo,this.doc);
  @override
  State<VistorView> createState() => _VistorViewState();
}

class _VistorViewState extends State<VistorView> {
  final ScrollController _scrollController = ScrollController();
  Color _appBarColor = Colors.transparent;
  Color icons = Colors.white;
  final FirebaseAuth _auth=FirebaseAuth.instance;
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    SetVistorDoc();
    _scrollController.addListener(() {
      if (_scrollController.offset > 0) {
        setState(() {
          _appBarColor = Colors.white;
          icons = Colors.black;
        });
      } else {
        setState(() {
          icons = Colors.white;
          _appBarColor = Colors.transparent;
        });
      }
    });
  }
  void SetVistorDoc()async{
    await _firestore.collection('user').doc(widget.doc).collection('visitor').doc(_auth.currentUser!.uid).set({
      'id':_auth.currentUser!.uid
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            child: CachedNetworkImage(imageUrl: widget.photo,fit: BoxFit.contain,width: 800,height: 420,)
          ),
          VisitorViewBody(
            appBarColor: _appBarColor,
            controller: _scrollController,
            icons: icons,
            doc: widget.doc,
            photo: widget.photo,
          )
        ],
      ),
    );
  }
}
