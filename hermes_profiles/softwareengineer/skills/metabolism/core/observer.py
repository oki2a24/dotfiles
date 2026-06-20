import re
from typing import Optional, List, Dict, Any
from datetime import datetime
from .models import MetabolicEvent, ErrorDimension


class Observer:
    """
    エラー信号（ターミナルの終了コード、またはユーザーによる訂正）を監視し、
    MetabolicEvent を生成するための観測クラス。
    """

    def __init__(self):
        # Rationale: ユーザーの非言語的な「拒絶」や「修正指示」を検知するためのキーワードパターン群
        self.correction_patterns = [
            re.compile(r"\bno\b", re.IGNORECASE),               # 「いいえ」
            re.compile(r"\bwrong\b", re.IGNORECASE),             # 「間違い」
            re.compile(r"\bincorrect\b", re.IGNORECASE),         # 「正しくない」
            re.compile(r"\bdont't do that\b", re.IGNORECASE),    # 「そうしないで」
            re.compile(r"\bstop\b", re.IGNORECASE),              # 「止めて/やめて」
            re.compile(r"\berror\b", re.IGNORECASE),             # 「エラー」（単語境界に修正）
        ]

    def parse_terminal_output(self, tool_result: Dict[str, Any]) -> Optional[MetabolicEvent]:
        """
        `terminal` ツールの実行結果を解析し、実行失敗（非ゼロの終了コード）を検知してイベントを生成する。

        Args:
            tool_result (Dict[str, Any]): 実行結果の辞書（'exit_code' および 'output' キーを含むことを想定）。

        Returns:
            Optional[MetabolicEvent]: エラーが検知された場合は生成したイベントを、正常終了時は None を返す。
        """
        exit_code = tool_result.get("exit_code", 0)
        output = tool_result.get("output", "")

        if exit_code != 0:
            # Rationale: 非ゼロの終了コードは環境・システム上の不整合を示す直接的な証拠であるため、即座に検知する。
            return MetabolicEvent(
                event_id=f"err_{datetime.now().timestamp()}",
                dimension=ErrorDimension.MECHANICAL,
                source="terminal",
                issue_description=f"コマンドが非ゼロのステータスで終了しました (status: {exit_code})。出力: {output[:200]}...",
                context={"full_output": output, "exit_code": exit_code}
            )
        return None

    def detect_user_correction(self, text: str) -> Optional[MetabolicEvent]:
        """
        ユーザーの発言テキストをスキャンし、修正・拒絶の意図（COGNITIVE error）が含まれているかを検知する。

        Args:
            text (str): ユーザーの発言内容。

        Returns:
            Optional[MetabolicEvent]: 訂正の兆候が検知された場合は生成したイベントを、そうでなければ None を返す。
        """
        for pattern in self.correction_patterns:
            if pattern.search(text):
                # Rationale: ユーザーによる修正（COGNITIVE error）は、モデルの推論ミスや指示解釈の齟齬を示す重要な信号である。
                return MetabolicEvent(
                    event_id=f"user_{datetime.now().timestamp()}",
                    dimension=ErrorDimension.COGNITIVE,
                    source="user_correction",
                    issue_description=f"ユーザーによる訂正を検知しました: {text[:100]}...",
                    context={"original_text": text}
                )
        return None

    def analyze_output(self, output: str) -> List[Dict[str, Any]]:
        """
        文字列（ログ出力など）の中から一般的なプログラミング・実行時のエラーパターンを検出し、簡易的な診断結果をリストで返す。

        Args:
            output (str): 解析対象のテキスト。

        Returns:
            List[Dict[str, Any]]: 見つかったエラータイプとその詳細を含む辞書のリスト。
        """
        findings = []
        # Rationale: 典型的なプログラミング言語における標準的な例外タイプをパターン化してスキャン対象とする。
        error_patterns = {
            "SyntaxError": r"SyntaxError:.*",
            "TypeError": r"TypeError:.*",
            "ImportError": r"ModuleNotFoundError:.*|ImportError:.*",
            "RuntimeError": r"RuntimeError:.*",
        }

        for error_type, pattern in error_patterns.items():
            match = re.search(pattern, output)
            if match:
                findings.append({
                    "type": "Code Error",
                    "detail": f"{error_type}: {match.group(0)}",
                    "dimension": "mechanical"
                })
        return findings
