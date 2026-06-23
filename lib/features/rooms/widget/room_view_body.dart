import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:svgaplayer_flutter/player.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/zego_uikit_prebuilt_live_audio_room.dart';
import '../../../core/Utils/app_images.dart';
import '../../../models/gift_model.dart';
import 'constant.dart';
import 'package:zego_uikit/zego_uikit.dart';

class RoomViewBody extends StatefulWidget {
  final String roomID;
  final bool isHost;
  final String username; // display name
  final String userid;   // firebase UID
  final layoutMode = LayoutMode.defaultLayout;

  const RoomViewBody({
    Key? key,
    required this.roomID,
    required this.isHost,
    required this.username,
    required this.userid,
  }) : super(key: key);

  @override
  _RoomViewBody createState() => _RoomViewBody();
}

class _RoomViewBody extends State<RoomViewBody> {
  static const Color _gold = Color(0xFFFFD700);

  List<int> lockedSeats = [];
  List<String> userSeats = [];

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String framePhoto = "";
  final isRequestingNotifier = ValueNotifier<bool>(false);
  final controller = ZegoLiveAudioRoomController();

  List<String> musicPath = [];
  List<String> musicname = [];
  DateTime? seatOccupiedTime;

  String viewID = "";
  String bio = "";
  String layoutSeats = "";
  String roomLayoutType = "party"; // party | podcast | wedding | debate | singing
  String micMode = "free"; // free | request
  String wallpaper =
      "https://firebasestorage.googleapis.com/v0/b/hayaa-161f5.appspot.com/o/rooms%2Fclose-up-microphone-pop-filter-studio.jpg?alt=media&token=c9014900-dba7-4e7c-80c4-8d9fc6055462";

  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  final List<TextEditingController> _passControllers =
      List.generate(6, (_) => TextEditingController());

  String pass = "";
  String giftMedia = "";
  String carMedia = "";
  String cartype = "";
  String gifttype = "";
  String myType = "";
  String MytypeInRoom = "";
  String roomOwnerUID = "";
  String mycoin = "";
  String myexp = "";
  String myfamily = "";

  // Stream subscriptions for proper cleanup
  StreamSubscription? _roomSub;
  StreamSubscription? _userSub;
  StreamSubscription? _blockSub;
  StreamSubscription? _myUserSub;
  StreamSubscription? _roomUsersSub;

  // Session timer
  DateTime? _sessionStart;
  String _sessionDuration = '00:00';
  Timer? _sessionTimer;

  // Quick reactions
  final List<_FloatingEmoji> _floatingEmojis = [];

  // VIP welcome banner
  bool _roomUsersInitialized = false;
  _VipEntry? _vipWelcome;
  final Set<String> _seenUsers = {};

  // Flying messages
  int myVip = 0;
  StreamSubscription? _flyingSub;
  bool _flyingInitialized = false;
  final List<_FlyingMessage> _flyingMessages = [];

