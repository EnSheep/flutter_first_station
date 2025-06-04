import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter_first_station/muyu/record_history.dart';
import '../storage/sp_storage.dart';
import 'animation_text.dart';
import 'count_panel.dart';
import 'models/audio_option.dart';
import 'models/image_option.dart';
import 'models/merit_record.dart';
import 'muyu_img.dart';
import './options/select_image.dart';
import 'options/select_audio.dart';
import 'package:uuid/uuid.dart';

class MuyuPage extends StatefulWidget{
  const MuyuPage({Key?key}) :super(key:key);

  @override
  State<MuyuPage> createState() => _MuyuPageState();
}
class _MuyuPageState extends State<MuyuPage> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _initAudioPool();
    _initConfig();
  }
  void saveConfig() {
    SpStorage.instance.saveMuYUConfig(
      counter: _counter,
      activeImageIndex: _activeImageIndex,
      activeAudioIndex: _activeAudioIndex,
    );
  }

  int _counter = 0;
  int _cruValue = 0;
  AudioPool? pool; // 音频播放控制器
  final List<ImageOption> imageOptions = const [
    ImageOption('基础版','assets/images/muyu.png',1,3),
    ImageOption('尊享版','assets/images/muyu_2.png',3,6),
  ];
  final List<AudioOption> audioOptions = const [
    AudioOption('音效1', 'muyu_1.mp3'),
    AudioOption('音效2', 'muyu_2.mp3'),
    AudioOption('音效3', 'muyu_3.mp3'),
  ];
  List<MeritRecord> _records = [];
  int _activeImageIndex = 0;
  int _activeAudioIndex = 0;
  final Uuid uuid = Uuid();
  final Random _random = Random();

  void _onTapSwitchAudio() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return AudioOptionPanel(
          audioOptions: audioOptions,
          activeIndex: _activeAudioIndex,
          onSelect: _onSelectAudio,
        );
      },
    );
  }
  void _initConfig() async{
    Map<String,dynamic> config = await SpStorage.instance.readMuYUConfig();
    _counter = config['counter']??0;
    _activeImageIndex = config['activeImageIndex']??0;
    _activeAudioIndex = config['activeAudioIndex']??0;
    setState(() {
    });
  }
  void _onTapSwitchImage() {
    print("弹出弹窗");
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return ImageOptionPanel(
          imageOptions: imageOptions,
          activeIndex: _activeImageIndex,
          onSelect: _onSelectImage,
        );
      },
    );
  }
  void _onSelectImage(int value) {
    Navigator.of(context).pop();
    if(value == _activeImageIndex) return;
    setState(() {
      _activeImageIndex = value;
    });
  }
  void _onSelectAudio(int value) async{
    Navigator.of(context).pop();
    if (value == _activeAudioIndex) return;
    _activeAudioIndex = value;
    pool = await FlameAudio.createPool(
      activeAudio,
      maxPlayers: 1,
    );
  }
  void _onKnock() {
    pool?.start();
    setState(() {
      _cruValue = knockValue;
      // int addCount = 1 + _random.nextInt(3);
      _counter += _cruValue;
      String id = uuid.v4();
      _records.add(MeritRecord(
        id,
        DateTime.now().millisecondsSinceEpoch,
        _cruValue,
        activeImage,
        audioOptions[_activeAudioIndex].name,
      ));
    });
  }

  String get activeImage => imageOptions[_activeImageIndex].src;
  String get activeAudio => audioOptions[_activeAudioIndex].src;

  int get knockValue {
    int min = imageOptions[_activeImageIndex].min;
    int max = imageOptions[_activeImageIndex].max;
    return min + _random.nextInt(max+1 - min);
  }

  void _initAudioPool() async {
    pool = await FlameAudio.createPool(
      'muyu_1.mp3',
      maxPlayers: 4,
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF12151C),
        appBar: AppBar(
            elevation: 0,
            backgroundColor: const Color(0xFF12151C),
            titleTextStyle: const TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),
            iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("电子木鱼"),
        actions: [
          IconButton(onPressed: _toHistory,icon: const Icon(Icons.settings))
        ],
      ),
      body: Container(
        child:Column(
          children: [
            Expanded(
              child: CountPanel(
                  count:_counter,
                  onTapSwitchAudio:_onTapSwitchAudio,
                  onTapSwitchImage:_onTapSwitchImage
              )
            ),
            Expanded(
              child:Stack(
                alignment: Alignment.topCenter,
                children:[
                  MuyuAssetsImage(
                      image: activeImage,
                      onTap:_onKnock
                  ),
                  if (_cruValue != 0) AnimateText(text: '功德+$_cruValue')
                ]
              )
            ),
          ],
        ),
      )
    );
  }

  Widget _buildImage() {
    return Center(
        child: Image.asset(
          'assets/images/muyu.png',
          height: 200, //图片高度
        ));
  }

  void _toHistory() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RecordHistory(
          records: _records.reversed.toList(),
        ),
      ),
    );
  }
}
