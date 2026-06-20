from dataclasses import dataclass, field
from datetime import datetime
from enum import Enum
from typing import Any, Dict, Optional


class ErrorDimension(Enum):
    """
    エラーの発生レイヤー（次元）を定義する列挙型。

    代謝サイクルにおいて、エラーがどの層に属するかを分類し、
    適用すべき処置（Apoptosis: 廃棄 / Metabolism: 代謝・昇華）を選択するための基盤となる。
    """

    MECHANICAL = "mechanical"     # 機械的: コード、システム環境、実行時エラー (例: Test failure, Exit code != 0)
    COGNITIVE = "cognitive"       # 認知的: AI의 推論ミス、知識不足、指示との解釈の齟齬
    OPERATIONAL = "operational"   # 運用的: プロセス、ワークフロー、対話作法に関する不備 (例: 手順の漏れ)


@dataclass(frozen=True)  # Rationale: 代謝プロセスにおけるイベントは「過去に起きた事実」であり、整合性を保証するために変更不可(immutable)とする。
class MetabolicEvent:
    """
    検知された「逸脱（Error/Deviance）」をカプセル化する不可変なデータモデル。

    代謝サイクルにおける『獲得 (Acquisition)』フェーズの基本単位であり、
    解析プロセスを通じて後続のステップへと引き継がれる単一の事象を表す。

    Attributes:
        event_id (str): イベントの一意な識別子。
        timestamp (datetime): 逸脱が検知された正確な時刻。
        dimension (ErrorDimension): エラーの性質を示す次元（機械・認知・運用）。
        source (str): 検知源（例: 'terminal', 'user_correction'）。
        issue_description (str): 問題内容に関する人間が理解可能な詳細説明。
        context (Dict[str, Any]): デバッグや解析に必要な周辺コンテキスト情報（実行コマンド、出力等）。
        model_version (Optional[str]): エラー検出時に使用されていたモデルのバージョン。
        environment_id (Optional[str]): 実行環境を識別するID（セッションID等）。
    """

    event_id: str
    timestamp: datetime = field(default_factory=datetime.now)
    dimension: ErrorDimension = ErrorDimension.MECHANICAL  # Rationale: 最も自動検知しやすく、システム的な影響が大きい機械的エラーをデフォルトとする。
    source: str = "unknown"
    issue_description: str = ""
    context: Dict[str, Any] = field(default_factory=dict)
    model_version: Optional[str] = None
    environment_id: Optional[str] = None

    def __post_init__(self):
        """インスタンス化時のバリデーション。"""
        if not self.event_id:
            raise ValueError("event_id は空にできません。")

    def to_dict(self) -> Dict[str, Any]:
        """
        オブジェクトをシリアライズ可能な辞書形式に変換する。

        Returns:
            Dict[str, Any]: シリアライズされたデータ（timestampは ISO 8601 形式の文字列）。
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
            ValueError: データ形式が不正、または必須フィールドが欠落している場合。
        """
        try:
            # timestamp の文字列を datetime オブジェクトに変換
            if isinstance(data.get("timestamp"), str):
                data["timestamp"] = datetime.fromisoformat(data["timestamp"])

            # Enum の値（文字列）を ErrorDimension 型に変換
            if "dimension" in data and isinstance(data["dimension"], str):
                data["dimension"] = ErrorDimension(data["dimension"])

            return cls(**data)
        except Exception as e:
            raise ValueError(f"MetabolicEvent のデシリアライズに失敗しました: {e}")
