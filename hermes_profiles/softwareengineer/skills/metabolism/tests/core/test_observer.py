import unittest
from datetime import datetime
from hermes_profiles.softwareengineer.skills.metabolism.core.observer import Observer, MetabolicEvent, ErrorDimension

class TestObserver(unittest.TestCase):
    """Test suite for the Observer class."""

    def setUp(self):
        self.observer = Observer()

    def test_parse_terminal_error(self):
        """Test that a non-zero exit code triggers a MECHANICAL error event."""
        tool_result = {
            "exit_code": 1,
            "output": "Error: command not found"
        }
        event = self.observer.parse_terminal_output(tool_result)

        self.assertIsNotNone(event)
        self.assertIsInstance(event, MetabolicEvent)
        self.assertEqual(event.dimension, ErrorDimension.MECHANICAL)
        self.assertEqual(event.source, "terminal")
        self.assertIn("exited with non-zero status: 1", event.issue_description)

    def test_detect_user_correction(self):
        """Test that user correction keywords are detected as COGNITIVE errors."""
        text = "No, that's wrong!"
        event = self.observer.detect_user_correction(text)

        self.assertIsNotNone(event)
        self.assertEqual(event.dimension, ErrorDimension.COGNITIVE)
        self.assertEqual(event.source, "user_correction")
        self.assertIn("User correction detected", event.issue_description)

    def test_parse_terminal_success(self):
        """Test that a zero exit code returns None (no error)."""
        tool_result = {
            "exit_code": 0,
            "output": "Success!"
        }
        event = self.observer.parse_terminal_output(tool_result)
        self.assertIsNone(event)

if __name__ == "__main__":
    unittest.main()
