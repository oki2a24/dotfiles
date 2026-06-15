import unittest
from datetime import datetime, timedelta

# We inject these to avoid the broken module issue during this session
try:
    from hermes_profiles.softwareengineer.skills.metabolism.core.models import MetabolicEvent, ErrorDimension
except ImportError:
    from her_models_fix import MetabolicEvent, ErrorDimension # This is what it was trying to do

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
