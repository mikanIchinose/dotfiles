# SOLID原則 — 原典の定義と誤解

各原則について、原典の定義（出典明記）・本質の一文・よくある誤解・評価対象外になる条件を示す。SOLIDの頭字語は Michael Feathers が2004年頃に命名したもので、5原則は Robert C. Martin（Uncle Bob）が1990年代後半〜2000年代前半に整理・普及させた（『Agile Software Development: Principles, Patterns, and Practices』2002、後に『Clean Architecture』2017）。

---

## SRP — Single Responsibility Principle（単一責任の原則）

- **原典の定義**: 当初「A class should have only one reason to change（クラスが変更される理由は1つだけであるべき）」（Martin, APPP 2002）。"reason to change" の曖昧さから Martin は2014年のブログ記事で再定義し、『Clean Architecture』(2017) で **「A module should be responsible to one, and only one, actor（モジュールはただ1つのアクターに対して責任を負うべき）」** とした。ここで **アクター** とは、そのモジュールへの変更を要求する利害関係者/ユーザーのグループを指す。
  - 出典: Robert C. Martin, *Agile Software Development: Principles, Patterns, and Practices* (2002); "The Single Responsibility Principle" (blog, 2014); *Clean Architecture* (2017)。
- **本質の一文**: **同じアクター（同じ理由）のために変わるものは集め、異なる理由で変わるものは分ける。**「同じ理由で変わるものを集める / 異なる理由で変わるものを分ける」（Separation of Concerns の言い換え、Martin 2014）。
- **よくある誤解**:
  - ✗「1つのことだけをする」= 関数/クラスを機械的に小さく割る、という誤解。SRPは **サイズ** や **動詞の数** の話ではない。責任 = **応答するアクター** の話。1メソッドしか持たなくても複数アクターに応答すれば違反、多数のメソッドを持っても単一アクターなら遵守。
  - ✗「凝集度を上げる」と同義とする誤解。凝集は近いが、SRPの核は「変更理由（アクター）の単一性」。
- **評価対象外になる条件**: 純粋なデータ保持のみの型（`data class` のフィールド定義、DTO、sealed の枝など、振る舞いを持たず変更軸が「データ形状」1つに収束するもの）は、SRP判定の実益が薄い場合「評価対象外」とし得る。

---

## OCP — Open/Closed Principle（開放閉鎖の原則）

- **原典の定義**: Bertrand Meyer (1988, *Object-Oriented Software Construction*) が起源。**「Software entities (classes, modules, functions) should be open for extension, but closed for modification（拡張に対して開き、修正に対して閉じているべき）」**。Martin が継承ではなく **抽象への依存（ポリモーフィズム）** による実現へと再解釈した。
  - 出典: Bertrand Meyer, *Object-Oriented Software Construction* (1988); Robert C. Martin, "The Open-Closed Principle" (1996)。
- **本質の一文**: **新しい振る舞いは既存コードを書き換えずに追加できるようにする**（新しい種類を足すとき、既存の分岐を編集して回らない）。
- **よくある誤解**:
  - ✗「全てを拡張ポイントにせよ」= あらゆる箇所に interface/抽象を差し込む誤解。これは投機的抽象化であり、Ousterhout の言う「浅いモジュール」を量産する。OCPは **実際に変化する軸** に対してのみ適用する。
  - ✗「修正を一切するな」ではない。バグ修正や仕様変更そのものへの修正は当然行う。閉じるべきは「新種の追加によって既存分岐を触ること」。
- **評価対象外になる条件**: 変化軸が存在しない/予見されないコンポーネント（追加種別が来ない確定した処理）。OCP違反を主張するには「どの軸で新種が来るか」を具体的に言えることが前提。

---

## LSP — Liskov Substitution Principle（リスコフの置換原則）

- **原典の定義**: Barbara Liskov (1987, 基調講演) と、Liskov & Jeannette Wing (1994, "A Behavioral Notion of Subtyping") による behavioral subtyping。直感的には **「サブタイプのオブジェクトは、スーパータイプのオブジェクトと置き換えてもプログラムの正しさを損なわない」**。Liskov & Wing が示した具体的条件:
  1. **事前条件（precondition）はサブタイプで強化してはならない**（同等かより弱く）。
  2. **事後条件（postcondition）はサブタイプで弱化してはならない**（同等かより強く）。
  3. **スーパータイプの不変条件（invariant）はサブタイプでも保たれること**。
  4. **履歴制約（history constraint / history rule）** — サブタイプが新たに導入するメソッドによって、スーパータイプでは許されない状態変化を起こしてはならない。これが Liskov & Wing が Meyer の契約設計を超えて加えた独自の貢献。
  - 出典: Liskov & Wing, "A Behavioral Notion of Subtyping", *ACM TOPLAS* (1994)。
- **本質の一文**: **契約（事前/事後/不変/履歴）を守る限りにおいてのみ、is-a と名乗れる。** 型が合うだけでは不十分で、**振る舞いの契約** が置換可能でなければならない。
- **よくある誤解**:
  - ✗「継承していれば/型が合えばLSPを満たす」。コンパイルが通ることと契約の保存は別。典型的違反: オーバーライドで例外を投げる（事後条件の弱化/未定義動作の追加）、より狭い引数しか受けない（事前条件の強化）、`UnsupportedOperationException` を投げる実装（正方形/長方形問題、不変 List に対する add など）。
  - ✗ LSPは継承だけの話、という誤解。インターフェース実装、関数型の差し替えにも同じ契約論が及ぶ。
- **評価対象外になる条件**: 継承階層も、置換されるインターフェース実装も、契約を持つ差し替え可能な抽象も存在しないコンポーネント（単一の具象クラスで多態が絡まない、多態を持たない関数）。

