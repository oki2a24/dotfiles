import os
from pathlib import Path

def inject_identity(**kwargs):
    """
    identity.md の内容をコンテキストとして注入するプロトコル。
    """
    # プロファイルディレクトリからの相対パス、または絶対パスで指定
    # ここでは明示的にプロジェクトルートから探す構成とする
    identity_path = Path("/Users/oki2a24/dotfiles/hermes_profiles/softwareengineer/identity.md")

    if not identity_path.exists():
        # 見つからない場合は何もせず、エージェントの継続を維持する（Atomicity）
        return {}

    try:
        with open(identity_path, 'r', encoding='utf-8') as f:
            content = f.read().strip()
        
        if not content:
            return {}

        # LLMに対して「これがあなたのアイデンティティである」ことを強力に定義するためのフォーマット
        formatted_context = f"\n### [CORE IDENTITY RULES]\n{content}\n---------------------------\n"
        
        return {
            "context": formatted_context
        }
    except Exception as e:
        # エラーが発生した場合は、デバッグ情報をコンテキストに含めても良いが、
        # 本番では静かに無視するかログに留めるのがエージェントの規律
        return {}

def register(ctx):
    # pre_llm_call フックを使用して、各ターン（turn）の直前に注入する
    ctx.register_hook("pre_llm_call", inject_identity)
