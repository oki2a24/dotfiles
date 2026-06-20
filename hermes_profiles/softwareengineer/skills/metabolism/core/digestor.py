from typing import List, Dict, Any
from datetime import datetime
from .models import MetabolicEvent


class Digestor:
    """
    MetabolicEvent を解析し、パターンを抽出して知見 (Insight) に変換するクラス。

    このコンポーネントは「消化 (Digestion)」フェーズを担当し、
    獲得された一連のエラーイベントから統計的な傾向に基づいた要約（Insight）を抽出します。
    """

    def digest(self, events: List[MetabolicEvent]) -> List[Dict[str, Any]]:
        """
        一連の MetabolicEvent から統計的な傾向に基づいた要約（Insight）を生成します。

        Args:
            events (List[MetabolicEvent]): 解析対象となる一連のエラーイベント。

        Returns:
            List[Dict[str, Any]]: 生成された知見のリスト。各要素は以下のキーを含みます:
                - summary (str): エラーまたはパターンの要約内容。
                - occurrence_count (int): その事象が検知された回数。
                - pattern_type (str): 検出されたパターンの分類（'frequent_error' または 'single_event'）。
                - detected_at (str): 解析が行われた時刻（ISO形式）。
        """
        if not events:
            return []

        # Rationale: 短期的・一時的な事象と、繰り返されるパターンを区別するために、
        # 問題内容(issue_description)に基づくグループ化を行う。
        counts = {}
        for event in events:
            desc = event.issue_description
            counts[desc] = counts.get(desc, 0) + 1

        insights = []
        for desc, count in counts.items():
            # 2回以上発生した場合は 'frequent_error'、単発の場合は 'single_event' として分類する。
            if count >= 2:
                pattern_type = "frequent_error"
                summary = f"頻発する問題が検出されました: {desc}"
            else:
                pattern_type = "single_event"
                summary = f"単発の事象を検知しました: {desc}"

            insights.append({
                "summary": summary,
                "occurrence_count": count,
                "pattern_type": pattern_type,
                "detected_at": datetime.now().isoformat()
            })

        return insights
