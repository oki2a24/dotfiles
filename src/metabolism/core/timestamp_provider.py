from datetime import datetime, timezone

class TimestampProvider:
    """@Why: すべてのイベントは、タイムゾーン情報の欠如による不整合を防ぐため、UTC形式で扱う必要がある。

    ISO 8601形式の標準的な文字列を生成する。
    """

    def get_iso_timestamp(self) -> str:
        """
        現在のUTC時刻を ISO 8601 形式の文字列で返す。

        Returns:
            str: ISO 8601 形式のタイムスタンプ (例: 2025-01-01T00:00:00Z).
        """
        return datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")
