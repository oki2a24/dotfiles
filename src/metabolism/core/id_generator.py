import uuid

import uuid

class IdGenerator:
    """@Why: システム全体で衝突を防ぐために、事実に基づいた一意な識別子を生成する必要がある。

    UUID (Version 4) を使用して、推測不可能な一意のIDを提供する。
    """

    def generate_uuid(self) -> str:
        """
        UUID (Version 4) を生成して返す。

        Returns:
            str: 生成された UUID 文字列。
        """
        return str(uuid.uuid4())
