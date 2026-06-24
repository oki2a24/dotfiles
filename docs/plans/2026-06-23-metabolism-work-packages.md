# 🧬 metabolism Work Packages

> 本ドキュメントは以下の実装ポリシーに従って実行すること。
>
> - 2026-06-23-metabolism-development-policy.md
>
> 特に以下は必須である。
>
> - Contract First
> - Test First
> - Red-Green-Refactor
> - 1 Work Package = 1責務
> - リファクタリングの省略禁止
>
> Work Package 完了条件は Development Policy に従う。

Date: 2026-06-23

Version: v2.0

Status: Draft

Purpose:

ローカルLLMに実装させるための最小実行単位へ分解する。

ルール:

- 1 Work Package = 1責務
- 1 Work Package = 1成果物
- 1 Work Package = 1テスト
- 依存関係を明示する

---

# Phase 1: Project Skeleton

## WP-001

Create project root structure

Output:

```text
src/
tests/
.history/
```

Depends On:

なし

---

## WP-002

Create contracts package

Output:

```text
src/contracts/
```

---

## WP-003

Create core package

Output:

```text
src/core/
```

---

## WP-004

Create observer package

Output:

```text
src/observer/
```

---

## WP-005

Create philosopher package

Output:

```text
src/philosopher/
```

---

## WP-006

Create architect package

Output:

```text
src/architect/
```

---

## WP-007

Create historian package

Output:

```text
src/historian/
```

---

## WP-008

Create apoptosis package

Output:

```text
src/apoptosis/
```

---

## WP-009

Create metabolism package

Output:

```text
src/metabolism/
```

---

# Phase 2: Contracts

## WP-010

Implement MetabolicEvent DTO

---

## WP-011

Implement MetabolicEvent Serializer

---

## WP-012

Implement MetabolicEvent Test

---

## WP-013

Implement RootCause DTO

---

## WP-014

Implement RootCause Serializer

---

## WP-015

Implement RootCause Test

---

## WP-016

Implement ActionPlan DTO

---

## WP-017

Implement ActionPlan Serializer

---

## WP-018

Implement ActionPlan Test

---

## WP-019

Implement PatternRecord DTO

---

## WP-020

Implement PatternRecord Serializer

---

## WP-021

Implement PatternRecord Test

---

## WP-022

Implement ObsolescenceDecision DTO

---

## WP-023

Implement ObsolescenceDecision Serializer

---

## WP-024

Implement ObsolescenceDecision Test

---

# Phase 3: Core Layer

## WP-025

Implement UUID Generator

---

## WP-026

Implement UUID Generator Test

---

## WP-027

Implement Timestamp Provider

---

## WP-028

Implement Timestamp Provider Test

---

## WP-029

Implement Enums

---

## WP-030

Implement Enum Tests

---

## WP-031

Implement Contract Validator

---

## WP-032

Implement Contract Validator Tests

---

# Phase 4: Observer

## WP-033

Implement EventDetector

---

## WP-034

Implement EventDetector Test

---

## WP-035

Implement SeverityClassifier

---

## WP-036

Implement SeverityClassifier Test

---

## WP-037

Implement ObservationFactory

---

## WP-038

Implement ObservationFactory Test

---

## WP-039

Implement Observer Facade

---

## WP-040

Implement Observer Integration Test

---

# Phase 5: Philosopher

## WP-041

Implement DimensionClassifier

---

## WP-042

Implement Mechanical Rules

---

## WP-043

Implement Cognitive Rules

---

## WP-044

Implement Operational Rules

---

## WP-045

Implement DimensionClassifier Test

---

## WP-046

Implement CauseTypeClassifier

---

## WP-047

Implement CauseTypeClassifier Test

---

## WP-048

Implement ConfidenceCalculator

---

## WP-049

Implement ConfidenceCalculator Test

---

## WP-050

Implement RootCauseFactory

---

## WP-051

Implement RootCauseFactory Test

---

## WP-052

Implement Philosopher Facade

---

## WP-053

Implement Philosopher Integration Test

---

# Phase 6: Architect

## WP-054

Implement ActionSelector

---

## WP-055

Implement Action Mapping Rules

---

## WP-056

Implement PriorityCalculator

---

## WP-057

Implement RiskAssessor

---

## WP-058

Implement ActionPlanFactory

---

## WP-059

Implement ActionPlanFactory Test

---

## WP-060

Implement Architect Facade

---

## WP-061

Implement Architect Integration Test

---

# Phase 7: Historian

## WP-062

Implement PatternRepository Interface

---

## WP-063

Implement JSON PatternRepository

---

## WP-064

Implement PatternRepository Tests

---

## WP-065

Implement PatternMatcher

Purpose:

既存Pattern検索

---

## WP-066

Implement PatternMatcher Tests

---

## WP-067

Implement Pattern Similarity Rules

---

## WP-068

Implement PatternUpdater

Purpose:

observed_count更新

success_count更新

---

## WP-069

Implement PatternUpdater Tests

---

## WP-070

Implement PatternFactory

Purpose:

新規Pattern生成

---

## WP-071

Implement PatternFactory Tests

---

## WP-072

Implement Historian Facade

---

## WP-073

Implement Historian Integration Test

---

# Phase 8: Apoptosis

## WP-074

Implement MergeEvaluator

---

## WP-075

Implement MergeEvaluator Tests

---

## WP-076

Implement RetireEvaluator

---

## WP-077

Implement RetireEvaluator Tests

---

## WP-078

Implement Forgetting Rule F01

180日未使用

---

## WP-079

Implement Forgetting Rule F02

success_rate < 0.30

---

## WP-080

Implement Forgetting Rule F03

merged pattern

---

## WP-081

Implement DecisionEngine

---

## WP-082

Implement DecisionFactory

---

## WP-083

Implement Apoptosis Facade

---

## WP-084

Implement Apoptosis Integration Test

---

# Phase 9: Storage

## WP-085

Create .history/events

---

## WP-086

Create .history/root_causes

---

## WP-087

Create .history/actions

---

## WP-088

Create .history/patterns

---

## WP-089

Create .history/decisions

---

## WP-090

Implement JSON Storage Tests

---

# Phase 10: Integration

## WP-091

Implement Pipeline

---

## WP-092

Implement Orchestrator

---

## WP-093

Connect Observer → Philosopher

---

## WP-094

Connect Philosopher → Architect

---

## WP-095

Connect Architect → Historian

---

## WP-096

Connect Historian → Apoptosis

---

## WP-097

Implement Full Integration Test

---

# Phase 11: End-to-End

## WP-098

Scenario:

ModuleNotFoundError

Expected:

dependency_validation

---

## WP-099

Scenario:

Instruction Misread

Expected:

dimension=cognitive

---

## WP-100

Scenario:

Poor Task Split

Expected:

dimension=operational

---

## WP-101

Scenario:

Repeated ImportError

Expected:

Pattern Merge Candidate

---

## WP-102

Scenario:

Unused Pattern > 180 days

Expected:

Retire Candidate

---

## WP-103

Scenario:

Low Success Rate Pattern

Expected:

Retire Candidate

---

# Exit Criteria

全WP完了時:

- Contract Test Success
- Unit Test Success
- Integration Test Success
- E2E Test Success
- JSON Storage Verified
- Pattern Merge Verified
- Forgetting Policy Verified
