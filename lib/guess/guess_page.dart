import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import '../storage/sp_storage.dart';
import 'result_notice.dart';
import 'package:flutter/services.dart';
import 'guess_bar.dart';

class GuessPage extends StatefulWidget {
  const GuessPage({super.key, required this.title});

  final String title;

  @override
  State<GuessPage> createState() => _GuessPageState();
}



class _GuessPageState extends State<GuessPage> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;

  int _value = 0;
  bool _guessing = false;
  bool? _isBig;
  Random _random = Random();
  TextEditingController _guessCtrl = TextEditingController();
  @override

  void initState() {
    // 略...
    _initConfig();
  }

  void _generateRandomValue() {
    setState(() {
      _guessing = true;
      _value = _random.nextInt(100);
    });
  }
  void _initConfig() async {
    Map<String, dynamic> config = await SpStorage.instance.readGuessConfig();
    _guessing = config['guessing'] ?? false;
    _value = config['value'] ?? 0;
    setState(() {

    });
  }

  void _onCheck(){
    print("=====Check:目标数值:$_value=====${_guessCtrl.text}============");
    int? guessValue = int.tryParse(_guessCtrl.text);
    if (!_guessing || guessValue == null) return;
    //猜对了
    if (guessValue == _value) {
      print('猜对了');
      setState(() {
        _isBig = null;
        _guessing = false;
      });
      return;
    }
    // 猜错了
    setState(() {
      _isBig = guessValue > _value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GuessAppBar(
        onCheck: _onCheck,
        controller:_guessCtrl,
      ),
      body: Stack(
        children: [
          Container(color: Colors.grey),
          Column(
            children: [
            Flexible(
            flex: _value,
            child: ResultNotice(color: Colors.redAccent,  info: _isBig == true ? "大了" : ""),
          ),
          Flexible(
            flex: 100 - _value,
            child: ResultNotice(color: Colors.blueAccent, info: _isBig == false ? "小了" : ""),
          ),
        ],
      ),
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('按下随机生成的数字:',style: TextStyle(color:  Colors.purple, fontSize: 16)),
            Text(
              _guessing ? '**' : '$_value',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      ],
    ),
    floatingActionButton: FloatingActionButton(
    onPressed: _guessing ? null : _generateRandomValue,
    backgroundColor: _guessing ? Colors.grey : Colors.blue,
    tooltip: 'Increment',
    child: const Icon(Icons.generating_tokens_outlined),
    ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
