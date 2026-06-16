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
    import os
    current_dir = os.path.dirname(os.path.abspath(__file__))
    sys.path.append(os.path.abspath(os.path.join(current_dir, "../../../../")))
    from hermes_profiles.softwareengineer.skills.metabolism.core.models import MetabolicEvent, ErrorDimension

class TestDigestor(unittest.TestCase):
    def setUp(self):
        from hermes_profiles.softwareengineer.skills.metabolism.core.digestor import Digestor
        self.digestor = Digestor()

    def test_summarize_repeated_errors(self):
        now = datetime.now()
        events = [
            MetabolicEvent(event_id=f"e{i}", timestamp=now, dimension=ErrorDimension.MECHANICAL, source="terminal", issue_description="Connection timeout") 
            for i in range(3)
        ]
        insights = self.digestor.digest(events)
        self.assertGreaterEqual(len(insights), 1)
        self.assertTrue(any("Connection timeout" in insight["summary"] for insight in insights))

    def test_different_error_types_stay_separate(self):
        now = datetime.now()
        events = [
            MetabolicEvent(event_id="e1", timestamp=now, dimension=ErrorDimension.MECHANICAL, issue_description="Err 1"),
            MetabolicEvent(event_id="e2", timestamp=now, dimension=ErrorDimension.COGNITIVE, issue_description="Err 2"),
        ]
        insights = self.digestor.digest(events)
        self.assertEqual(len(insights), 2)

if __name__ == "__main__":
    unittest.main()