  @override
  void initState() {
    super.initState();
    _listenUserInRoom();
    _listenRoomData();
    _listenMyUserData();
    _listenBlock();
    _listenVipEntrances();
    _listenFlyingMessages();
    _logRoomEvent('➕ انضم ${widget.username}');
    _sessionStart = DateTime.now();
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      final diff = DateTime.now().difference(_sessionStart!);
      final m = diff.inMinutes.remainder(60).toString().padLeft(2, '0');
      final s = diff.inSeconds.remainder(60).toString().padLeft(2, '0');
      setState(() => _sessionDuration = '$m:$s');
    });
  }

  @override
  void dispose() {
    _sessionTimer?.cancel();
    _roomSub?.cancel();
    _userSub?.cancel();
    _blockSub?.cancel();
    _myUserSub?.cancel();
    _roomUsersSub?.cancel();
    _flyingSub?.cancel();
    for (var n in _focusNodes) {
      n.dispose();
    }
    for (var c in _passControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _sendReaction(String emoji) {
    controller.message.send(emoji);
    final id = DateTime.now().millisecondsSinceEpoch;
    final entry = _FloatingEmoji(
      id: id,
      emoji: emoji,
      left: (MediaQuery.of(context).size.width * 0.1) +
          (id % 5) * (MediaQuery.of(context).size.width * 0.15),
    );
    setState(() => _floatingEmojis.add(entry));
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => _floatingEmojis.removeWhere((e) => e.id == id));
    });
  }

  void _listenUserInRoom() {
    _userSub = _firestore
        .collection('room')
        .doc(widget.roomID)
        .collection('user')
        .doc(_auth.currentUser!.uid)
        .snapshots()
        .listen((snap) {
      if (snap.exists && mounted) {
        setState(() => MytypeInRoom = snap.get('type') ?? '');
      }
    });
  }

  void _listenMyUserData() {
    _myUserSub = _firestore
        .collection('user')
        .doc(_auth.currentUser!.uid)
        .snapshots()
        .listen((snap) {
      if (!mounted) return;
      final mydata = snap.data() ?? {};
      setState(() {
        myType = mydata['type'] ?? '';
        myVip = int.tryParse(mydata['vip']?.toString() ?? '0') ?? 0;
      });
      final mycar = mydata['mycar'] ?? '';
      if (mycar.isNotEmpty) {
        _firestore.collection('store').doc(mycar).get().then((storeSnap) {
          if (!storeSnap.exists || !mounted) return;
          final photo = storeSnap.get('photo') ?? '';
          final type = storeSnap.get('type') ?? '';
          if (photo.isEmpty) return;
          setState(() {
            carMedia = photo;
            cartype = type;
          });
          _firestore.collection('room').doc(widget.roomID).update({
            'car': photo,
            'cartype': type,
          });
          Future.delayed(const Duration(seconds: 4), () {
            if (!mounted) return;
            _firestore.collection('room').doc(widget.roomID).update({
              'car': '',
              'cartype': '',
            });
            setState(() => carMedia = '');
            controller.message.send('انضم إلى الغرفة');
          });
        });
      }
    });
  }

  void _listenRoomData() {
    _roomSub = _firestore
        .collection('room')
        .doc(widget.roomID)
        .snapshots()
        .listen((snap) {
      if (!snap.exists || !mounted) return;
      final data = snap.data() ?? {};
      setState(() {
        wallpaper = data['wallpaper'] ?? wallpaper;
        viewID = data['id'] ?? '';
        bio = data['bio'] ?? '';
        layoutSeats = data['seat'] ?? '9';
        roomLayoutType = data['layoutType'] ?? 'party';
        micMode = data['micMode'] ?? 'free';
        pass = data['password'] ?? '';
        giftMedia = data['gift'] ?? '';
        gifttype = data['gifttype'] ?? '';
        carMedia = data['car'] ?? '';
        cartype = data['cartype'] ?? '';
        roomOwnerUID = data['owner'] ?? '';
      });
    });
  }

  void _listenBlock() {
    _blockSub = _firestore
        .collection('room')
        .doc(widget.roomID)
        .collection('block')
        .where('id', isEqualTo: _auth.currentUser!.uid)
        .snapshots()
        .listen((snap) {
      if (snap.size != 0 && MytypeInRoom != "owner" && mounted) {
        controller.leave(context, showConfirmation: false);
      }
    });
  }

  /// Watches the room user list and shows a welcome banner when a VIP enters.
  void _listenVipEntrances() {
    _roomUsersSub = _firestore
        .collection('room')
        .doc(widget.roomID)
        .collection('user')
        .snapshots()
        .listen((snap) {
      for (final change in snap.docChanges) {
        if (change.type != DocumentChangeType.added) continue;
        final data = change.doc.data();
        if (data == null) continue;
        final uid = data['id'] ?? change.doc.id;
        // Skip the users already present when we joined.
        if (!_roomUsersInitialized) {
          _seenUsers.add(uid);
          continue;
        }
        if (_seenUsers.contains(uid)) continue;
        _seenUsers.add(uid);
        _maybeWelcomeVip(uid);
      }
      _roomUsersInitialized = true;
    });
  }

  Future<void> _maybeWelcomeVip(String uid) async {
    final userSnap = await _firestore
        .collection('user')
        .where('doc', isEqualTo: uid)
        .limit(1)
        .get();
    if (userSnap.docs.isEmpty || !mounted) return;
    final d = userSnap.docs.first;
    final vip = int.tryParse(d.get('vip')?.toString() ?? '0') ?? 0;
    if (vip < 1) return; // only VIP members get a grand entrance
    setState(() {
      _vipWelcome = _VipEntry(
        name: d.get('name') ?? '',
        photo: d.get('photo') ?? '',
        vip: vip,
      );
    });
    Future.delayed(const Duration(seconds: 4), () {
      if (!mounted) return;
      setState(() => _vipWelcome = null);
    });
  }

  /// Listens for VIP flying messages and animates new ones across the screen.
  void _listenFlyingMessages() {
    _flyingSub = _firestore
        .collection('room')
        .doc(widget.roomID)
        .collection('flying')
        .orderBy('timestamp', descending: true)
        .limit(10)
        .snapshots()
        .listen((snap) {
      for (final change in snap.docChanges) {
        if (change.type != DocumentChangeType.added) continue;
        if (!_flyingInitialized) continue; // skip backlog on first load
        final data = change.doc.data();
        if (data == null || !mounted) continue;
        final id = DateTime.now().microsecondsSinceEpoch;
        setState(() {
          _flyingMessages.add(_FlyingMessage(
            id: id,
            name: data['name'] ?? '',
            text: data['text'] ?? '',
            vip: data['vip'] ?? 0,
          ));
        });
        Future.delayed(const Duration(seconds: 6), () {
          if (!mounted) return;
          setState(() =>
              _flyingMessages.removeWhere((m) => m.id == id));
        });
      }
      _flyingInitialized = true;
    });
  }

  void _sendFlyingMessage() {
    if (myVip < 1) {
      _showInfoDialog('ميزة VIP', 'الرسائل العائمة متاحة لأعضاء VIP فقط');
      return;
    }
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: Row(
          children: const [
            Text('✈️', style: TextStyle(fontSize: 18)),
            SizedBox(width: 6),
            Text('رسالة عائمة', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: TextField(
          controller: ctrl,
          maxLength: 80,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'اكتب رسالتك...',
            hintStyle: const TextStyle(color: Colors.white38),
            filled: true,
            fillColor: Colors.white10,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: _gold),
            onPressed: () {
              final text = ctrl.text.trim();
              if (text.isEmpty) return;
              _firestore
                  .collection('room')
                  .doc(widget.roomID)
                  .collection('flying')
                  .add({
                'name': widget.username,
                'text': text,
                'vip': myVip,
                'timestamp': FieldValue.serverTimestamp(),
              });
              Navigator.pop(context);
            },
            child: const Text('إرسال', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  bool get _isPrivileged =>
      MytypeInRoom == "owner" ||
      MytypeInRoom == "admin" ||
      _auth.currentUser!.uid == roomOwnerUID;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('user')
          .where('doc', isEqualTo: _auth.currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        String Myframe = "";
        for (var doc in snapshot.data!.docs) {
          Myframe = doc.get('myframe') ?? '';
        }

        return StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('store')
              .where('id', isEqualTo: Myframe)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            for (var doc in snapshot.data!.docs) {
              framePhoto = doc.get('photo') ?? '';
            }

            return SafeArea(
              child: ZegoUIKitPrebuiltLiveAudioRoom(
                appID: 911296599,
                appSign:
                    "6fbf17123e3533d8779f74cf45de647605d854ff8737fd4d2c9bc5b22f14edcb",
                userID: widget.userid,
                userName: widget.username,
                roomID: viewID,
                config: (widget.isHost
                        ? ZegoUIKitPrebuiltLiveAudioRoomConfig.host()
                        : ZegoUIKitPrebuiltLiveAudioRoomConfig.audience())
                  ..onLeaveConfirmation = _onLeaveConfirmation
                  ..background = _buildBackground()
                  ..takeSeatIndexWhenJoining = widget.isHost ? 0 : -1
                  ..hostSeatIndexes = [0]
                  ..useSpeakerWhenJoining = true
                  ..onMemberListMoreButtonPressed =
                      onMemberListMoreButtonPressed
                  ..seatConfig = ZegoLiveAudioRoomSeatConfig(
                    backgroundBuilder: (context, size, user, extraInfo) =>
                        Container(color: Colors.transparent),
                    foregroundBuilder: (_, size, user, extraInfo) {
                      final int seatIndex = extraInfo['seat_index'] ?? 0;
                      final bool isLocked = extraInfo['seat_status'] == 2;
                      return _buildSeatForeground(
                          size, user, seatIndex, isLocked);
                    },
                    closeIcon: null,
                    openIcon: null,
                    avatarBuilder: (context, size, user, extraInfo) =>
                        _buildAvatar(size, user),
                  )
                  ..inRoomMessageConfig = ZegoInRoomMessageConfig(
                    height: 166,
                    showAvatar: false,
                  )
                  ..layoutConfig.rowConfigs = _buildLayoutRows()
                  ..onSeatClicked = (index, user) {
                    _handleSeatTap(index, user, lockedSeats.contains(index));
                  }
                  ..onSeatsChanged = _onSeatsChanged
                  ..onSeatTakingRequestFailed = () {
                    isRequestingNotifier.value = false;
                  }
                  ..onSeatTakingRequestRejected = () {
                    isRequestingNotifier.value = false;
                  }
                  ..onSeatTakingRequested = (ZegoUIKitUser audience) {}
                  ..onInviteAudienceToTakeSeatFailed = () {}
                  ..bottomMenuBarConfig = ZegoBottomMenuBarConfig(
                    maxCount: 6,
                    audienceExtendButtons: [
                      _buildGiftButton(),
                      _buildApplauseButton(),
                      _buildFlyingMsgButton(),
                    ],
                    speakerExtendButtons: [
                      _buildGiftButton(),
                      _buildApplauseButton(),
                      _buildFlyingMsgButton(),
                    ],
                    hostExtendButtons: [
                      _buildGiftButton(),
                      _buildPasswordButton(),
                      _buildMusicButton(),
                      _buildWallpaperButton(),
                      _buildLayoutButton(),
                      _buildAnnouncementButton(),
                      _buildStopMusicButton(),
                      _buildApplauseButton(),
                      _buildFlyingMsgButton(),
                      _buildAdminButton(),
                    ],
                    speakerButtons: [
                      ZegoMenuBarButtonName.toggleMicrophoneButton,
                      ZegoMenuBarButtonName.showMemberListButton,
                    ],
                  ),
                controller: controller,
              ),
            );
          },
        );
      },
    );
  }

  // ─────────────────────────────────────────────
  // SEAT HANDLERS
  // ─────────────────────────────────────────────

  void _handleSeatTap(int seatIndex, ZegoUIKitUser? user, bool isLocked) {
    final bool isEmpty = user == null;
    final bool isMySeat =
        !isEmpty && user!.id == _auth.currentUser!.uid;

    if (isMySeat) {
      _confirmLeaveSeat();
    } else if (_isPrivileged) {
      if (isEmpty) {
        _showEmptySeatMenu(seatIndex, isLocked);
      } else {
        _showOccupiedSeatMenu(user!);
      }
    } else {
      if (!isEmpty) {
        _showUserProfileCard(user!);
      } else if (!isLocked) {
        if (micMode == 'request') {
          _requestSeat(seatIndex);
        } else {
          controller.takeSeat(seatIndex);
        }
      }
    }
  }

  /// In request-mic mode, audience sends a seat request to the host instead
  /// of taking the seat directly.
  void _requestSeat(int seatIndex) {
    _firestore
        .collection('room')
        .doc(widget.roomID)
        .collection('seatRequests')
        .doc(_auth.currentUser!.uid)
        .set({
      'uid': _auth.currentUser!.uid,
      'name': widget.username,
      'photo': _auth.currentUser!.photoURL ?? '',
      'seatIndex': seatIndex,
      'timestamp': FieldValue.serverTimestamp(),
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم إرسال طلب الصعود للمالك'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showEmptySeatMenu(int seatIndex, bool isLocked) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A2E),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _handle(),
            ListTile(
              leading: const Icon(Icons.mic, color: _gold),
              title: const Text('الانتقال إلى هذا المقعد',
                  style: TextStyle(color: Colors.white)),
              onTap: () async {
                Navigator.pop(context);
                await controller.leaveSeat(showDialog: false);
                controller.takeSeat(seatIndex);
              },
            ),
            ListTile(
              leading: Icon(isLocked ? Icons.lock_open : Icons.lock,
                  color: _gold),
              title: Text(isLocked ? 'فتح المقعد' : 'قفل المقعد',
                  style: const TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                isLocked ? openSeat(seatIndex) : closeSeat(seatIndex);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_add, color: _gold),
              title: const Text('دعوة عضو للمقعد',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _showInviteMemberSheet(context, seatIndex);
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  void _showOccupiedSeatMenu(ZegoUIKitUser user) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A2E),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _handle(),
            ListTile(
              leading: const Icon(Icons.mic_off, color: _gold),
              title: const Text('كتم الميكروفون',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _muteUser(user);
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.airline_seat_recline_normal, color: _gold),
              title: const Text('إنزال من المقعد',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                controller.removeSpeakerFromSeat(user.id);
              },
            ),
            if (MytypeInRoom == "owner")
              ListTile(
                leading: const Icon(Icons.admin_panel_settings, color: _gold),
                title: const Text('تعيين كـ مشرف',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _toggleAdminRole(user.id, user.name);
                },
              ),
            if (MytypeInRoom == "owner")
              ListTile(
                leading: const Icon(Icons.block, color: Colors.redAccent),
                title: const Text('حظر من الغرفة',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _blockUser(user.id, user.name);
                },
              ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  /// Shows a mini profile card for any seated user (non-privileged view)
  void _showUserProfileCard(ZegoUIKitUser zegoUser) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('user')
            .where('doc', isEqualTo: zegoUser.id)
            .snapshots(),
        builder: (context, snap) {
          if (!snap.hasData || snap.data!.docs.isEmpty) {
            return const SizedBox(
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            );
          }
          final data = snap.data!.docs.first;
          final name = data.get('name') ?? '';
          final photo = data.get('photo') ?? '';
          final level = data.get('level') ?? '1';
          final vip = data.get('vip') ?? '0';
          return Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _gold.withOpacity(0.4), width: 1),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: photo.isNotEmpty
                      ? CachedNetworkImageProvider(photo)
                      : null,
                  backgroundColor: Colors.grey[800],
                ),
                const SizedBox(height: 12),
                Text(name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _badge('Lv.$level', Colors.blueAccent),
                    if (vip != '0') ...[
                      const SizedBox(width: 6),
                      _badge('VIP $vip', _gold),
                    ],
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _gold,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  icon: const Icon(Icons.card_giftcard),
                  label: const Text('أرسل هدية'),
                  onPressed: () {
                    Navigator.pop(context);
                    showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (_) => bottomSheet(),
                    );
                  },
                ),
                const SizedBox(height: 8),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _badge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color, width: 1),
      ),
      child:
          Text(text, style: TextStyle(color: color, fontSize: 12)),
    );
  }

  Future<void> _showInviteMemberSheet(
      BuildContext context, int seatIndex) async {
    final snap = await _firestore
        .collection('room')
        .doc(widget.roomID)
        .collection('user')
        .get();

    final members = snap.docs
        .where((d) =>
            d.get('id') != _auth.currentUser!.uid &&
            !userSeats.contains(d.get('id')))
        .toList();

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A2E),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => SafeArea(
        child: members.isEmpty
            ? const ListTile(
                title: Text('لا يوجد أعضاء للدعوة',
                    style: TextStyle(color: Colors.white54)))
            : ListView.builder(
                shrinkWrap: true,
                itemCount: members.length,
                itemBuilder: (_, i) => ListTile(
                  leading: const Icon(Icons.person, color: Colors.white70),
                  title: Text(members[i].get('name') ?? '',
                      style: const TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.pop(context);
                    controller.inviteAudienceToTakeSeat(members[i].get('id'));
                  },
                ),
              ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // SEAT MANAGEMENT
  // ─────────────────────────────────────────────

  void openSeat(int seatIndex) {
    setState(() => lockedSeats.remove(seatIndex));
    controller.openSeats(targetIndex: seatIndex);
  }

  void closeSeat(int seatIndex) {
    setState(() => lockedSeats.add(seatIndex));
    controller.closeSeats(targetIndex: seatIndex);
    controller.message.send('تم قفل المقعد ${seatIndex + 1}');
  }

  void _confirmLeaveSeat() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Text('النزول من المقعد',
            style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              controller.leaveSeat(showDialog: false);
            },
            child: const Text('نزول',
                style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // SEATS CHANGED CALLBACK
  // ─────────────────────────────────────────────

  void _onSeatsChanged(
      Map<int, ZegoUIKitUser> takenSeats, List<int> untakenSeats) {
    setState(() => userSeats.clear());
    takenSeats.forEach((seatIndex, user) {
      setState(() => userSeats.add(user.id));
      if (user.id == _auth.currentUser!.uid && myType == "host") {
        seatOccupiedTime ??= DateTime.now();
      }
    });

    if (!userSeats.contains(_auth.currentUser!.uid) &&
        seatOccupiedTime != null) {
      final timeSpent = DateTime.now().difference(seatOccupiedTime!);
      seatOccupiedTime = null;
      _saveHostIncome(timeSpent);
    }
  }

  void _saveHostIncome(Duration timeSpent) {
    _firestore
        .collection('user')
        .doc(_auth.currentUser!.uid)
        .get()
        .then((value) {
      final myagent = value.get('myagent') ?? '';
      if (myagent.isEmpty) return;
      final docs =
          "${DateTime.now().month}-${DateTime.now().day}";
      final incomeRef = _firestore
          .collection('agency')
          .doc(myagent)
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('income')
          .doc(docs);

      incomeRef.get().then((inc) {
        final prev = inc.exists ? int.tryParse(inc.get('hosttime') ?? '0') ?? 0 : 0;
        final total = prev + timeSpent.inMinutes;
        if (!inc.exists) {
          incomeRef.set({
            'count': '0',
            'date': DateTime.now().toString(),
            'hosttime': total.toString(),
            'numberradio': total >= 60 ? '1' : '0',
          });
        } else {
          incomeRef.update({
            'hosttime': total.toString(),
            'numberradio': total >= 60 ? '1' : '0',
          });
        }
      });
    });
  }

  // ─────────────────────────────────────────────
  // LEAVE CONFIRMATION
  // ─────────────────────────────────────────────

  Future<bool> _onLeaveConfirmation(BuildContext ctx) async {
    return await showDialog<bool>(
          context: ctx,
          builder: (_) => AlertDialog(
            backgroundColor: Colors.blue[900]!.withOpacity(0.9),
            title: const Text('مغادرة الغرفة',
                style: TextStyle(color: Colors.white70)),
            content: const Text('هل تريد مغادرة الغرفة؟',
                style: TextStyle(color: Colors.white70)),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await _firestore
                      .collection('room')
                      .doc(widget.roomID)
                      .collection('user')
                      .doc(_auth.currentUser!.uid)
                      .delete();
                  Navigator.of(context).pop(true);
                },
                child: const Text('خروج'),
              ),
            ],
          ),
        ) ??
        false;
  }

  // ─────────────────────────────────────────────
  // BACKGROUND & AVATAR BUILDERS
  // ─────────────────────────────────────────────

  Widget _buildBackground() {
    return Stack(
      children: [
        // Wallpaper
        Positioned.fill(
          child: CachedNetworkImage(
            imageUrl: wallpaper.isEmpty
                ? "https://firebasestorage.googleapis.com/v0/b/hayaa-161f5.appspot.com/o/rooms%2Fclose-up-microphone-pop-filter-studio.jpg?alt=media&token=c9014900-dba7-4e7c-80c4-8d9fc6055462"
                : wallpaper,
            fit: BoxFit.cover,
          ),
        ),
        // Dark overlay for readability
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.5),
                ],
              ),
            ),
          ),
        ),
        // Room info bar
        Positioned(
          top: 8,
          left: 12,
          right: 12,
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: _isPrivileged ? _showUpdateBio : null,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bio,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          shadows: [Shadow(blurRadius: 4)],
                        ),
                      ),
                      Text(
                        'ID: $viewID',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Top supporters (top 3)
              _buildTopSupporters(),
              const SizedBox(width: 6),
              // Online count badge
              StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('room')
                    .doc(widget.roomID)
                    .collection('user')
                    .snapshots(),
                builder: (context, snap) {
                  final count = snap.data?.docs.length ?? 0;
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.remove_red_eye,
                            color: Colors.white70, size: 14),
                        const SizedBox(width: 4),
                        Text('$count',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12)),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        // VIP welcome banner
        if (_vipWelcome != null)
          Positioned(
            top: 70,
            left: 0,
            right: 0,
            child: _VipWelcomeBanner(entry: _vipWelcome!),
          ),
        // Flying VIP messages
        ..._flyingMessages.asMap().entries.map((e) => Positioned(
              top: 110.0 + (e.key % 3) * 44,
              left: 0,
              right: 0,
              child: _FlyingMessageWidget(
                key: ValueKey(e.value.id),
                message: e.value,
                screenWidth: MediaQuery.of(context).size.width,
              ),
            )),
        // Session timer badge
        Positioned(
          bottom: 200,
          left: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.timer, color: _gold, size: 14),
                const SizedBox(width: 4),
                Text(_sessionDuration,
                    style: const TextStyle(color: Colors.white, fontSize: 12)),
              ],
            ),
          ),
        ),
        // Quick reaction buttons
        Positioned(
          bottom: 200,
          right: 8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: ['❤️', '👏', '😂', '🔥', '🎉'].map((emoji) {
              return GestureDetector(
                onTap: () => _sendReaction(emoji),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 4),
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Center(
                    child: Text(emoji, style: const TextStyle(fontSize: 18)),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        // Floating emoji animations
        ..._floatingEmojis.map((e) => Positioned(
              left: e.left,
              bottom: 250,
              child: _FloatingEmojiWidget(emoji: e.emoji),
            )),
        // Gift animation overlay
        if (giftMedia.isNotEmpty)
          Center(
            child: gifttype != "svga"
                ? CachedNetworkImage(imageUrl: giftMedia, height: 180)
                : SizedBox(
                    height: 180,
                    width: 180,
                    child: SVGASimpleImage(resUrl: giftMedia)),
          ),
        // Car animation overlay
        if (carMedia.isNotEmpty)
          Center(
            child: cartype != "svga"
                ? CachedNetworkImage(imageUrl: carMedia, height: 160)
                : SizedBox(
                    height: 160,
                    width: 160,
                    child: SVGASimpleImage(resUrl: carMedia)),
          ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // MODERN SEAT SYSTEM
  // ─────────────────────────────────────────────

  /// Foreground overlay drawn on top of every seat (empty, locked or taken).
  Widget _buildSeatForeground(
      Size size, ZegoUIKitUser? user, int seatIndex, bool isLocked) {
    final bool isEmpty = user == null;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _handleSeatTap(seatIndex, user, isLocked),
      child: SizedBox(
        width: size.width,
        height: size.height,
        child: isEmpty
            ? _buildEmptySeat(size, seatIndex, isLocked)
            : _buildOccupiedSeatOverlay(size, user, seatIndex),
      ),
    );
  }

  /// Empty or locked seat — gradient circle with mic / lock icon + seat number.
  Widget _buildEmptySeat(Size size, int seatIndex, bool isLocked) {
    final double avatarSize = size.width * 0.62;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: avatarSize,
          height: avatarSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isLocked
                  ? [const Color(0xFF2A2A3E), const Color(0xFF1A1A2E)]
                  : [Colors.white12, Colors.white10],
            ),
            border: Border.all(
              color: isLocked
                  ? Colors.white12
                  : _gold.withOpacity(0.35),
              width: 1,
            ),
          ),
          child: Icon(
            isLocked ? Icons.lock : Icons.add,
            color: isLocked ? const Color(0xFF888888) : _gold.withOpacity(0.8),
            size: avatarSize * 0.45,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          isLocked ? 'مقفل' : '${seatIndex + 1}',
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  /// Overlay on a taken seat: name, mic status, crown, gift counter, speaking ring.
  Widget _buildOccupiedSeatOverlay(
      Size size, ZegoUIKitUser user, int seatIndex) {
    final bool isOwnerSeat = seatIndex == 0;
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        // Speaking ripple ring (driven by Zego sound level)
        ValueListenableBuilder<double>(
          valueListenable: ZegoUIKit().getSoundLevelNotifier(user.id),
          builder: (context, level, _) {
            final bool speaking = level > 10;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: size.width * (speaking ? 0.78 : 0.66),
              height: size.width * (speaking ? 0.78 : 0.66),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: speaking ? const Color(0xFF4CFF6A) : Colors.transparent,
                  width: 2.5,
                ),
                boxShadow: speaking
                    ? [
                        BoxShadow(
                          color: const Color(0xFF4CFF6A).withOpacity(0.5),
                          blurRadius: 10,
                          spreadRadius: 1,
                        )
                      ]
                    : null,
              ),
            );
          },
        ),
        // Crown for the owner seat
        if (isOwnerSeat)
          Positioned(
            top: -size.height * 0.06,
            child: const Text('👑', style: TextStyle(fontSize: 16)),
          ),
        // Microphone muted badge
        Positioned(
          right: size.width * 0.12,
          top: size.height * 0.06,
          child: ValueListenableBuilder<bool>(
            valueListenable:
                ZegoUIKit().getMicrophoneStateNotifier(user.id),
            builder: (context, micOn, _) {
              if (micOn) return const SizedBox.shrink();
              return Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.mic_off,
                    color: Colors.white, size: 11),
              );
            },
          ),
        ),
        // Name + gift contribution counter at the bottom
        Positioned(
          bottom: -size.height * 0.04,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                constraints: BoxConstraints(maxWidth: size.width * 0.95),
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  user.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              _buildSeatGiftCounter(user.id, size),
            ],
          ),
        ),
      ],
    );
  }

  /// Live diamond contribution counter for the seated user.
  Widget _buildSeatGiftCounter(String uid, Size size) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('user')
          .where('doc', isEqualTo: uid)
          .snapshots(),
      builder: (context, snap) {
        if (!snap.hasData || snap.data!.docs.isEmpty) {
          return const SizedBox.shrink();
        }
        final diamonds = snap.data!.docs.first.get('daimond') ?? '0';
        return Container(
          margin: const EdgeInsets.only(top: 1),
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [Color(0xFFFFA726), Color(0xFFFF7043)]),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.diamond, color: Colors.white, size: 9),
              const SizedBox(width: 2),
              Text(
                _formatCount(diamonds),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatCount(String raw) {
    final n = int.tryParse(raw) ?? 0;
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return n.toString();
  }

  /// Top-3 supporters avatars, tappable to open the full ranking sheet.
  Widget _buildTopSupporters() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('room')
          .doc(widget.roomID)
          .collection('supporters')
          .orderBy('total', descending: true)
          .limit(3)
          .snapshots(),
      builder: (context, snap) {
        if (!snap.hasData || snap.data!.docs.isEmpty) {
          return const SizedBox.shrink();
        }
        final docs = snap.data!.docs;
        return GestureDetector(
          onTap: _showSupportersSheet,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('🏆', style: TextStyle(fontSize: 12)),
                const SizedBox(width: 4),
                ...List.generate(docs.length, (i) {
                  final photo = docs[i].get('photo') ?? '';
                  final rankColor = i == 0
                      ? _gold
                      : i == 1
                          ? const Color(0xFFC0C0C0)
                          : const Color(0xFFCD7F32);
                  return Padding(
                    padding: EdgeInsets.only(left: i == 0 ? 0 : 2),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: rankColor, width: 1.5),
                      ),
                      child: CircleAvatar(
                        radius: 10,
                        backgroundImage: photo.toString().isNotEmpty
                            ? CachedNetworkImageProvider(photo)
                            : null,
                        backgroundColor: Colors.grey[700],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSupportersSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A2E),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: SizedBox(
          height: 400,
          child: Column(
            children: [
              _handle(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('🏆', style: TextStyle(fontSize: 18)),
                    const SizedBox(width: 6),
                    Text('كبار الداعمين',
                        style: TextStyle(
                            color: _gold,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('room')
                      .doc(widget.roomID)
                      .collection('supporters')
                      .orderBy('total', descending: true)
                      .limit(50)
                      .snapshots(),
                  builder: (context, snap) {
                    if (!snap.hasData) {
                      return const Center(
                          child: CircularProgressIndicator());
                    }
                    final docs = snap.data!.docs;
                    if (docs.isEmpty) {
                      return const Center(
                          child: Text('لا يوجد داعمون بعد',
                              style: TextStyle(color: Colors.white54)));
                    }
                    return ListView.builder(
                      itemCount: docs.length,
                      itemBuilder: (context, i) {
                        final d = docs[i];
                        final name = d.get('name') ?? '';
                        final photo = d.get('photo') ?? '';
                        final total = d.get('total')?.toString() ?? '0';
                        final rankColor = i == 0
                            ? _gold
                            : i == 1
                                ? const Color(0xFFC0C0C0)
                                : i == 2
                                    ? const Color(0xFFCD7F32)
                                    : Colors.white24;
                        return ListTile(
                          leading: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 22,
                                child: Text('${i + 1}',
                                    style: TextStyle(
                                        color: rankColor,
                                        fontWeight: FontWeight.bold)),
                              ),
                              CircleAvatar(
                                radius: 18,
                                backgroundImage: photo.toString().isNotEmpty
                                    ? CachedNetworkImageProvider(photo)
                                    : null,
                                backgroundColor: Colors.grey[700],
                              ),
                            ],
                          ),
                          title: Text(name,
                              style: const TextStyle(color: Colors.white)),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.diamond,
                                  color: Color(0xFFFFA726), size: 14),
                              const SizedBox(width: 4),
                              Text(_formatCount(total),
                                  style: const TextStyle(
                                      color: _gold,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(Size size, ZegoUIKitUser? user) {
    if (user == null) return const SizedBox.shrink();

    final isMe = user.id == _auth.currentUser!.uid;
    if (isMe) {
      return _avatarStack(
        size,
        framePhoto,
        _auth.currentUser!.photoURL ?? '',
      );
    }

    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('user')
          .where('doc', isEqualTo: user.id)
          .snapshots(),
      builder: (context, snap) {
        String userPhoto = '';
        String userFrame = '';
        if (snap.hasData) {
          for (var doc in snap.data!.docs) {
            userPhoto = doc.get('photo') ?? '';
            userFrame = doc.get('myframe') ?? '';
          }
        }
        return StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('store')
              .where('id', isEqualTo: userFrame)
              .snapshots(),
          builder: (context, snap2) {
            String framePh = '';
            if (snap2.hasData) {
              for (var doc in snap2.data!.docs) {
                framePh = doc.get('photo') ?? '';
              }
            }
            return _avatarStack(size, framePh, userPhoto);
          },
        );
      },
    );
  }

  Widget _avatarStack(Size size, String frameUrl, String photoUrl) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Photo (slightly inset so the frame can wrap it)
        Container(
          width: size.width - 23,
          height: size.width - 23,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 4,
              ),
            ],
          ),
          child: CircleAvatar(
            backgroundImage: photoUrl.isNotEmpty
                ? CachedNetworkImageProvider(photoUrl)
                : null,
            backgroundColor: Colors.grey[700],
            child: photoUrl.isEmpty
                ? const Icon(Icons.person, color: Colors.white54)
                : null,
          ),
        ),
        // Decorative frame on top
        if (frameUrl.isNotEmpty)
          CircleAvatar(
            maxRadius: size.width,
            backgroundImage: CachedNetworkImageProvider(frameUrl),
            backgroundColor: Colors.transparent,
          ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // LAYOUT ROWS
  // ─────────────────────────────────────────────

  ZegoLiveAudioRoomLayoutRowConfig _row(int count) =>
      ZegoLiveAudioRoomLayoutRowConfig(
        count: count,
        alignment: count == 1
            ? ZegoLiveAudioRoomLayoutAlignment.center
            : ZegoLiveAudioRoomLayoutAlignment.spaceAround,
      );

  List<ZegoLiveAudioRoomLayoutRowConfig> _buildLayoutRows() {
    // Specialised layouts take priority over plain seat counts.
    switch (roomLayoutType) {
      case 'podcast':
        // Host on top, a single spacious row of 4 guests.
        return [_row(1), _row(4)];
      case 'wedding':
        // Bride & groom centre stage, guests around.
        return [_row(1), _row(2), _row(4)];
      case 'debate':
        // Two opponents facing, audience below.
        return [_row(2), _row(4), _row(4)];
      case 'singing':
        // Lead singer, then chorus.
        return [_row(1), _row(4)];
      case 'party':
      default:
        break;
    }
    if (layoutSeats == '11') {
      return [
        ZegoLiveAudioRoomLayoutRowConfig(
            count: 1,
            alignment: ZegoLiveAudioRoomLayoutAlignment.center),
        ZegoLiveAudioRoomLayoutRowConfig(
            count: 2,
            alignment: ZegoLiveAudioRoomLayoutAlignment.spaceAround),
        ZegoLiveAudioRoomLayoutRowConfig(
            count: 4,
            alignment: ZegoLiveAudioRoomLayoutAlignment.spaceAround),
        ZegoLiveAudioRoomLayoutRowConfig(
            count: 4,
            alignment: ZegoLiveAudioRoomLayoutAlignment.spaceAround),
      ];
    } else if (layoutSeats == '13') {
      return [
        ZegoLiveAudioRoomLayoutRowConfig(
            count: 1,
            alignment: ZegoLiveAudioRoomLayoutAlignment.center),
        ZegoLiveAudioRoomLayoutRowConfig(
            count: 4,
            alignment: ZegoLiveAudioRoomLayoutAlignment.spaceAround),
        ZegoLiveAudioRoomLayoutRowConfig(
            count: 4,
            alignment: ZegoLiveAudioRoomLayoutAlignment.spaceAround),
        ZegoLiveAudioRoomLayoutRowConfig(
            count: 4,
            alignment: ZegoLiveAudioRoomLayoutAlignment.spaceAround),
      ];
    }
    // default '9'
    return [
      ZegoLiveAudioRoomLayoutRowConfig(
          count: 1,
          alignment: ZegoLiveAudioRoomLayoutAlignment.center),
      ZegoLiveAudioRoomLayoutRowConfig(
          count: 4,
          alignment: ZegoLiveAudioRoomLayoutAlignment.spaceAround),
      ZegoLiveAudioRoomLayoutRowConfig(
          count: 4,
          alignment: ZegoLiveAudioRoomLayoutAlignment.spaceAround),
    ];
  }

  // ─────────────────────────────────────────────
  // BOTTOM BAR BUTTONS
  // ─────────────────────────────────────────────

  Widget _buildGiftButton() {
    return CircleAvatar(
      backgroundColor: Colors.white,
      child: IconButton(
        onPressed: () => showModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: context,
          builder: (_) => bottomSheet(),
        ),
        icon: const Icon(Icons.card_giftcard, color: Colors.black),
      ),
    );
  }

  Widget _buildPasswordButton() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          backgroundColor: Colors.white,
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
              if (pass.isEmpty) {
                _showSetPasswordDialog();
              } else {
                _removePassword();
              }
            },
            icon: Icon(
              pass.isEmpty ? Icons.lock_open : Icons.lock,
              color: Colors.black,
            ),
          ),
        ),
        Text(
          pass.isEmpty ? 'كلمة سر' : 'إزالة السر',
          style: const TextStyle(color: Colors.white, fontSize: 8),
        ),
      ],
    );
  }

  Widget _buildMusicButton() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          backgroundColor: Colors.white,
          backgroundImage: AssetImage(AppImages.music),
          child: InkWell(
            onTap: () {
              controller.media.pickPureAudioFile().then((value) {
                Navigator.pop(context);
                for (var f in value) {
                  musicPath.add(f.path);
                  musicname.add(f.name);
                }
                showModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (_) => _buildMusicSheet(),
                );
              });
            },
            child: Container(),
          ),
        ),
        const Text('موسيقى',
            style: TextStyle(color: Colors.white, fontSize: 8)),
      ],
    );
  }

  Widget _buildWallpaperButton() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          backgroundColor: Colors.white,
          backgroundImage: AssetImage(AppImages.wallpaper),
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
              showModalBottomSheet(
                backgroundColor: Colors.transparent,
                context: context,
                builder: (_) => _buildWallpaperSheet(),
              );
            },
            child: Container(),
          ),
        ),
        const Text('خلفية',
            style: TextStyle(color: Colors.white, fontSize: 8)),
      ],
    );
  }

  Widget _buildLayoutButton() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          backgroundColor: Colors.white,
          backgroundImage: AssetImage(AppImages.layout),
          child: InkWell(
            onTap: () => _showLayoutDialog(),
            child: Container(),
          ),
        ),
        const Text('النمط',
            style: TextStyle(color: Colors.white, fontSize: 8)),
      ],
    );
  }

  Widget _buildAnnouncementButton() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          backgroundColor: Colors.white,
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
              _showAnnouncementDialog();
            },
            icon:
                const Icon(Icons.campaign_outlined, color: Colors.black),
          ),
        ),
        const Text('إعلان',
            style: TextStyle(color: Colors.white, fontSize: 8)),
      ],
    );
  }

  Widget _buildStopMusicButton() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          backgroundColor: Colors.white,
          child: IconButton(
            onPressed: () async {
              await controller.media.stop();
              await controller.media.pause();
            },
            icon: const Icon(Icons.music_off, color: Colors.black),
          ),
        ),
        const Text('إيقاف',
            style: TextStyle(color: Colors.white, fontSize: 8)),
      ],
    );
  }

  Widget _buildApplauseButton() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          backgroundColor: Colors.white,
          child: IconButton(
            onPressed: () {
              _sendReaction('👏');
              controller.message.send('👏👏👏');
            },
            icon: const Text('👏', style: TextStyle(fontSize: 20)),
          ),
        ),
        const Text('تصفيق',
            style: TextStyle(color: Colors.white, fontSize: 8)),
      ],
    );
  }

  Widget _buildFlyingMsgButton() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          backgroundColor: Colors.white,
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
              _sendFlyingMessage();
            },
            icon: const Icon(Icons.send, color: Colors.deepPurple),
          ),
        ),
        const Text('عائمة',
            style: TextStyle(color: Colors.white, fontSize: 8)),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // GIFT SHEETS
  // ─────────────────────────────────────────────

  Widget bottomSheet() {
    return Container(
      height: 300,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _gold.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text('الهدايا',
                style: TextStyle(
                    color: _gold,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('gifts').snapshots(),
              builder: (context, snap) {
                if (!snap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final gifts = snap.data!.docs
                    .map((d) => GiftModel(
                        d.id,
                        d.get('name'),
                        d.get('photo'),
                        d.get('price'),
                        d.get('type')))
                    .toList();

                return GridView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: gifts.length,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                  itemBuilder: (context, index) {
                    final gift = gifts[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (_) => bottomSheet2(gift),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            gift.type == "svga"
                                ? SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: SVGASimpleImage(
                                        resUrl: gift.photo))
                                : CachedNetworkImage(
                                    imageUrl: gift.photo,
                                    width: 40,
                                    height: 40),
                            const SizedBox(height: 4),
                            Text(gift.Name,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 10),
                                overflow: TextOverflow.ellipsis),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(AppImages.gold_coin,
                                    width: 12, height: 12),
                                const SizedBox(width: 2),
                                Text(gift.price,
                                    style: const TextStyle(
                                        color: _gold, fontSize: 10)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomSheet2(GiftModel gift) {
    return Container(
      height: 500,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _gold.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text('اختر المستلم',
                style: TextStyle(
                    color: _gold,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: userSeats.length,
              itemBuilder: (context, index) {
                final uid = userSeats[index];
                return StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('user')
                      .where('doc', isEqualTo: uid)
                      .snapshots(),
                  builder: (context, snap) {
                    if (!snap.hasData || snap.data!.docs.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    final data = snap.data!.docs.first;
                    final name = data.get('name') ?? '';
                    final photo = data.get('photo') ?? '';
                    final framedoc = data.get('myframe') ?? '';
                    final type = data.get('type') ?? '';
                    final agent = data.get('myagent') ?? '';
                    final friendfamily = data.get('myfamily') ?? '';

                    if (uid == _auth.currentUser!.uid) {
                      mycoin = data.get('coin') ?? '0';
                      myexp = data.get('exp') ?? '0';
                      myfamily = data.get('myfamily') ?? '';
                      return const SizedBox.shrink();
                    }

                    return StreamBuilder<QuerySnapshot>(
                      stream: _firestore
                          .collection('store')
                          .where('id', isEqualTo: framedoc)
                          .snapshots(),
                      builder: (context, snap2) {
                        String framephoto = '';
                        if (snap2.hasData && snap2.data!.docs.isNotEmpty) {
                          framephoto =
                              snap2.data!.docs.first.get('photo') ?? '';
                        }
                        return ListTile(
                          leading: Stack(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: photo.isNotEmpty
                                    ? CachedNetworkImageProvider(photo)
                                    : null,
                                backgroundColor: Colors.grey[700],
                              ),
                              if (framephoto.isNotEmpty)
                                CircleAvatar(
                                  radius: 20,
                                  backgroundImage:
                                      CachedNetworkImageProvider(framephoto),
                                  backgroundColor: Colors.transparent,
                                ),
                            ],
                          ),
                          title: Text(name,
                              style:
                                  const TextStyle(color: Colors.white)),
                          trailing: Icon(Icons.send, color: _gold),
                          onTap: () => _sendGift(
                            gift: gift,
                            receiverUID: uid,
                            receiverName: name,
                            receiverType: type,
                            receiverAgent: agent,
                            receiverFamily: friendfamily,
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sendGift({
    required GiftModel gift,
    required String receiverUID,
    required String receiverName,
    required String receiverType,
    required String receiverAgent,
    required String receiverFamily,
  }) async {
    final coins = int.tryParse(mycoin) ?? 0;
    final price = int.tryParse(gift.price) ?? 0;
    if (coins < price) {
      _showInfoDialog('رصيد غير كافٍ', 'لا تملك عملات كافية لإرسال هذه الهدية');
      return;
    }

    Navigator.pop(context);

    // Deduct from sender
    final newCoins = coins - price;
    final newExp = (int.tryParse(myexp) ?? 0) + price;
    await _firestore.collection('user').doc(_auth.currentUser!.uid).update({
      'coin': newCoins.toString(),
      'exp': newExp.toString(),
    });
    setState(() {
      mycoin = newCoins.toString();
      myexp = newExp.toString();
    });

    // Credit receiver
    final receiverSnap =
        await _firestore.collection('user').doc(receiverUID).get();
    final prevDiamonds =
        int.tryParse(receiverSnap.get('daimond') ?? '0') ?? 0;
    final prevExp2 =
        double.tryParse(receiverSnap.get('exp2') ?? '0') ?? 0.0;
    final newDiamonds = prevDiamonds + price;
    final newExp2 = prevExp2 + (newDiamonds / 4);

    await _firestore.collection('user').doc(receiverUID).update({
      'daimond': newDiamonds.toString(),
      'exp2': newExp2.toString(),
    });

    // Record gift on receiver
    await _firestore
        .collection('user')
        .doc(receiverUID)
        .collection('Mygifts')
        .add({'id': gift.docID});

    // Family tracking
    if (receiverFamily.isNotEmpty) {
      await _firestore
          .collection('family')
          .doc(receiverFamily)
          .collection('count2')
          .add({
        'user': receiverUID,
        'day': DateTime.now().day.toString(),
        'month': DateTime.now().month.toString(),
        'year': DateTime.now().year.toString(),
        'coin': gift.price,
      });
    }

    // Agency income tracking
    if (receiverType == "host" && receiverAgent.isNotEmpty) {
      final docs = "${DateTime.now().month}-${DateTime.now().day}";
      final incomeRef = _firestore
          .collection('agency')
          .doc(receiverAgent)
          .collection('users')
          .doc(receiverUID)
          .collection('income')
          .doc(docs);
      final incSnap = await incomeRef.get();
      if (!incSnap.exists) {
        await incomeRef.set({
          'date': DateTime.now().toString(),
          'hosttime': '0',
          'numberradio': '0',
          'count': gift.price,
        });
      } else {
        final prev = int.tryParse(incSnap.get('count') ?? '0') ?? 0;
        await incomeRef.update({'count': (prev + price).toString()});
      }
    }

    // Display gift in room
    setState(() {
      giftMedia = gift.photo;
      gifttype = gift.type;
    });
    await _firestore.collection('room').doc(widget.roomID).update({
      'gift': gift.photo,
      'gifttype': gift.type,
    });
    controller.message.send('أرسل ${_auth.currentUser!.displayName ?? ''} هدية ${gift.Name} إلى $receiverName 🎁');

    // Log gift history
    final docGift =
        "${DateTime.now().millisecondsSinceEpoch}-${_auth.currentUser!.uid}";
    await _firestore
        .collection('room')
        .doc(widget.roomID)
        .collection('gift')
        .doc(docGift)
        .set({
      'giftdoc': gift.docID,
      'sender': _auth.currentUser!.uid,
      'receiver': receiverUID,
      'timestamp': FieldValue.serverTimestamp(),
    });
    await _firestore
        .collection('user')
        .doc(_auth.currentUser!.uid)
        .collection('sendgift')
        .add({'giftid': gift.docID, 'target': receiverUID});

    // Top-supporters tracking (cumulative spend per sender in this room)
    await _firestore
        .collection('room')
        .doc(widget.roomID)
        .collection('supporters')
        .doc(_auth.currentUser!.uid)
        .set({
      'uid': _auth.currentUser!.uid,
      'name': _auth.currentUser!.displayName ?? widget.username,
      'photo': _auth.currentUser!.photoURL ?? '',
      'total': FieldValue.increment(price),
      'updated': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    // Clear gift display after 4 seconds
    Future.delayed(const Duration(seconds: 4), () {
      if (!mounted) return;
      setState(() {
        giftMedia = '';
        gifttype = '';
      });
      _firestore.collection('room').doc(widget.roomID).update({
        'gift': '',
        'gifttype': '',
      });
    });

    _showSuccessDialog();
  }

  // ─────────────────────────────────────────────
  // MEMBER MANAGEMENT
  // ─────────────────────────────────────────────

  void onMemberListMoreButtonPressed(ZegoUIKitUser user) {
    showModalBottomSheet(
      backgroundColor: const Color(0xFF111014),
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(32)),
      ),
      isDismissible: true,
      isScrollControlled: true,
      builder: (BuildContext context) {
        const style = TextStyle(
            color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500);

        final items = <Widget>[];

        if (_isPrivileged) {
          // Mute
          items.add(_menuItem(
            icon: Icons.mic_off,
            label: 'كتم ${user.name}',
            style: style,
            onTap: () {
              Navigator.pop(context);
              _muteUser(user);
            },
          ));
          // Invite to seat
          items.add(_menuItem(
            icon: Icons.record_voice_over,
            label: 'دعوة ${user.name} للمقعد',
            style: style,
            onTap: () {
              Navigator.pop(context);
              controller.inviteAudienceToTakeSeat(user.id);
            },
          ));
          // Kick out
          items.add(_menuItem(
            icon: Icons.exit_to_app,
            label: 'طرد ${user.name}',
            style: style,
            onTap: () async {
              Navigator.pop(context);
              await ZegoUIKit().removeUserFromRoom([user.id]);
              await _firestore
                  .collection('room')
                  .doc(widget.roomID)
                  .collection('user')
                  .doc(user.id)
                  .delete();
              _logRoomEvent('🚪 تم طرد ${user.name}');
              controller.message.send('تم طرد ${user.name} من الغرفة');
            },
          ));
        }

        if (MytypeInRoom == "owner") {
          // Toggle admin
          items.add(_menuItem(
            icon: Icons.admin_panel_settings,
            label: 'تعيين/إزالة مشرف ${user.name}',
            style: style,
            onTap: () {
              Navigator.pop(context);
              _toggleAdminRole(user.id, user.name);
            },
          ));
          // Block
          items.add(_menuItem(
            icon: Icons.block,
            label: 'حظر ${user.name}',
            style: const TextStyle(
                color: Colors.redAccent,
                fontSize: 14,
                fontWeight: FontWeight.w500),
            onTap: () {
              Navigator.pop(context);
              _blockUser(user.id, user.name);
            },
          ));
        }

        items.add(_menuItem(
          icon: Icons.close,
          label: 'إلغاء',
          style: style,
          onTap: () => Navigator.pop(context),
        ));

        return AnimatedPadding(
          padding: MediaQuery.of(context).viewInsets,
          duration: const Duration(milliseconds: 50),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ListView(
              shrinkWrap: true,
              children: items,
            ),
          ),
        );
      },
    );
  }

  Widget _menuItem({
    required IconData icon,
    required String label,
    required TextStyle style,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: style.color),
      title: Text(label, style: style),
      onTap: onTap,
    );
  }

  void _toggleAdminRole(String userId, String userName) {
    _firestore
        .collection('room')
        .doc(widget.roomID)
        .collection('user')
        .doc(userId)
        .get()
        .then((snap) {
      final currentType = snap.get('type') ?? 'normal';
      final newType = currentType == 'admin' ? 'normal' : 'admin';
      _firestore
          .collection('room')
          .doc(widget.roomID)
          .collection('user')
          .doc(userId)
          .update({'type': newType}).then((_) {
        controller.message.send(newType == 'admin'
            ? 'تم تعيين $userName كمشرف 🛡️'
            : 'تم إزالة $userName من المشرفين');
      });
    });
  }

  void _blockUser(String userId, String userName) {
    _firestore
        .collection('room')
        .doc(widget.roomID)
        .collection('block')
        .doc(userId)
        .set({'id': userId}).then((_) {
      ZegoUIKit().removeUserFromRoom([userId]).then((_) {
        _firestore
            .collection('room')
            .doc(widget.roomID)
            .collection('user')
            .doc(userId)
            .delete();
        _logRoomEvent('🚫 تم حظر $userName');
        controller.message.send('تم حظر $userName من الغرفة 🚫');
      });
    });
  }

  /// Mutes a user's mic and records them in the room muted list.
  void _muteUser(ZegoUIKitUser user) {
    controller.turnMicrophoneOn(false, userID: user.id);
    _firestore
        .collection('room')
        .doc(widget.roomID)
        .collection('muted')
        .doc(user.id)
        .set({'name': user.name, 'photo': ''});
    _logRoomEvent('🔇 تم كتم ${user.name}');
  }

  /// Appends an entry to the room activity log (auto-pruned client-side view).
  void _logRoomEvent(String text) {
    _firestore
        .collection('room')
        .doc(widget.roomID)
        .collection('events')
        .add({
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // ─────────────────────────────────────────────
  // ADMIN & SECURITY PANEL
  // ─────────────────────────────────────────────

  Widget _buildAdminButton() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          backgroundColor: Colors.white,
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
              _showAdminPanel();
            },
            icon: const Icon(Icons.shield_outlined, color: Colors.black),
          ),
        ),
        const Text('إدارة',
            style: TextStyle(color: Colors.white, fontSize: 8)),
      ],
    );
  }

  void _showAdminPanel() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1A1A2E),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: DefaultTabController(
          length: 4,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Column(
              children: [
                _handle(),
                TabBar(
                  isScrollable: true,
                  indicatorColor: _gold,
                  labelColor: _gold,
                  unselectedLabelColor: Colors.white54,
                  tabs: const [
                    Tab(text: 'الميكروفون'),
                    Tab(text: 'الطلبات'),
                    Tab(text: 'المكتومون'),
                    Tab(text: 'السجل'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildMicModeTab(),
                      _buildSeatRequestsTab(),
                      _buildMutedTab(),
                      _buildEventLogTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMicModeTab() {
    return StatefulBuilder(
      builder: (context, setSheet) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('وضع الميكروفون',
                  style: TextStyle(color: Colors.white, fontSize: 15)),
              const SizedBox(height: 12),
              _micModeOption('free', 'حر', 'أي عضو يصعد المقعد مباشرة',
                  Icons.lock_open, setSheet),
              const SizedBox(height: 8),
              _micModeOption('request', 'بطلب', 'يحتاج العضو موافقة المالك للصعود',
                  Icons.front_hand, setSheet),
            ],
          ),
        );
      },
    );
  }

  Widget _micModeOption(String id, String name, String desc, IconData icon,
      void Function(void Function()) setSheet) {
    final isSelected = micMode == id;
    return GestureDetector(
      onTap: () {
        _firestore
            .collection('room')
            .doc(widget.roomID)
            .update({'micMode': id}).then((_) {
          setState(() => micMode = id);
          setSheet(() {});
          controller.message.send(
              id == 'request' ? '🎙️ الميك أصبح بطلب' : '🎙️ الميك أصبح حراً');
        });
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? _gold.withOpacity(0.15) : Colors.white10,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: isSelected ? _gold : Colors.transparent, width: 1.5),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? _gold : Colors.white54),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  Text(desc,
                      style: const TextStyle(
                          color: Colors.white54, fontSize: 11)),
                ],
              ),
            ),
            if (isSelected) const Icon(Icons.check_circle, color: _gold),
          ],
        ),
      ),
    );
  }

  Widget _buildSeatRequestsTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('room')
          .doc(widget.roomID)
          .collection('seatRequests')
          .snapshots(),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final docs = snap.data!.docs;
        if (docs.isEmpty) {
          return const Center(
              child: Text('لا توجد طلبات صعود',
                  style: TextStyle(color: Colors.white54)));
        }
        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, i) {
            final d = docs[i];
            final uid = d.get('uid') ?? d.id;
            final name = d.get('name') ?? '';
            final photo = d.get('photo') ?? '';
            return ListTile(
              leading: CircleAvatar(
                radius: 18,
                backgroundImage: photo.toString().isNotEmpty
                    ? CachedNetworkImageProvider(photo)
                    : null,
                backgroundColor: Colors.grey[700],
              ),
              title: Text(name, style: const TextStyle(color: Colors.white)),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.check_circle,
                        color: Color(0xFF4CFF6A)),
                    onPressed: () {
                      controller.inviteAudienceToTakeSeat(uid);
                      _firestore
                          .collection('room')
                          .doc(widget.roomID)
                          .collection('seatRequests')
                          .doc(d.id)
                          .delete();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.cancel, color: Colors.redAccent),
                    onPressed: () {
                      _firestore
                          .collection('room')
                          .doc(widget.roomID)
                          .collection('seatRequests')
                          .doc(d.id)
                          .delete();
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMutedTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('room')
          .doc(widget.roomID)
          .collection('muted')
          .snapshots(),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final docs = snap.data!.docs;
        if (docs.isEmpty) {
          return const Center(
              child: Text('لا يوجد مكتومون',
                  style: TextStyle(color: Colors.white54)));
        }
        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, i) {
            final d = docs[i];
            final name = d.get('name') ?? '';
            final photo = d.get('photo') ?? '';
            final uid = d.id;
            return ListTile(
              leading: CircleAvatar(
                radius: 18,
                backgroundImage: photo.toString().isNotEmpty
                    ? CachedNetworkImageProvider(photo)
                    : null,
                backgroundColor: Colors.grey[700],
              ),
              title: Text(name, style: const TextStyle(color: Colors.white)),
              trailing: TextButton(
                onPressed: () {
                  controller.turnMicrophoneOn(true, userID: uid);
                  _firestore
                      .collection('room')
                      .doc(widget.roomID)
                      .collection('muted')
                      .doc(uid)
                      .delete();
                },
                child: const Text('فك الكتم',
                    style: TextStyle(color: _gold)),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEventLogTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('room')
          .doc(widget.roomID)
          .collection('events')
          .orderBy('timestamp', descending: true)
          .limit(40)
          .snapshots(),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final docs = snap.data!.docs;
        if (docs.isEmpty) {
          return const Center(
              child: Text('لا توجد أحداث',
                  style: TextStyle(color: Colors.white54)));
        }
        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, i) {
            final text = docs[i].get('text') ?? '';
            return ListTile(
              dense: true,
              leading: const Icon(Icons.circle, color: _gold, size: 8),
              title: Text(text,
                  style: const TextStyle(color: Colors.white, fontSize: 13)),
            );
          },
        );
      },
    );
  }

  // ─────────────────────────────────────────────
  // DIALOGS
  // ─────────────────────────────────────────────

  void _showSetPasswordDialog() {
    for (var c in _passControllers) {
      c.clear();
    }
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Text('تعيين كلمة سر',
            style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                6,
                (i) => SizedBox(
                  width: 38,
                  child: TextField(
                    controller: _passControllers[i],
                    focusNode: _focusNodes[i],
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    onChanged: (v) {
                      if (v.isNotEmpty && i < 5) {
                        _focusNodes[i + 1].requestFocus();
                      } else if (v.isEmpty && i > 0) {
                        _focusNodes[i - 1].requestFocus();
                      }
                    },
                    decoration: InputDecoration(
                      counterText: '',
                      filled: true,
                      fillColor: Colors.white10,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            BorderSide(color: _gold.withOpacity(0.5)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: _gold),
              onPressed: () {
                final newPass =
                    _passControllers.map((c) => c.text).join();
                if (newPass.length < 6) return;
                _firestore
                    .collection('room')
                    .doc(widget.roomID)
                    .update({'password': newPass}).then((_) {
                  setState(() => pass = newPass);
                  controller.message.send('تم تعيين كلمة سر للغرفة 🔐');
                  Navigator.pop(context);
                });
              },
              child: const Text('حفظ', style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }

  void _removePassword() {
    _firestore
        .collection('room')
        .doc(widget.roomID)
        .update({'password': ''}).then((_) {
      setState(() => pass = '');
      controller.message.send('تم إزالة كلمة السر من الغرفة 🔓');
    });
  }

  void _showAnnouncementDialog() {
    final announcementCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: Row(
          children: const [
            Icon(Icons.campaign, color: _gold),
            SizedBox(width: 8),
            Text('إعلان الغرفة',
                style: TextStyle(color: Colors.white)),
          ],
        ),
        content: TextField(
          controller: announcementCtrl,
          maxLines: 3,
          maxLength: 200,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'اكتب إعلانك هنا...',
            hintStyle: const TextStyle(color: Colors.white38),
            filled: true,
            fillColor: Colors.white10,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:
                const Text('إلغاء', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: _gold),
            onPressed: () {
              final text = announcementCtrl.text.trim();
              if (text.isEmpty) return;
              controller.message.send('📢 إعلان: $text');
              _firestore.collection('room').doc(widget.roomID).update({
                'announcement': text,
                'announcementTime': FieldValue.serverTimestamp(),
              });
              Navigator.pop(context);
            },
            child: const Text('إرسال',
                style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  void _showUpdateBio() {
    final bioCtrl = TextEditingController(text: bio);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Text('تحديث عنوان الغرفة',
            style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: bioCtrl,
          maxLength: 60,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'ادخل عنوان الغرفة',
            hintStyle: const TextStyle(color: Colors.white38),
            filled: true,
            fillColor: Colors.white10,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:
                const Text('إلغاء', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: _gold),
            onPressed: () {
              final newBio = bioCtrl.text.trim();
              if (newBio.isEmpty) return;
              _firestore
                  .collection('room')
                  .doc(widget.roomID)
                  .update({'bio': newBio}).then((_) {
                setState(() => bio = newBio);
                Navigator.pop(context);
              });
            },
            child: const Text('تحديث',
                style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  void _showLayoutDialog() {
    Navigator.maybePop(context);
    const layouts = [
      {'id': 'party', 'name': 'بارتي', 'icon': '🎉'},
      {'id': 'podcast', 'name': 'بودكاست', 'icon': '🎙️'},
      {'id': 'wedding', 'name': 'زفّة / VIP', 'icon': '💍'},
      {'id': 'debate', 'name': 'مناظرة', 'icon': '⚔️'},
      {'id': 'singing', 'name': 'غناء', 'icon': '🎤'},
    ];
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A2E),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (sheetContext) => Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _handle(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text('نمط الغرفة',
                    style: TextStyle(
                        color: _gold,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
              ),
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 3,
                padding: const EdgeInsets.all(12),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: layouts.map((l) {
                  final isSelected = roomLayoutType == l['id'];
                  return GestureDetector(
                    onTap: () {
                      _firestore
                          .collection('room')
                          .doc(widget.roomID)
                          .update({'layoutType': l['id']}).then((_) {
                        setState(() => roomLayoutType = l['id']!);
                        Navigator.pop(sheetContext);
                        if (l['id'] == 'party') _showSeatCountDialog();
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? _gold.withOpacity(0.2) : Colors.white10,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: isSelected ? _gold : Colors.transparent,
                            width: 1.5),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(l['icon']!, style: const TextStyle(fontSize: 26)),
                          const SizedBox(height: 6),
                          Text(l['name']!,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 12)),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              if (roomLayoutType == 'party')
                TextButton.icon(
                  onPressed: () {
                    Navigator.pop(sheetContext);
                    _showSeatCountDialog();
                  },
                  icon: const Icon(Icons.event_seat, color: _gold),
                  label: const Text('عدد المقاعد',
                      style: TextStyle(color: _gold)),
                ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  void _showSeatCountDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Text('عدد المقاعد',
            style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['9', '11', '13'].map((count) {
            final isSelected = layoutSeats == count;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSelected ? _gold : Colors.white24,
                  minimumSize: const Size(double.infinity, 44),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  _firestore
                      .collection('room')
                      .doc(widget.roomID)
                      .update({'seat': count}).then((_) {
                    setState(() => layoutSeats = count);
                    Navigator.pop(context);
                  });
                },
                child: Text('$count مقاعد',
                    style: TextStyle(
                        color: isSelected ? Colors.black : Colors.white)),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // WALLPAPER & MUSIC SHEETS
  // ─────────────────────────────────────────────

  Widget _buildWallpaperSheet() {
    return Container(
      height: 280,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _gold.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text('اختر خلفية',
                style: TextStyle(
                    color: _gold,
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('user')
                  .doc(_auth.currentUser!.uid)
                  .collection('mylook')
                  .where('cat', isEqualTo: 'wallpaper')
                  .snapshots(),
              builder: (context, snap) {
                if (!snap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final ids = snap.data!.docs
                    .map((d) => d.get('id') as String)
                    .toList();
                if (ids.isEmpty) {
                  return const Center(
                      child: Text('لا توجد خلفيات',
                          style: TextStyle(color: Colors.white54)));
                }
                return GridView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: ids.length,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                  itemBuilder: (context, index) {
                    return StreamBuilder<QuerySnapshot>(
                      stream: _firestore
                          .collection('store')
                          .where('id', isEqualTo: ids[index])
                          .snapshots(),
                      builder: (context, snap2) {
                        String photo = '';
                        if (snap2.hasData &&
                            snap2.data!.docs.isNotEmpty) {
                          photo = snap2.data!.docs.first.get('photo') ?? '';
                        }
                        return GestureDetector(
                          onTap: () async {
                            await _firestore
                                .collection('room')
                                .doc(widget.roomID)
                                .update({'wallpaper': photo});
                            setState(() => wallpaper = photo);
                            controller.message.send('تم تغيير خلفية الغرفة');
                            Navigator.pop(context);
                          },
                          child: Container(
                            margin: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: wallpaper == photo
                                      ? _gold
                                      : Colors.transparent,
                                  width: 2),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: photo.isNotEmpty
                                  ? CachedNetworkImage(
                                      imageUrl: photo, fit: BoxFit.cover)
                                  : const SizedBox.shrink(),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMusicSheet() {
    return Container(
      height: 280,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _gold.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text('قائمة الموسيقى',
                style: TextStyle(
                    color: _gold,
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: musicPath.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.music_note, color: _gold),
                  title: Text(musicname[index],
                      style: const TextStyle(color: Colors.white)),
                  trailing: IconButton(
                    icon:
                        const Icon(Icons.play_arrow, color: Colors.green),
                    onPressed: () {
                      controller.media
                          .play(filePathOrURL: musicPath[index]);
                      controller.message
                          .send('يتم تشغيل موسيقى 🎵');
                      Navigator.pop(context);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // FEEDBACK DIALOGS
  // ─────────────────────────────────────────────

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.greenAccent, size: 60),
            const SizedBox(height: 12),
            const Text('تم إرسال الهدية بنجاح! 🎁',
                style: TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
    Future.delayed(const Duration(seconds: 2),
        () => Navigator.of(context, rootNavigator: true).pop());
  }

  void _showInfoDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        content: Text(message,
            style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('حسناً', style: TextStyle(color: _gold)),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // HELPERS
  // ─────────────────────────────────────────────

  Widget _handle() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.white30,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

// ─── VIP entrance data model ───
class _VipEntry {
  final String name;
  final String photo;
  final int vip;
  const _VipEntry({required this.name, required this.photo, required this.vip});
}

// ─── Animated VIP welcome banner ───
class _VipWelcomeBanner extends StatefulWidget {
  final _VipEntry entry;
  const _VipWelcomeBanner({required this.entry});
  @override
  State<_VipWelcomeBanner> createState() => _VipWelcomeBannerState();
}

class _VipWelcomeBannerState extends State<_VipWelcomeBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<Offset> _slide;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _slide = Tween<Offset>(begin: const Offset(-1.2, 0), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFFFD700);
    return SlideTransition(
      position: _slide,
      child: FadeTransition(
        opacity: _fade,
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: gold, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: gold.withOpacity(0.4),
                  blurRadius: 12,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: widget.entry.photo.isNotEmpty
                      ? CachedNetworkImageProvider(widget.entry.photo)
                      : null,
                  backgroundColor: Colors.grey[700],
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 1),
                            decoration: BoxDecoration(
                              color: gold,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text('VIP ${widget.entry.vip}',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              widget.entry.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const Text('دخل الغرفة بأناقة ✨',
                          style:
                              TextStyle(color: Colors.white70, fontSize: 10)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Flying VIP message ───
class _FlyingMessage {
  final int id;
  final String name;
  final String text;
  final int vip;
  const _FlyingMessage(
      {required this.id,
      required this.name,
      required this.text,
      required this.vip});
}

class _FlyingMessageWidget extends StatefulWidget {
  final _FlyingMessage message;
  final double screenWidth;
  const _FlyingMessageWidget(
      {super.key, required this.message, required this.screenWidth});
  @override
  State<_FlyingMessageWidget> createState() => _FlyingMessageWidgetState();
}

class _FlyingMessageWidgetState extends State<_FlyingMessageWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 6));
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.linear);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  List<Color> get _bubbleColors {
    switch (widget.message.vip) {
      case 4:
        return [const Color(0xFFFF1744), const Color(0xFFD500F9)];
      case 3:
        return [const Color(0xFF8E2DE2), const Color(0xFF4A00E0)];
      case 2:
        return [const Color(0xFF00C6FF), const Color(0xFF0072FF)];
      default:
        return [const Color(0xFFFFA726), const Color(0xFFFF7043)];
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, child) {
        // Travel from right edge to off the left edge.
        final dx = widget.screenWidth -
            (_anim.value * (widget.screenWidth + 320));
        return Transform.translate(offset: Offset(dx, 0), child: child);
      },
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: _bubbleColors),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: _bubbleColors.first.withOpacity(0.5),
                blurRadius: 8,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text('VIP ${widget.message.vip}',
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 9,
                        fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 6),
              Text('${widget.message.name}: ',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold)),
              Text(widget.message.text,
                  style: const TextStyle(color: Colors.white, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Floating emoji data model ───
class _FloatingEmoji {
  final int id;
  final String emoji;
  final double left;
  const _FloatingEmoji({required this.id, required this.emoji, required this.left});
}

// ─── Animated floating emoji widget ───
class _FloatingEmojiWidget extends StatefulWidget {
  final String emoji;
  const _FloatingEmojiWidget({required this.emoji});
  @override
  State<_FloatingEmojiWidget> createState() => _FloatingEmojiWidgetState();
}

class _FloatingEmojiWidgetState extends State<_FloatingEmojiWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _opacity;
  late Animation<double> _offset;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1800));
    _opacity = Tween<double>(begin: 1, end: 0).animate(
        CurvedAnimation(parent: _ctrl, curve: const Interval(0.6, 1.0)));
    _offset = Tween<double>(begin: 0, end: -80).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => Transform.translate(
        offset: Offset(0, _offset.value),
        child: Opacity(
          opacity: _opacity.value,
          child: Text(widget.emoji, style: const TextStyle(fontSize: 28)),
        ),
      ),
    );
  }
}
