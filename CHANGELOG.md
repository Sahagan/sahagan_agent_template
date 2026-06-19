# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.2.2] - 2024-12-19

### Fixed
- Add star count for `ui-ux-pro-max` skill (93k stars) in README skill table

## [1.2.1] - 2024-12-18

### Fixed
- Rename agent `Taitoon` → `Taifoon` (ใต้ฝุ่น) throughout all files
- Add MIT `LICENSE` file to repository

## [1.2.0] - 2024-12-17

### Added
- **OpenAI Codex support** — `AGENTS.md` for Codex, `CLAUDE.md` for Claude Code, or both
- **Language selection** — English directive prepended to all instruction files when chosen
- **`aw upgrade` command** — upgrade existing workspace to latest template version with backup
- **Agent skills** — auto-install from top open-source skill repos at init time:
  - `planning-and-task-breakdown` (addyosmani/agent-skills)
  - `code-review-and-quality` (addyosmani/agent-skills)
  - `security-and-hardening` (addyosmani/agent-skills)
  - `ponytail` + `ponytail-review` + `ponytail-audit` (DietrichGebert/ponytail)
  - `ui-ux-pro-max` (nextlevelbuilder/ui-ux-pro-max-skill)
- **`aw help` command** — full help page with commands, prompts, and skills

## [1.0.1] - 2024-12-10

### Changed
- README updated to npm-only usage (no GitHub clone required)
- Template uses `claude -p` spawn pattern for real OS subprocess visibility

## [1.0.0] - 2024-12-01

### Added
- Initial release of `sahagan-agents-workflow` npm package
- Bundle template inside npm package (no internet required at init)
- Four-cat agent family: Angpao (Orchestrator), Phayu (Dev Lead), Taifoon (QA Lead), Timsum (UX/UI)
- `aw init <project-name>` CLI command
- VS Code `.code-workspace` file generation
- Local git repo initialization

[1.2.2]: https://github.com/Sahagan/sahagan_agent_template/compare/v1.2.1...v1.2.2
[1.2.1]: https://github.com/Sahagan/sahagan_agent_template/compare/v1.2.0...v1.2.1
[1.2.0]: https://github.com/Sahagan/sahagan_agent_template/compare/v1.0.1...v1.2.0
[1.0.1]: https://github.com/Sahagan/sahagan_agent_template/compare/v1.0.0...v1.0.1
[1.0.0]: https://github.com/Sahagan/sahagan_agent_template/releases/tag/v1.0.0
