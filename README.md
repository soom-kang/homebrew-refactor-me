![refactor-me](docs/assets/refactor-me-title.png)

# refactor-me Homebrew tap

[![Release](https://img.shields.io/badge/Release-0.10.0--beta.6-2f6f5e)](https://github.com/soom-kang/refactor-me/releases/tag/v0.10.0-beta.6) [![CLI Verify](https://img.shields.io/github/actions/workflow/status/soom-kang/refactor-me/verify.yml?branch=main&label=CLI%20Verify)](https://github.com/soom-kang/refactor-me/actions/workflows/verify.yml) [![MIT License](https://img.shields.io/badge/License-MIT-555555)](LICENSE)

Install refactor-me on macOS Apple Silicon. The CLI uses Codex or Claude Code to refactor a chosen Git repository in an isolated worktree, then saves accepted commits on a local branch for review.

원하는 Git 저장소를 선택해 리팩토링하고, 검증을 통과한 변경을 로컬 branch에서 검토합니다.

[한국어](docs/README.ko.md) · [Usage guide](https://github.com/soom-kang/refactor-me/blob/main/tool/TUTORIAL.md) · [Source](https://github.com/soom-kang/refactor-me)

## 1. Install

Prepare Homebrew, Git, an authenticated Codex or Claude Code CLI, and the target project's build/test tools.

The current public Beta is [`0.10.0-beta.6`](https://github.com/soom-kang/refactor-me/releases/tag/v0.10.0-beta.6), commit `01b407ce81e9803878c003c181860e499718b0fa`.

[CLI source verification](https://github.com/soom-kang/refactor-me/actions/runs/37625020035), [fresh installation](https://github.com/soom-kang/refactor-me/actions/runs/37625488585) and [Beta.5 → Beta.6 upgrade](https://github.com/soom-kang/refactor-me/actions/runs/37625494290) checks passed. The upgrade check preserved its configuration schema 2 and seeded report schema 3 fixtures, and rejected an unsupported report without changing it. Neither public installation check calls provider models. The CLI Verify badge follows the CLI repository's `main` workflow; it does not certify tap CI or live provider execution.

```sh
brew tap soom-kang/refactor-me
brew trust --formula soom-kang/refactor-me/refactor-me
brew install refactor-me
refactor-me version --json
```

Register the tap and trust only this formula once with Homebrew 6 or later. A new Homebrew installation needs this setup before the short command can resolve refactor-me. The formula fixes the source archive, SHA-256 and commit, and uses Go as a build dependency. No bottle, Apple signing or notarization is provided.

Install the pinned sharpen-me [Skill reference](https://github.com/soom-kang/refactor-me/blob/main/tool/release/INSTALL.md#skill-reference) globally before doctor. Follow the Git-only installation steps; Node.js is not required. The procedure stops if a named Skill or source checkout already exists, preserving existing and custom installations for your review between runs.

Required Skills resolve from `~/.agents/skills`. Homebrew does not install Skills or write target-project settings.

## 2. Check your target

Confirm `refactor-me version --json` reports `0.10.0-beta.6` and commit `01b407ce81e9803878c003c181860e499718b0fa`. Upgrade an older installation with `brew upgrade refactor-me` before using the commands below.

Replace the path with a clean Git repository that has at least one commit. These examples use Codex only. For a local Claude Code check, use `--provider claude --fallback none` instead.

```sh
refactor-me init --repo /path/to/target-repo
refactor-me doctor --repo /path/to/target-repo \
  --provider codex --fallback none --no-live-probe
```

`init` preserves existing settings. Resolve blocking `FAIL` checks before continuing. This doctor command makes no model calls. Default doctor checks and `run` consume provider usage.

The `skill-reference` diagnostic reports `PASS` for reference content match and nonblocking `WARN` for valid custom content. This compares the eight full Skill trees; it does not prove live Skill loading or model behavior. Live provider compatibility for the reference is `NOT_RUN`. See the [Skill reference contract](https://github.com/soom-kang/refactor-me/blob/main/tool/release/INSTALL.md#skill-reference) for catalog failures and installation conflicts.

## 3. Run and inspect

**Set [first-run limits](https://github.com/soom-kang/refactor-me/blob/main/tool/TUTORIAL.md#set-limits-and-run) before running.** Time limits are not monetary caps.

```sh
refactor-me run --repo /path/to/target-repo \
  --provider codex --fallback none \
  --model gpt-6.1-sol --effort xhigh --max-minutes 60
refactor-me report --repo /path/to/target-repo
```

`--max-minutes 60` sets a 60-minute soft limit for this run without changing project settings. The limit is checked at audit and candidate boundaries; a work unit already underway can finish later. Without the option, macOS asks you to choose a duration when stdin and stderr are terminals. Enter keeps the configured limit, which defaults to 180 minutes. Redirected and `--json` runs use configuration without prompting. The report records the selected limit and actual duration. See [run time selection](https://github.com/soom-kang/refactor-me/blob/main/tool/README.md#run-time-selection).

Choose a model for every selected provider in the command or project configuration. Generated model fields are empty; there is no fixed model default. CLI values take precedence and do not change configuration files. These model and effort values are example choices, not defaults or verified account access. For Claude Code alone, use `--provider claude --fallback none --model claude-sonnet-5-5 --effort xhigh`. Fallback requires its own model choice.

An explicit `--effort` applies to every phase for the primary provider in this command; `--fallback-effort` does the same for the fallback. Omitting these options keeps the configured and phase effort policy. Live doctor needs the same model selection as `run`; offline `doctor --no-live-probe` needs no model and does not prove live provider access or Skill loading. See [model and effort selection](https://github.com/soom-kang/refactor-me/blob/main/tool/README.md#model-and-effort-selection).

Exit `0` can mean partial completion. Inspect the report, diff and local result branch before merging. The CLI does not merge, push or deploy results.

## Review changes and costs

Open `.refactor/runs/<id>/changes.md` in a Markdown editor to review the file checklist, additions/deletions and full text diff. Checkboxes record review progress; they do not include or exclude changes from the result branch. `changes.patch` stays unchanged, and binary changes show metadata. See [code comparison](https://github.com/soom-kang/refactor-me/blob/main/tool/README.md#code-comparison).

Reports separate provider-reported USD and estimated USD. When a supported model does not report a price, bundled [Artificial Analysis](https://artificialanalysis.ai/) rates estimate standard API cost and record the sources, checked date and assumptions. Supported IDs are Codex `gpt-5.6-sol`, Codex `gpt-6.1-sol` and Claude `claude-sonnet-5-5`. Unknown models or missing/invalid usage remain unpriced. This estimate does not calculate subscription or credit charges. Read [usage and exit codes](https://github.com/soom-kang/refactor-me/blob/main/tool/README.md#usage-and-exit-codes) before treating a partial amount as a bill.

## Progress logs

Public Beta `0.10.0-beta.6` shows elapsed time, the current stage, provider, candidate and confirmed result. The existing `--lang en|ko` also selects progress language, defaulting to English; add `--lang ko` for Korean.

Progress uses `stderr`, leaving `run --json` report JSON alone on `stdout`. Structured provider events identify reads, searches, edits and other tool activity, with safe worktree-relative paths when available. Command activity stays generic; logs omit sensitive or outside-worktree paths, search patterns, command arguments, output and provider prose. Provider completion reports measured duration, tool-event count and exit status.

Each audit reports proposed and eligible candidates, with the inspected count when capped. Long stages report elapsed time every 30 seconds. Provider transcripts and validation output remain in local run records. See the [progress reference](https://github.com/soom-kang/refactor-me/blob/main/tool/README.md#progress-logs) for result and failure messages.

## Stopping and failed runs

Ctrl-C or SIGTERM during `run` or `doctor` cancels managed provider and validation processes and stops retries and fallback. Accepted commits remain intact; an unfinished worktree stays available for inspection. SIGKILL cannot provide cleanup guarantees.

If a controller preparation failure is recorded before a final report, `report` returns exit `2` and shows that failure. Earlier completed reports stay in their original run directories; a later completed run clears the failure marker. Pre-controller CLI/configuration/input errors and a failed marker write do not replace the previous result pointer. Inspect stderr and available diagnostics before retrying. See [interruption and failed attempts](https://github.com/soom-kang/refactor-me/blob/main/tool/README.md#interruption-and-failed-attempts).

## Update or remove

`brew upgrade refactor-me` updates the executable shared by every project. Repeat offline doctor after upgrading. Update global Skills separately, between runs. `brew uninstall refactor-me` keeps project settings, reports, worktrees, result branches and global Skills.

Use the [release procedure](https://github.com/soom-kang/refactor-me/blob/main/tool/release/HOMEBREW.md) to maintain the formula. For downloaded binaries and macOS warnings, see [installation details](https://github.com/soom-kang/refactor-me/blob/main/tool/release/INSTALL.md).

## License

This tap uses the [MIT License](LICENSE), copyright 2026 soom-kang. Retain the copyright and license notice when redistributing it. The software comes without warranty.

The CLI has its [own MIT license](https://github.com/soom-kang/refactor-me/blob/main/LICENSE). sharpen-me retains its own license; Codex and Claude Code follow their providers' terms.
