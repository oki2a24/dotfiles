from dataclasses import dataclass, field
from datetime import datetime
from enum import Enum
from typing import Any, Dict, Optional


class ErrorDimension(Enum):
    """
    エラーの発生レイヤーを定義する列挙型。

    代謝サイクルにおいて、エラーをどの次元として分類し、
    どのような回避策（Apoptosis/Metabolism）を適用すべきかを決定するための基盤となる。
    """

    MECHANICAL = "mechanical"     # 機械的: コード、システム、環境に関する実行時エラー。
    COGNITIVE = "cognitive"       # 認知的: 推論、知識、コンテキスト解釈に関する認識の齟齬。
    OPERATIONAL = "operational"   # 運用的: プロセス、対話作法、指示内容の不整合に関するプロセス上のエラー。


@dataclass(frozen=True)  # 不変性にすることで、履歴としての信頼性を確保
class MetabolicEvent:
    """
    検知された「逸脱（Error）」をカプセル化するデータモデル。

    代謝サイクルにおける『獲得 (Acquisition)』フェーズの基本単位であり、
    後に「分析 (Digestion)」および「昇華 (Sublimation/Metabolism)」へと引き継がれる。

    Attributes:
        event_id (str): イベントの一意な識別子（UUID等が望ましい）。
        timestamp (datetime): エラーが検知された正確な時刻。
        dimension (ErrorDimension): エラーの性質を示す次元。
        source (str): エラーを検知したコンポーネント名（例: 'terminal', 'user_correction'）。
        issue_description (str): 発生した問題に関する人間が理解可能な詳細説明。
        context (Dict[str, Any]): デバッグや再試行に必要な周囲のコンテキスト情報。
        model_version (Optional[str]): エラー検出時に使用されていたモデルのバージョン。
        environment_id (Optional[str]): 実行環境（Container ID, Session ID 等）を識別するID。
    """

    event_id: str
    timestamp: datetime = field(default_factory=datetime.now)
    dimension: ErrorDimension = ErrorDimension.MECHANICAL
    source: str = "unknown"
    issue_description: str = ""
    context: Dict[str, Any] = field(default_factory=dict)
    model_version: Optional[str] = None
    environment_id: Optional[str] = None

    def __post_init__(self):
        """バリデーションロジック"""
        if not self.event_id:
            raise ValueError("event_id cannot be empty.")

    def to_dict(self) -> Dict[str, Any]:
        """
        オブジェクトをシリアライズ可能な辞書形式に変換する。

        Returns:
            Dict[str, Any]: シリアライズされたデータ。
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
    def from_dict(cls, data: Dict[str, Any]) -> "MetabolicEvent":
        """
        辞書データから MetabolicEvent オブジェクトを復元する。

        Args:
            data (Dict[str, Any]): シリアライズされた辞書データ。

        Returns:
            MetabolicEvent: 復元されたオブジェクト。

        Raises:
            KeyError: 必須フィールドが欠落している場合。
            ValueError: データ形式が不正な場合。
        """
        try:
            # timestamp の復元
            if isinstance(data.get("timestamp"), str):
                data["timestamp"] = datetime.fromisoformat(data["timestamp"])

            # Enum の変換
            if "dimension" in data and isinstance(data["dimension"], str):
                data["dimension"] = ErrorDimension(data["dimension"])

            return cls(**data)
        except Exception as e:
            raise ValueError(f"Failed to deserialize MetabolicEvent: {e}")
