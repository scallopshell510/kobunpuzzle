import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_kobunpuzzle/screens/selection_screen.dart'; // ← ここを変更

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  
  runApp(const FullKobunApp());
}

class FullKobunApp extends StatelessWidget {
  const FullKobunApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '古文助動詞 パズル',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF7F5EC),
      ),
      home: const HomeScreen(),
    );
  }
}

// 🏠 ホーム画面
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // 外部リンクを開く関数
  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.platformDefault)) {
      debugPrint('Could not launch $urlString');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // --- ヘッダー ---
                  const Text(
                    '古典助動詞パズル',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '指折り数える暗誦から、一瞬で引き出す「構造理解」へ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black54,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // --- メインボタン ---
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SelectionScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3498DB),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 18,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: const Text(
                      '🧩 パズルを始める',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),

                  // --- コンセプト文章セクション① ---
                  _buildSectionCard(
                    title: '💡 なぜ今、古文の助動詞なのか？',
                    content:
                        '言葉の変化は、スマホのOSのように一斉更新されるものではありません。人間の寿命がそれぞれ異なるからこそ、言葉は世代を超えてグラデーションのように変化していきます。\n\n現代の日本語と地続きである古文を学ぶことは、自分が普段無意識に使っている現代語を客観視し、文法構造を理解する最高の「メタ言語トレーニング」です。特に生成AI時代の今、言葉の微細なニュアンスや構造を見抜く「言語の解像度」が強く求められています。',
                  ),
                  const SizedBox(height: 20),

                  // --- コンセプト文章セクション② ---
                  _buildSectionCard(
                    title: '⚡️ 「指折り数えるタイムラグ」をゼロに',
                    content:
                        '「せ・せ・す・する…4つ目だから連体形！」と頭の中で指折り数えていては、実際の読解という高度な思考に脳のメモリを使えません。\n\n本アプリは、パズル形式で表を埋めることで、「連体形は『〜る』が多いな」といった規則性に自ら気づき、瞬時に活用形を引き出すためのツールです。',
                  ),
                  const SizedBox(height: 32),

                  // --- Amazonアソシエイト（おすすめ参考書）セクション ---
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE0E0E0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '📚 文法を固めたら実践へ！おすすめ教材',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'パズルで助動詞の活用と意味の構造を捉えたら、実際の文章読解に挑戦してみましょう。解説が分かりやすく、自習にも最適な参考書です。',
                          style: TextStyle(fontSize: 14, height: 1.5, color: Colors.black87),
                        ),
                        const SizedBox(height: 16),
                        
                        // 書籍リンク1
                        InkWell(
                          onTap: () {
                            // シングルクォーテーション(' ')の中にURLを入れてください
                            _launchURL('https://www.amazon.co.jp/');
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8F9FA),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: const Color(0xFFE9ECEF)),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.menu_book, color: Color(0xFF3498DB)),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '『富井の古文文法が面白いほどわかる本』',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Color(0xFF2980B9),
                                        ),
                                      ),
                                      Text(
                                        '助動詞のイメージや識別を視覚的に学べる定番書',
                                        style: TextStyle(fontSize: 12, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(Icons.open_in_new, size: 16, color: Colors.grey),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // --- フッター：Amazonアソシエイト必須表記 ---
                  const Text(
                    '当サイトはAmazon.co.jpを宣伝しリンクすることによってサイトが紹介料を獲得できる手段を提供することを目的に設定されたアフィリエイトプログラムである、Amazonアソシエイト・プログラムの参加者です。',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.black38,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 見栄えを整えるカード型の枠組み
  Widget _buildSectionCard({
    required String title,
    required String content,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              height: 1.6,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}