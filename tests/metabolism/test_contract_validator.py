import unittest
from metabolism.core.enums import EventSource, Severity
from metabolism.core.contract_validator import ContractValidator

class TestContractValidator(unittest.TestCase):
    """@Why: Validator が Enum 制約と必須フィールドの検証を正しく行うか確認する。"""

    def setUp(self):
        self.validator = ContractValidator()

    def test_validate_event_success(self):
        valid_data = {
            "contract_version": "1.2",
            "event_id": "uuid-1234",
            "timestamp": "2026-06-23T12:34:56Z",
            "source": "terminal",
            "severity": "medium"
        }
        self.assertTrue(self.validator.validate_event(valid_data))

    def test_validate_event_invalid_enum(self):
        invalid_data = {
            "contract_version": "1.2",
            "event_id": "uuid-1234",
            "timestamp": "2026-06-23T12:34:56Z",
            "source": "unknown_source",  # Invalid enum
            "severity": "medium"
        }
        self.assertFalse(self.validator.validate_event(invalid_data))

    def test_validate_event_missing_field(self):
        incomplete_data = {
            "contract_version": "1.2",
            "event_id": "uuid-1234"
            # missing others
        }
        self.assertFalse(self.validator.validate_event(incomplete_data))

if __name__ == "__main__":
    unittest.main()