---

## ISP — Interface Segregation Principle（インターフェース分離の原則）

- **原典の定義**: Xerox（Martin のコンサル案件）由来。**「Clients should not be forced to depend upon interfaces that they do not use（クライアントは、使わないメソッドを含むインターフェースへの依存を強制されるべきでない）」**。
  - 出典: Robert C. Martin, "The Interface Segregation Principle" (1996); APPP (2002)。
- **本質の一文**: **インターフェースはそれを使うクライアントの必要に合わせて分割する**（太いインターフェースを、役割ごとの細いインターフェースに割る）。
- **よくある誤解**:
  - ✗「インターフェースは常に小さく」= 全メソッドを1メソッドずつ分ける誤解。基準はメソッド数ではなく **クライアントごとの使用パターン**。全クライアントが全メソッドを使うなら分割不要。
  - ✗ 実装側の都合で分ける、という誤解。ISPは **クライアント側（呼ぶ側）** が使わないものに依存させられているかで判断する。
- **評価対象外になる条件**: そもそも interface/抽象を公開していないコンポーネント、または単一クライアントしか持たないインターフェース（分離の受益者がいない）。

---

## DIP — Dependency Inversion Principle（依存性逆転の原則）

- **原典の定義**: Martin による定式化。**「High-level modules should not depend on low-level modules. Both should depend on abstractions. Abstractions should not depend on details. Details should depend on abstractions（上位モジュールは下位モジュールに依存すべきでない。両者とも抽象に依存すべき。抽象は詳細に依存すべきでなく、詳細が抽象に依存すべき）」**。
  - 出典: Robert C. Martin, "The Dependency Inversion Principle" (1996); APPP (2002)。
- **本質の一文**: **依存の矢印を、具体（詳細）ではなく抽象へ向ける** — 特に「上位が下位の具象を直接掴む」構図を、抽象（インターフェース）を上位側に置くことで逆転させる。
- **よくある誤解**:
  - ✗ 「DI（依存性注入）= DIP」。DIは注入という **手法**、DIPは依存方向の **原則**。Hilt で注入していても、注入している型が下位層の具象クラスなら DIP は破れている。
  - ✗「全てを interface 越しに」。DIPは **アーキテクチャ境界をまたぐ** 安定性の逆転が主眼。同一モジュール内の安定した具象への依存まで抽象化する必要はない。
- **評価対象外になる条件**: 層境界をまたがない、または上位/下位の関係が存在しないコンポーネント（同一層内のユーティリティ等）。

---

## コンポーネント原則（モジュール/パッケージ粒度への翻訳の根拠）

SOLIDはクラス粒度の原則。モジュール/パッケージ粒度へ翻訳する根拠として、Martin の **コンポーネント原則**（『Clean Architecture』Part IV）を用いる。

**凝集の3原則**（コンポーネントに何を入れるか）:
- **REP (Reuse/Release Equivalence Principle)**: 再利用の単位はリリースの単位。一緒に再利用・リリース・追跡されるものを1コンポーネントに。
- **CCP (Common Closure Principle)**: **同じ理由で・同じタイミングで変わるクラスを集める**。OCPとSRPのコンポーネント版。→ **モジュールのSRP** の根拠。
- **CRP (Common Reuse Principle)**: 一緒に使われないものを同じコンポーネントに入れない（使わないものへの依存を強制しない）。→ **モジュールのISP** の根拠。

REP/CCP はコンポーネントを大きくする力、CRP は小さくする力で、緊張関係にある。

**結合の3原則**（コンポーネント間の関係）:
- **ADP (Acyclic Dependencies Principle)**: 依存グラフに循環を作らない。
- **SDP (Stable Dependencies Principle)**: **変わりやすいものが、変わりにくい（安定した）ものに依存する** 向きにする。
- **SAP (Stable Abstractions Principle)**: 安定したコンポーネントほど抽象的であるべき。

SDP + SAP から「**依存は抽象の方向へ流れる**」が導かれる。→ **モジュールのDIP** の根拠。

---

## 批判・限界（判定を保守的にするためのキャリブレーション）

SOLIDは万能ではなく、機械的適用は害になり得る。違反判定は本セクションを踏まえ **保守的に** 行うこと。

**Dan North "CUPID"**（2021, "CUPID — for joyful coding"）は SOLID への批判として提示された。North は SOLID を「原則（rules）」ではなく **性質（properties）** で語るべきとし、Composable / Unix philosophy / Predictable / Idiomatic / Domain-based を挙げる。含意として、SOLIDの各原則は文脈次第で過剰適用され、interface の乱立や過度な分割を招きやすい。**「原則を満たしているか」より「良いコードの性質を備えているか」** を上位に置く。

**John Ousterhout『A Philosophy of Software Design』**（2018）の **深いモジュール（deep module）** 論: 良いモジュールは **単純な公開インターフェース + 複雑な実装** を持つ。逆に **浅いモジュール（shallow module）** — インターフェースが実装に対して大きい/薄い — は複雑性を増やす。SRP/OCP を機械的に適用してクラス/インターフェースを増やすと浅いモジュールを量産し、かえって全体の複雑性（認知負荷・依存の連鎖）を高める。Ousterhout は「クラスは小さいほど良い」という通念や、抽象を投機的に増やす設計に明確に反対する。

**キャリブレーションの帰結**:
- 原則からの逸脱に **実害シナリオ（具体的な変更が来たときになぜ困るか）が伴わない** なら、それは「違反」ではなく「軽微な逸脱」以下に留める。
- **投機的抽象化を勧めない**。「将来のため」の interface 追加や分割は処方に含めない。
- 深いモジュール（単純な公開面）を、SRP/OCP を理由に割って表面積を増やす提案は原則としてしない。
