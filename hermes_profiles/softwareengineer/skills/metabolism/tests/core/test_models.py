import unittest
import sys
import os
from datetime import datetime

# Configure sys.path to allow importing the module under test
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "../../..")))

try:
    from hermes_profiles.softwareengineer.skills.metabolism.core.models import MetabolicEvent, ErrorDimension
except ImportError:
    # Fallback for different directory structures if needed during testing
    import sys
    from pathlib import Path
    project_root = str(Path(__file__).resolve().parents[3])
    if project_root not in sys.path:
        sys.path.append(project_root)
    try:
        from hermes_profiles.softwareengineer.skills.metabolism.core.models import MetabolicEvent, ErrorDimension
    except ImportError as e:
        raise ImportError(f"Could not find modules. Path attempted: {sys.path}\nError: {e}")

class TestMetabolicEvent(unittest.TestCase):
    """Test suite for MetabolicEvent model."""

    def test_initialization(self):
        """Test that initialization works correctly (RED)"""
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
        """Test serialization and deserialization (RED)"""
        now = datetime(2026, 6, 14, 12, 0, 0)
        original = MetabolicEvent(
            event_id="test-ser-des",
            timestamp=now,
            dimension=ErrorDimension.COGNITIVE,
            source="user_correction",
            issue_description="Test serialization"
        )
        
        data = original.to_dict()
        restored = MetabolicEvent.from_dict(data)
        
        self.assertEqual(original.event_id, restored.event_id)
        self.assertEqual(original.timestamp.isoformat(), restored.timestamp.isoformat())
        self.assertEqual(original.dimension, restored.dimension)
        self.assertEqual(original.issue_description, restored.issue_description)

if __name__ == "__main__":
    unittest.main()
