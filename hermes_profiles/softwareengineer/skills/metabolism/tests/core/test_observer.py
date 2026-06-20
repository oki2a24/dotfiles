import unittest
from datetime import datetime
from hermes_profiles.softwareengineer.skills.metabolism.core.observer import Observer, MetabolicEvent, ErrorDimension

class TestObserver(unittest.TestCase):
    """Observer クラスのテストスイート。"""

    def setUp(self):
        self.observer = Observer()

    def test_parse_terminal_error(self):
        """終了コードが非ゼロの場合、MECHANICAL なエラーイベントが生成されることを検証する。"""
        tool_result = {
            "exit_code": 1,
            "output": "Error: command not found"
        }
        event = self.observer.parse_terminal_output(tool_result)
        self.assertIsNotNone(event)
        self.assertIsInstance(event, MetabolicEvent)
        self.assertEqual(event.dimension, ErrorDimension.MECHANICAL)
        self.assertEqual(event.source, "terminal")
        # 実装に合わせて日本語のメッセージを検証する。
        self.assertIn("コマンドが非ゼロのステータスで終了しました (status: 1)", event.issue_description)

    def test_detect_user_correction(self):
        """ユーザーの訂正キーワードが含まれる場合、COGNITIVE なエラーイベントが生成されることを検証する。"""
        text = "No, that's wrong!"
        event = self.observer.detect_user_correction(text)
        self.assertIsNotNone(event)
        self.assertEqual(event.dimension, ErrorDimension.COGNITIVE)
        self.assertEqual(event.source, "user_correction")
        # 実装に合わせて日本語のメッセージを検証する。
        self.assertIn("ユーザーによる訂正を検知しました", event.issue_description)

    def test_parse_terminal_success(self):
        """終了コードがゼロの場合、イベントは生成されない（None が返る）ことを検証する。"""
        tool_result = {
            "exit_code": 0,
            "output": "Success!"
        }
        event = self.observer.parse_terminal_output(tool_result)
        self.assertIsNone(event)

if __name__ == "__main__":
    unittest.main()
