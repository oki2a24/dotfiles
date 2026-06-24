import unittest
from metabolism.core.timestamp_provider import TimestampProvider

class TestTimestampProvider(unittest.TestCase):
    """@Why: Ensure that timestamp provider returns valid ISO 8601 strings."""
    def test_get_timestamp_format(self):
        """@Why: Check if the output is a string and has expected length/format roughly."""
        provider = TimestampProvider()
        ts = provider.get_iso_timestamp()
        self.assertIsInstance(ts, str)
        self.assertTrue(len(ts) > 10)  # Basic check for ISO format

if __name__ == "__main__":
    unittest.main()
