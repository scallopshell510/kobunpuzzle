import 'package:flutter/material.dart';
import '../models/auxiliary_verb.dart';

class FullPuzzleScreen extends StatefulWidget {
  final List<AuxiliaryVerb> verbs;
  final PuzzleMode mode;

  const FullPuzzleScreen({
    super.key,
    required this.verbs,
    required this.mode,
  });

  @override
  State<FullPuzzleScreen> createState() => _FullPuzzleScreenState();
}

class _FullPuzzleScreenState extends State<FullPuzzleScreen> {
  final List<String> _formNames = ['未然', '連用', '終止', '連体', '已然', '命令'];

  final Map<String, String?> _userAnswers = {};
  final Map<String, String> _correctFormAnswers = {};
  late List<String> _remainingPieces;

  // タップ選択用の状態管理
  String? _selectedPiece;
  int? _selectedPieceIndex;

  @override
  void initState() {
    super.initState();
    _initGameData();
  }

  void _initGameData() {
    _userAnswers.clear();
    _correctFormAnswers.clear();
    _selectedPiece = null;
    _selectedPieceIndex = null;
    List<String> pieces = [];

    for (int i = 0; i < widget.verbs.length; i++) {
      if (widget.mode == PuzzleMode.formsOnly || widget.mode == PuzzleMode.both) {
        for (String form in _formNames) {
          String key = 'form_${i}_$form';
          String val = widget.verbs[i].forms[form] ?? '○';
          _correctFormAnswers[key] = val;
          _userAnswers[key] = null;
          pieces.add(val);
        }
      }

      if (widget.mode == PuzzleMode.meaningOnly || widget.mode == PuzzleMode.both) {
        for (int mIndex = 0; mIndex < widget.verbs[i].meanings.length; mIndex++) {
          String key = 'meaning_${i}_$mIndex';
          String val = widget.verbs[i].meanings[mIndex];
          _userAnswers[key] = null;
          pieces.add(val);
        }
      }
    }

    pieces.shuffle();
    setState(() {
      _remainingPieces = pieces;
    });
  }

