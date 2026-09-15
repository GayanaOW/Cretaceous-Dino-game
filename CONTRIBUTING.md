# Contributing

## Branching strategy
- `main` is protected — no direct commits. All changes go through a pull request.
- Branch naming convention:
  - `feature/<short-description>` — new functionality
  - `fix/<short-description>` — bug fixes
  - `chore/<short-description>` — tooling, deps, cleanup
  - `infra/<short-description>` — CI/CD, Docker, AWS changes

## Workflow
1. Create a branch off `main`: `git checkout -b feature/my-change`
2. Make your changes, with clear, small commits.
3. Push and open a pull request against `main`. The PR template will guide you.
4. CI must pass (lint + tests) before merge.
5. At least one CODEOWNER review is required before merge.
6. Squash-merge once approved; delete the branch after merge.

## Commit message style
Use conventional commits:
- `feat: add summarization endpoint`
- `fix: handle empty prompt input`
- `chore: bump dependency versions`
- `ci: add docker build step`
- `docs: update README setup steps`

## Code style
- Python code is linted with `ruff`. Run `ruff check .` before pushing.
- Add/update tests for any behavior change under `tests/`.