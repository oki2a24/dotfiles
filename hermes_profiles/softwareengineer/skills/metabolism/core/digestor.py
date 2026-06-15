from typing import List, Dict, Any
from datetime import datetime
from .models import MetabolicEvent, ErrorDimension

class Digestor:
    """
    MetabolicEvent を解析し、パターンを抽出して知見 (Insight) に変換するクラス。

    このコンポーネントは「消化 (Digestion)」フェーズを担当し、
    獲得されたエラーイベントから統計的な傾向や重要な法則性を導き出します。
    """

    def digest(self, events: List[MetabolicEvent]) -> List[Dict[str, Any]]:
        """
        一連のイベントから共通のパターンを見つけ出し、要約された知見を生成する。

        Args:
            events (List[MetabolicEvent]): 解析対象のイベントリスト。

        Returns:
            List[Dict[str, Any]]: 生成された知見のリスト。各要素は以下のキーを持つ:
                - summary (str): エラーの要約。
                - occurrence_count (int): 発生回数。
                - pattern_type (str): 検出されたパターンの種類（例: 'frequent_error'）。
        """
        if not events:
            return []

        # issue_description をキーとしてグループ化
        counts = {}
        for event in events:
            desc = event.issue_description
            counts[desc] = counts.get(desc, 0) + 1

        insights = []
        for desc, count in counts.items():
            # 2回以上発生した場合は 'frequent_error'、単発の場合は 'single_event' として抽出
            if count >= 2:
                pattern_type = "frequent_error"
                summary = f"Repeated issue detected: {desc}"
            else:
                pattern_type = "single_event"
                summary = f"Single event detected: {desc}"

            insights.append({
                "summary": summary,
                "occurrence_count": count,
                "pattern_type": pattern_type,
                "detected_at": datetime.now().isoformat()
            })

        return insights