  void _checkCompletion() {
    if (_remainingPieces.isEmpty) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (!mounted) return;
        _showSuccessDialog();
      });
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Column(
            children: [
              Text('🎉', style: TextStyle(fontSize: 40)),
              SizedBox(height: 8),
              Text(
                'おめでとうございます！',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          content: Text(
            '選択した ${widget.verbs.length} 種の助動詞パズルをすべて正解しました！',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14),
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2B2B2B),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _initGameData();
              },
              child: const Text('もう一度遊ぶ'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC84B31),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text('範囲選択へ戻る'),
            ),
          ],
        );
      },
    );
  }

  String _toVerticalText(String text) {
    if (text.contains('\n')) {
      return text;
    }
    return text.split('').join('\n');
  }

  // 活用形セルのタップ処理
  void _onTapFormCell({required String key, required String correctVal}) {
    if (_selectedPiece == null) return;

    if (_selectedPiece == correctVal) {
      setState(() {
        _userAnswers[key] = _selectedPiece;
        _remainingPieces.removeAt(_selectedPieceIndex!);
        _selectedPiece = null;
        _selectedPieceIndex = null;
      });
      _checkCompletion();
    } else {
      _showWrongFeedback();
    }
  }

  // 意味セルのタップ処理
  void _onTapMeaningCell({
    required String key,
    required int vIndex,
    required List<String> validMeanings,
  }) {
    if (_selectedPiece == null) return;

    List<String?> currentPlacedList = List.generate(
      validMeanings.length,
      (i) => _userAnswers['meaning_${vIndex}_$i'],
    );

    if (validMeanings.contains(_selectedPiece) &&
        !currentPlacedList.contains(_selectedPiece)) {
      setState(() {
        _userAnswers[key] = _selectedPiece;
        _remainingPieces.removeAt(_selectedPieceIndex!);
        _selectedPiece = null;
        _selectedPieceIndex = null;
      });
      _checkCompletion();
    } else {
      _showWrongFeedback();
    }
  }

  void _showWrongFeedback() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('違います！正しい場所をタップしてください'),
        duration: Duration(milliseconds: 600),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String modeName = widget.mode == PuzzleMode.formsOnly
        ? '活用形'
        : widget.mode == PuzzleMode.meaningOnly
            ? '意味（順不同）'
            : '両方';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B2B2B),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text('パズル（$modeName・${widget.verbs.length}種）',
            style: const TextStyle(color: Colors.white, fontSize: 16)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _initGameData,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: InteractiveViewer(
                constrained: false,
                scaleEnabled: true,
                minScale: 0.3,
                maxScale: 2.5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Table(
                    defaultColumnWidth: const FixedColumnWidth(65),
                    border: TableBorder.all(color: Colors.black87, width: 1),
                    children: [
                      // ヘッダー1: 接続
                      TableRow(
                        decoration: const BoxDecoration(color: Color(0xFFE8E2D5)),
                        children: [
                          _buildCell('接続', isHeader: true),
                          ...widget.verbs.map((v) =>
                              _buildCell(v.connection, isHeader: true, fontSize: 10)),
                        ],
                      ),
                      // ヘッダー2: 基本形
                      TableRow(
                        decoration: const BoxDecoration(color: Color(0xFFF0CB85)),
                        children: [
                          _buildCell('基本形', isHeader: true),
                          ...widget.verbs.map((v) =>
                              _buildCell(v.base, isHeader: true, isBold: true, fontSize: 14)),
                        ],
                      ),
                      // 活用形行（未然〜命令）
                      ..._formNames.map((formName) {
                        return TableRow(
                          children: [
                            Container(
                              color: const Color(0xFFC84B31),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              alignment: Alignment.center,
                              child: Text(
                                _toVerticalText(formName),
                                style: const TextStyle(
                                    color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                            ...List.generate(widget.verbs.length, (vIndex) {
                              String formVal = widget.verbs[vIndex].forms[formName] ?? '○';

                              if (widget.mode == PuzzleMode.meaningOnly) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  constraints: const BoxConstraints(minHeight: 65),
                                  color: Colors.white,
                                  child: Center(
                                    child: Text(_toVerticalText(formVal),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 11, height: 1.05)),
                                  ),
                                );
                              }

                              String key = 'form_${vIndex}_$formName';
                              return _buildFormCell(key: key, correctVal: formVal);
                            }),
                          ],
                        );
                      }),
                      // フッター: 意味
                      TableRow(
                        decoration: const BoxDecoration(color: Color(0xFFE8E2D5)),
                        children: [
                          _buildCell('意味', isHeader: true),
                          ...List.generate(widget.verbs.length, (vIndex) {
                            List<String> validMeanings = widget.verbs[vIndex].meanings;

                            return Column(
                              children: List.generate(validMeanings.length, (mIndex) {
                                String key = 'meaning_${vIndex}_$mIndex';

                                if (widget.mode == PuzzleMode.formsOnly) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(vertical: 4),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.black26,
                                          width: mIndex == validMeanings.length - 1 ? 0 : 0.5,
                                        ),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(_toVerticalText(validMeanings[mIndex]),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(fontSize: 10, height: 1.05)),
                                    ),
                                  );
                                }

                                return Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.black26,
                                        width: mIndex == validMeanings.length - 1 ? 0 : 0.5,
                                      ),
                                    ),
                                  ),
                                  child: _buildMeaningCell(
                                    key: key,
                                    vIndex: vIndex,
                                    validMeanings: validMeanings,
                                  ),
                                );
                              }),
                            );
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Divider(height: 1, color: Colors.black26),
            // 下部：ピース置き場（余白を追加）
            Container(
              height: 115,
              color: const Color(0xFF2B2B2B),
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 12, bottom: 6),
                    child: Text(
                      '【 ピース 】 タップで選択して、配置したいマスをタップしてください',
                      style: TextStyle(color: Colors.white, fontSize: 11),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _remainingPieces.length,
                      itemBuilder: (context, index) {
                        String piece = _remainingPieces[index];
                        bool isSelected = (_selectedPieceIndex == index);

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  _selectedPiece = null;
                                  _selectedPieceIndex = null;
                                } else {
                                  _selectedPiece = piece;
                                  _selectedPieceIndex = index;
                                }
                              });
                            },
                            child: _buildPieceWidget(piece, isSelected: isSelected),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            // --------------------------------------------------
            // ★ 広告表示エリア & 下部セーフエリア余白
            // --------------------------------------------------
            Container(
              width: double.infinity,
              height: 50,
              color: const Color(0xFFE0E0E0),
              alignment: Alignment.center,
              child: const Text(
                'スポンサーリンク / 広告エリア',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12), // iPadホームバー誤作動防止のための余白
          ],
        ),
      ),
    );
  }

  Widget _buildFormCell({
    required String key,
    required String correctVal,
  }) {
    String? placed = _userAnswers[key];
    bool isCorrect = (placed == correctVal);

    return InkWell(
      onTap: placed == null
          ? () => _onTapFormCell(key: key, correctVal: correctVal)
          : null,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4),
        constraints: const BoxConstraints(minHeight: 65),
        color: isCorrect ? Colors.lightGreen.shade200 : Colors.white,
        child: Center(
          child: placed != null
              ? Text(
                  _toVerticalText(placed),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                    color: Colors.green.shade900,
                    height: 1.05,
                  ),
                )
              : const Text('・', style: TextStyle(color: Colors.grey)),
        ),
      ),
    );
  }

  Widget _buildMeaningCell({
    required String key,
    required int vIndex,
    required List<String> validMeanings,
  }) {
    String? placed = _userAnswers[key];
    bool isCorrect = placed != null && validMeanings.contains(placed);

    return InkWell(
      onTap: placed == null
          ? () => _onTapMeaningCell(
                key: key,
                vIndex: vIndex,
                validMeanings: validMeanings,
              )
          : null,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4),
        constraints: const BoxConstraints(minHeight: 65),
        color: isCorrect ? Colors.lightGreen.shade200 : Colors.white,
        child: Center(
          child: placed != null
              ? Text(
                  _toVerticalText(placed),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                    color: Colors.green.shade900,
                    height: 1.05,
                  ),
                )
              : const Text('・', style: TextStyle(color: Colors.grey)),
        ),
      ),
    );
  }

  Widget _buildCell(String text,
      {bool isHeader = false, bool isBold = false, double fontSize = 11}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 1),
      alignment: Alignment.center,
      child: Text(
        _toVerticalText(text),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          color: const Color(0xFF2B2B2B),
          height: 1.05,
        ),
      ),
    );
  }

  Widget _buildPieceWidget(String text, {bool isSelected = false}) {
    bool isMultiLine = text.contains('\n');
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: isMultiLine ? 56 : 42,
      height: 72,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFC84B31) : const Color(0xFFF7F5EC),
        border: Border.all(
          color: isSelected ? Colors.redAccent : Colors.black,
          width: isSelected ? 2.5 : 1.0,
        ),
        borderRadius: BorderRadius.circular(6),
        boxShadow: isSelected
            ? [
                const BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                )
              ]
            : null,
      ),
      child: Center(
        child: Text(
          _toVerticalText(text),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: isMultiLine ? 9.5 : 12.5,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.black,
            height: 1.05,
          ),
        ),
      ),
    );
  }
}