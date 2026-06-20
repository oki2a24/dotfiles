import unittest
import sys
import os
from datetime import datetime, timedelta
from pathlib import Path

# Configure sys.path to allow importing the module under test
ROOT = str(Path(__file__).resolve().parents[3])
if ROOT not in sys.path:
    sys.path.append(ROOT)

try:
    from hermes_profiles.softwareengineer.skills.metabolism.core.models import MetabolicEvent, ErrorDimension
except ImportError:
    # Fallback if running from a different context
    import sys
    current_dir = os.path.dirname(os.path.abspath(__file__))
    sys.path.append(os.path.abspath(os.path.join(current_dir, "../../../../")))
    from hermes_profiles.softwareengineer.skills.metabolism.core.models import MetabolicEvent, ErrorDimension

class TestMetabolicEvent(unittest.TestCase):
    """MetabolicEvent モデルのテストスイート。"""

    def test_initialization(self):
        """初期化が正しく行われ、全ての属性値が適切にセットされることを検証する。"""
        now = datetime(2026, 6, 14, 12, 0, 0)
        event = MetabolicEvent(
            event_id="test-123",
            timestamp=now,
            dimension=ErrorDimension.MECHANICAL,
            source="terminal",
            issue_description="Test failure",
            context={"key": "value"},
            model_version="v1",
            environment_id="env-001"
        )
        self.assertEqual(event.event_id, "test-123")
        self.assertEqual(event.dimension, ErrorDimension.MECHANICAL)
        self.assertEqual(event.source, "terminal")
        self.assertEqual(event.issue_description, "Test failure")
        self.assertEqual(event.context["key"], "value")
        self.assertEqual(event.model_version, "v1")

    def test_serialization_deserialization(self):
        """シリアライズ（辞書変換）とデシリアライズ（オブジェクト復元）が正しく行われ、データが完全に一致することを検証する。"""
        now = datetime(2026, 6, 14, 12, 0, 0)
        original = MetabolicEvent(
            event_id="test-ser-des",
            timestamp=now,
            dimension=ErrorDimension.COGNITIVE,
            source="user_correction",
            issue_description="Test serialization"
        )
        
        # シリアライズ
        data = original.to_dict()
        self.assertEqual(data["event_id"], "test-ser-des")
        self.assertEqual(data["timestamp"], now.isoformat())

        # デシリアライズ
        restored = MetabolicEvent.from_dict(data)
        
        # 検証
        self.assertEqual(original.event_id, restored.event_id)
        self.assertEqual(original.timestamp.isoformat(), restored.timestamp.isoformat())
        self.assertEqual(original.dimension, restored.dimension)
        self.assertEqual(original.issue_description, restored.issue_description)

if __name__ == "__main__":
    unittest.main()
