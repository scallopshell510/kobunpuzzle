enum PuzzleMode {
  formsOnly,   // 活用形のみ
  meaningOnly, // 意味のみ（順不同）
  both,        // 両方
}

class AuxiliaryVerb {
  final String connection;
  final String base;
  final Map<String, String> forms;
  final List<String> meanings;
  final String type;

  AuxiliaryVerb({
    required this.connection,
    required this.base,
    required this.forms,
    required this.meanings,
    required this.type,
  });
}

// 全助動詞マスターデータ（28種）
final List<AuxiliaryVerb> allVerbs = [
  AuxiliaryVerb(
    connection: '未然形', base: 'る', type: '下二段型',
    forms: {'未然': 'れ', '連用': 'れ', '終止': 'る', '連体': 'るる', '已然': 'るれ', '命令': 'れよ'},
    meanings: ['受身', '尊敬', '可能', '自発'],
  ),
  AuxiliaryVerb(
    connection: '未然形', base: 'らる', type: '下二段型',
    forms: {'未然': 'られ', '連用': 'られ', '終止': 'らる', '連体': 'らるる', '已然': 'らるれ', '命令': 'られよ'},
    meanings: ['受身', '尊敬', '可能', '自発'],
  ),
  AuxiliaryVerb(
    connection: '未然形', base: 'す', type: '下二段型',
    forms: {'未然': 'せ', '連用': 'せ', '終止': 'す', '連体': 'する', '已然': 'すれ', '命令': 'せよ'},
    meanings: ['使役', '尊敬'],
  ),
  AuxiliaryVerb(
    connection: '未然形', base: 'さす', type: '下二段型',
    forms: {'未然': 'させ', '連用': 'させ', '終止': 'さす', '連体': 'さする', '已然': 'さすれ', '命令': 'させよ'},
    meanings: ['使役', '尊敬'],
  ),
  AuxiliaryVerb(
    connection: '未然形', base: 'しむ', type: '下二段型',
    forms: {'未然': 'しめ', '連用': 'しめ', '終止': 'しむ', '連体': 'しむる', '已然': 'しむれ', '命令': 'しめよ'},
    meanings: ['使役', '尊敬'],
  ),
  AuxiliaryVerb(
    connection: '未然形', base: 'ず', type: '特殊型',
    forms: {
      '未然': 'ざず\nら／',
      '連用': 'ざず\nり／',
      '終止': 'ず',
      '連体': 'ざぬ\nる／',
      '已然': 'ざね\nれ／',
      '命令': 'ざ◯\nれ／'
    },
    meanings: ['打消'],
  ),
  AuxiliaryVerb(
    connection: '未然形', base: 'じ', type: '無変化型',
    forms: {'未然': '○', '連用': '○', '終止': 'じ', '連体': 'じ', '已然': 'じ', '命令': '○'},
    meanings: ['推打\n量消', '意打\n志消'],
  ),
  AuxiliaryVerb(
    connection: '未然形', base: 'む', type: '四段型',
    forms: {'未然': '○', '連用': '○', '終止': 'む', '連体': 'む', '已然': 'め', '命令': '○'},
    meanings: ['推量', '意志', '勧誘', '適当', '仮定', '婉曲'],
  ),
  AuxiliaryVerb(
    connection: '未然形', base: 'むず', type: 'サ変型',
    forms: {'未然': '○', '連用': '○', '終止': 'むず', '連体': 'むずる', '已然': 'むずれ', '命令': '○'},
    meanings: ['推量', '意志', '勧誘', '適当', '仮定', '婉曲'],
  ),
  AuxiliaryVerb(
    connection: '未然形', base: 'まし', type: '特殊型',
    forms: {'未然': 'まま\nしせ\n／か', '連用': '○', '終止': 'まし', '連体': 'まし', '已然': 'ましか', '命令': '○'},
    meanings: ['仮反\n想実', 'のた\n意め\n思ら\n い', '能実\nな現\n願不\n望可', '推量'],
  ),
  AuxiliaryVerb(
    connection: '未然形', base: 'まほし', type: '形容詞型',
    forms: {
      '未然': 'まま\nほほ\nしし\nかく\nら／',
      '連用': 'まま\nほほ\nしし\nかく\nり／',
      '終止': 'まほし',
      '連体': 'まま\nほほ\nしし\nかき\nる／',
      '已然': 'まほしけれ',
      '命令': '○'
    },
    meanings: ['願望'],
  ),
  AuxiliaryVerb(
    connection: '連用形', base: 'つ', type: '下二段型',
    forms: {'未然': 'て', '連用': 'て', '終止': 'つ', '連体': 'つる', '已然': 'つれ', '命令': 'てよ'},
    meanings: ['完了', '強意'],
  ),
  AuxiliaryVerb(
    connection: '連用形', base: 'ぬ', type: 'ナ変型',
    forms: {'未然': 'な', '連用': 'に', '終止': 'ぬ', '連体': 'ぬる', '已然': 'ぬれ', '命令': 'ね'},
    meanings: ['完了', '強意'],
  ),
  AuxiliaryVerb(
    connection: '連用形', base: 'けり', type: 'ラ変型',
    forms: {'未然': 'けら', '連用': '○', '終止': 'けり', '連体': 'ける', '已然': 'けれ', '命令': '○'},
    meanings: ['過去', '詠嘆'],
  ),
  AuxiliaryVerb(
    connection: '連用形', base: 'たり（完了・存続）', type: 'ラ変型',
    forms: {'未然': 'たら', '連用': 'たり', '終止': 'たり', '連体': 'たる', '已然': 'たれ', '命令': 'たれ'},
    meanings: ['完了', '存続'],
  ),
  AuxiliaryVerb(
    connection: '連用形', base: 'けむ', type: '四段型',
    forms: {'未然': '○', '連用': '○', '終止': 'けむ', '連体': 'けむ', '已然': 'けめ', '命令': '○'},
    meanings: ['推過\n量去', '原過\n因去\n推の\n量 ', '聞過\n・去\n婉の\n曲伝'],
  ),
  AuxiliaryVerb(
    connection: '連用形', base: 'たし', type: '形容詞型',
    forms: {
      '未然': 'たた\nかく\nら／',
      '連用': 'たた\nかく\nり／',
      '終止': 'たし',
      '連体': 'たた\nかき\nる／',
      '已然': 'たけれ',
      '命令': '○'
    },
    meanings: ['願望'],
  ),
  AuxiliaryVerb(
    connection: '連用形', base: 'き', type: '特殊型',
    forms: {'未然': 'せ', '連用': '○', '終止': 'き', '連体': 'し', '已然': 'しか', '命令': '○'},
    meanings: ['過去'],
  ),
  AuxiliaryVerb(
    connection: '終止形', base: 'らし', type: '無変化型',
    forms: {'未然': '○', '連用': '○', '終止': 'らし', '連体': 'らし', '已然': 'らし', '命令': '○'},
    meanings: ['推定'],
  ),
  AuxiliaryVerb(
    connection: '終止形', base: 'らむ', type: '四段型',
    forms: {'未然': '○', '連用': '○', '終止': 'らむ', '連体': 'らむ', '已然': 'らめ', '命令': '○'},
    meanings: ['推現\n量在', '原現\n因在\n推の\n量 ', '聞現\n・在\n婉の\n曲伝'],
  ),
  AuxiliaryVerb(
    connection: '終止形', base: 'めり', type: 'ラ変型',
    forms: {'未然': '○', '連用': 'めり', '終止': 'めり', '連体': 'める', '已然': 'めれ', '命令': '○'},
    meanings: ['推定', '婉曲'],
  ),
  AuxiliaryVerb(
    connection: '終止形', base: 'なり（伝聞・推定）', type: 'ラ変型',
    forms: {'未然': '○', '連用': 'なり', '終止': 'なり', '連体': 'なる', '已然': 'なれ', '命令': '○'},
    meanings: ['推定', '伝聞'],
  ),
  AuxiliaryVerb(
    connection: '終止形', base: 'べし', type: '形容詞型',
    forms: {
      '未然': 'べべ\nかく\nら／',
      '連用': 'べべ\nかく\nり／',
      '終止': 'べし',
      '連体': 'べべ\nかき\nる／',
      '已然': 'べけれ',
      '命令': '○'
    },
    meanings: ['推量', '意志', '可能', '当然', '命令', '適当'],
  ),
  AuxiliaryVerb(
    connection: '終止形', base: 'まじ', type: '形容詞型',
    forms: {
      '未然': 'まま\nじじ\nかく\nら／',
      '連用': 'まま\nじじ\nかく\nり／',
      '終止': 'まじ',
      '連体': 'まま\nじじ\nかき\nる／',
      '已然': 'まじけれ',
      '命令': '○'
    },
    meanings: ['推打\n量消', '意打\n志消', '不可能', '当打\n然消', '・不\n禁適\n止当'],
  ),
  AuxiliaryVerb(
    connection: '体言/連体形', base: 'なり（断定・存在）', type: '形容動詞型',
    forms: {'未然': 'なら', '連用': '／な\nにり', '終止': 'なり', '連体': 'なる', '已然': 'なれ', '命令': 'なれ'},
    meanings: ['断定', '存在'],
  ),
  AuxiliaryVerb(
    connection: '体言/連体形', base: 'たり（断定）', type: '形容動詞型',
    forms: {'未然': 'たら', '連用': '／た\nとり', '終止': 'たり', '連体': 'たる', '已然': 'たれ', '命令': 'たれ'},
    meanings: ['断定'],
  ),
  AuxiliaryVerb(
    connection: '体言/連体形', base: 'ごとし', type: '形容詞型',
    forms: {'未然': '○', '連用': 'ごとく', '終止': 'ごとし', '連体': 'ごとき', '已然': '○', '命令': '○'},
    meanings: ['比況', '例示'],
  ),
  AuxiliaryVerb(
    connection: 'サ変未然/四段已然', base: 'り', type: 'ラ変型',
    forms: {'未然': 'ら', '連用': 'り', '終止': 'り', '連体': 'る', '已然': 'れ', '命令': 'れ'},
    meanings: ['完了', '存続'],
  ),
];