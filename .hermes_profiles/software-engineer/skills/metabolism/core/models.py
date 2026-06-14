from dataclasses import dataclass, field
from datetime import datetime
from enum import Enum
from typing import Any, Dict, Optional

class ErrorDimension(Enum):
    """
    エラーの発生レイヤーを定義する列挙型。
    代謝サイクルにおいて、エラーをどの次元として扱うかを分類するために使用される。
    """
    MECHANICAL = "mechanical"     # 機械的: コード、システム、環境に関するエラー。
    COGNITIVE = "cognitive"       # 認知的: 推論、知識、解釈に関するエラー。
    OPERATIONAL = "operational"   # 運用的: プロセス、手順、対話作法に関するエラー。

@dataclass
class MetabolicEvent:
    """
    検知された「逸脱（Error）」を表すデータモデル。
    代謝サイクルにおける『獲得 (Acquisition)』フェーズの基本単位となる。

    Attributes:
        event_id (str): イベントの一意な識別子。
        timestamp (datetime): エラーが検知された時刻。
        dimension (ErrorDimension): エラーが属するレイヤー（機械・認知・運用）。
        source (str): エラーを検知したソース（例: 'terminal', 'user_correction'）。
        issue_description (str): 発生した問題の内容に関する詳細な説明。
        context (Dict[str, Any]): エラー発生時の周囲のコンテキスト情報。
        model_version (Optional[str]): エラー検出時のLLMモデルバージョン。陳腐化判定（Apoptosis）に重要。
        environment_id (Optional[str]): 実行環境の識別子。
    """
    event_id: str
    timestamp: datetime = field(default_factory=datetime.now)
    dimension: ErrorDimension = ErrorDimension.MECHANICAL
    source: str = "unknown"
    issue_description: str = ""
    context: Dict[str, Any] = field(default_factory=dict)
    model_version: Optional[str] = None
    environment_id: Optional[str] = None

    def to_dict(self) -> Dict[str, Any]:
        """
        オブジェクトをシリアライズ可能な辞書形式に変換する。
        履歴の保存 (Historian) や通信に使用される。
        """
        return {
            "event_id": self.event_id,
            "timestamp": self.timestamp.isoformat(),
            "dimension": self.dimension.value,
            "source": self.source,
            "issue_description": self.issue_description,
            "context": self.context,
            "model_version": self.model_version,
            "environment_id": self.environment_id,
        }

    @classmethod
    def from_dict(cls, data: Dict[str, Any]) -> 'MetabolicEvent':
        """
        辞書データから MetabolicEvent オブジェクトを復元する。
        シリアライズされた履歴ファイルからの読み込みに使用される。
        """
        data['timestamp'] = datetime.fromisoformat(data['timestamp'])
        # Enum の変換処理
        if isinstance(data.get('dimension'), str):
            data['dimension'] = ErrorDimension(data['dimension'])
        return cls(**data)
