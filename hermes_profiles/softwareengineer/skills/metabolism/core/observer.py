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
        # ユーザーの訂正を検知するためのキーワードパターン
        self.correction_patterns = [
            re.compile(r"\bno\b", re.IGNORECASE),
            re.compile(r"\bwrong\b", re.IGNORECASE),
            re.compile(r"\bincorrect\b", re.IGNORECASE),
            re.compile(r"\bdont't do that\b", re.IGNORECASE),
            re.compile(r"\bstop\b", re.IGNORECASE),
            re.compile(r"\berror\b", re.IGNORECASE),
        ]

    def parse_terminal_output(self, tool_result: Dict[str, Any]) -> Optional[MetabolicEvent]:
        """
        `terminal` ツールの実行結果を解析し、エラーイベントを抽出する。

        Args:
            tool_result (Dict[str, Any]): ターミナルの終了ステータスや出力を含む辞書。

        Returns:
            Optional[MetabolicEvent]: 検知された場合、生成したイベントオブジェクトを返す。
        """
        exit_code = tool_result.get("exit_code", 0)
        output = tool_result.get("output", "")

        if exit_code != 0:
            return MetabolicEvent(
                event_id=f"err_{datetime.now().timestamp()}",
                dimension=ErrorDimension.MECHANICAL,
                source="terminal",
                issue_description=f"Command exited with non-zero status: {exit_code}. Output: {output[:200]}...",
                context={"full_output": output, "exit_code": exit_code}
            )
        return None

    def detect_user_correction(self, text: str) -> Optional[MetabolicEvent]:
        """
        ユーザーのメッセージ内に訂正の意図が含まれているかを検知する。

        Args:
            text (str): 検知対象のテキスト（ユーザーの発言）。

        Returns:
            Optional[MetabolicEvent]: 訂正を検知した場合、生成したイベントオブジェクトを返す。
        """
        for pattern in self.correction_patterns:
            if pattern.search(text):
                return MetabolicEvent(
                    event_id=f"user_{datetime.now().timestamp()}",
                    dimension=ErrorDimension.COGNITIVE,
                    source="user_correction",
                    issue_description=f"User correction detected in text: {text[:100]}...",
                    context={"original_text": text}
                )
        return None

    def analyze_output(self, output: str) -> List[Dict[str, Any]]:
        """
        文字列の中からエラーに関連するキーワードをスキャンし、簡易的な問題を報告する。
        """
        findings = []
        # 典型的なプログラムエラーパターンへのマッチング
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
