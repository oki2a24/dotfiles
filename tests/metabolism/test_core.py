import unittest
from metabolism.core.id_generator import IdGenerator
from metabolism.core.timestamp_provider import TimestampProvider

class TestCore(unittest.TestCase):
    """@Why: Combined test suite for core utility providers."""

    def setUp(self):
        self.id_gen = IdGenerator()
        self.ts_prov = TimestampProvider()

    def test_id_generator(self):
        """Check UUID generation."""
        uid = self.id_gen.generate_uuid()
        self.assertIsInstance(uid, str)
        self.assertEqual(len(uid), 36)

    def test_timestamp_provider(self):
        """Check ISO timestamp format."""
        ts = self.ts_prov.get_iso_timestamp()
        self.assertIsInstance(ts, str)
        # Check if it ends with 'Z' indicating UTC
        self.assertTrue(ts.endswith('Z'))

if __name__ == "__main__":
    unittest.main()
