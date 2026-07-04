import unittest
from metabolism.core.id_generator import IdGenerator

class TestIdGenerator(unittest.TestCase):
    """@Why: Ensure that the ID generator produces valid UUID strings."""
    def setUp(self):
        self.generator = IdGenerator()

    def test_generate_uuid(self):
        uid = self.generator.generate_uuid()
        self.assertIsInstance(uid, str)
        self.assertEqual(len(uid), 36)

if __name__ == "__main__":
    unittest.main()
