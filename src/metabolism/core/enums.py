from enum import Enum

class EventSource(Enum):
    """@Why: MetabolicEvent の source プロパティの定義。"""
    TERMINAL = "terminal"
    USER_CORRECTION = "user_correction"
    SYSTEM = "system"
    MANUAL = "manual"

class Severity(Enum):
    """@Why: 異常の重大度を規定する。"""
    LOW = "low"
    MEDIUM = "medium"
    HIGH = "high"
    CRITICAL = "critical"

class Dimension(Enum):
    """@Why: 問題の性質を分類するための次元。"""
    MECHANICAL = "mechanical"
    COGNITIVE = "cognitive"
    OPERATIONAL = "operational"

class CauseTypeMechanical(Enum):
    TEST_FAILURE = "test_failure"
    BUILD_FAILURE = "build_failure"
    MISSING_DEPENDENCY = "missing_dependency"
    RUNTIME_ERROR = "runtime_error"

class CauseTypeCognitive(Enum):
    INSTRUCTION_MISREAD = "instruction_misread"
    HALLUCINATION = "hallucination"
    WRONG_ASSUMPTION = "wrong_assumption"

class CauseTypeOperational(Enum):
    MISSING_CHECKLIST = "missing_checklist"
    MISSING_VALIDATION = "missing_validation"
    POOR_TASK_SPLIT = "poor_task_split"

class ActionType(Enum):
    """@Why: Architect が生成する改善アクションの種類。"""
    PATCH = "patch"
    WRITE_FILE = "write_file"
    CREATE_SKILL = "create_skill"
    UPDATE_MEMORY = "update_memory"
    DELETE_SKILL = "delete_skill"
    CREATE_TEST = "create_test"

class Priority(Enum):
    """@Why: 改善アクションの優先順位。"""
    LOW = "low"
    MEDIUM = "medium"
    HIGH = "high"
    CRITICAL = "critical"

class RiskLevel(Enum):
    """@Why: 改善アクションに伴うリスクレベル。"""
    LOW = "low"
    MEDIUM = "medium"
    HIGH = "high"

class EstimatedEffort(Enum):
    """@Why: 実装にかかる見積もり工数。"""
    SMALL = "small"
    MEDIUM = "medium"
    LARGE = "large"

class PatternStatus(Enum):
    """@Why: パターンレコードの現在の状態。"""
    ACTIVE = "active"
    RETIRED = "retired"

class ObsolescenceDecisionType(Enum):
    """@Why: 既存パターンの整理（統合・忘却）の判断結果。"""
    KEEP = "keep"
    MERGE = "merge"
    RETIRE = "retire"
