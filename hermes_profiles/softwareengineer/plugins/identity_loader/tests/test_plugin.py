import unittest
from unittest.mock import MagicMock, patch
from pathlib import Path
import sys
import os

# プラグインのディレクトリをPYTHONPATHに追加してインポート可能にする
plugin_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), "../../plugins/identity-loader"))
if plugin_dir not in sys.path:
    sys.path.insert(0, plugin_dir)

from __init__ import inject_identity, register

class TestIdentityLoader(unittest.TestCase):
    def setUp(self):
        # Standard path used in the plugin for testing purposes
        self.test_identity_path = Path("/Users/oki2a24/dotfiles/hermes_profiles/softwareengineer/identity.md")
        self.content = "Test Identity Content"

    def test_inject_identity_success(self):
        """identity.md が存在し、内容がある場合に正しくコンテキストを返すかテスト"""
        with patch("builtins.open", unittest.mock.mock_open(read_data=self.content)):
            with patch("pathlib.Path.exists", return_value=True):
                result = inject_identity()
                self.assertIn("context", result)
                self.assertIn("### [CORE IDENTITY RULES]\n" + self.content, result["context"])

    def test_inject_identity_empty(self):
        """identity.md が空の場合、空の辞書を返すかテスト"""
        with patch("builtins.open", unittest.mock.mock_open(read_data="  ")):
            with patch("pathlib.Path.exists", return_value=True):
                result = inject_identity()
                self.assertEqual(result, {})

    def test_inject_identity_missing_file(self):
        """identity.md が存在しない場合、空の辞書を返しエラーにならないかテスト"""
        with patch("pathlib.Path.exists", return_value=False):
            result = inject_identity()
            self.assertEqual(result, {})

    def test_inject_identity_exception(self):
        """ファイル読み込み中に例外が発生した場合、安全に空の辞書を返すかテスト"""
        with patch("builtins.open", side_effect=Exception("File error")):
            with patch("pathlib.Path.exists", return_value=True):
                result = inject_identity()
                self.assertEqual(result, {})

    def test_register(self):
        """register 関数が ctx.register_hook を正しい引数で呼び出すかテスト"""
        mock_ctx = MagicMock()
        register(mock_ctx)
        mock_ctx.register_hook.assert_called_once_with("pre_llm_call", inject_identity)

if __name__ == "__main__":
    unittest.main()
