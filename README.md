![refactor-me](docs/assets/refactor-me-title.png)

# refactor-me Homebrew tap

[![Release](https://img.shields.io/badge/Release-0.10.0--beta.2-2f6f5e)](https://github.com/soom-kang/refactor-me/releases/tag/v0.10.0-beta.2) [![CLI Verify](https://img.shields.io/github/actions/workflow/status/soom-kang/refactor-me/verify.yml?branch=main&label=CLI%20Verify)](https://github.com/soom-kang/refactor-me/actions/workflows/verify.yml) [![MIT License](https://img.shields.io/badge/License-MIT-555555)](LICENSE)

Install refactor-me on macOS Apple Silicon. The CLI uses Codex or Claude Code to refactor a chosen Git repository in an isolated worktree, then saves accepted commits on a local branch for review.

원하는 Git 저장소를 선택해 리팩토링하고, 검증을 통과한 변경을 로컬 branch에서 검토합니다.

[한국어](docs/README.ko.md) · [Usage guide](https://github.com/soom-kang/refactor-me/blob/main/tool/TUTORIAL.md) · [Source](https://github.com/soom-kang/refactor-me)

## 1. Install

Prepare Homebrew, Git, an authenticated Codex or Claude Code CLI, and the target project's build/test tools.

The current public Beta is [`0.10.0-beta.2`](https://github.com/soom-kang/refactor-me/releases/tag/v0.10.0-beta.2), commit `c30dbdadc4229958e29366fdc14d79df3da8cb02`. See the [public installation check](https://github.com/soom-kang/refactor-me/actions/runs/36956289983). The CLI Verify badge follows the CLI repository's `main` workflow; it does not certify tap CI or live provider execution.

```sh
brew tap soom-kang/refactor-me
brew trust --formula soom-kang/refactor-me/refactor-me
brew install refactor-me
refactor-me version --json
```

Register the tap and trust only this formula once with Homebrew 6 or later. A new Homebrew installation needs this setup before the short command can resolve refactor-me. The formula fixes the source archive, SHA-256 and commit, and uses Go as a build dependency. No bottle, Apple signing or notarization is provided.

Install Skills separately. This installer needs Node.js; refactor-me itself does not.

```sh
npx skills add soom-kang/sharpen-me \
  --global --skill '*' --agent codex claude-code
```

Required Skills resolve from `~/.agents/skills`. Homebrew does not install Skills or write target-project settings.

## 2. Check your target

Confirm `refactor-me version --json` reports `0.10.0-beta.2` and commit `c30dbdadc4229958e29366fdc14d79df3da8cb02`. Upgrade an older installation with `brew upgrade refactor-me` before using the commands below.

Replace the path with a clean Git repository that has at least one commit. These examples use Codex only. For a local Claude Code check, use `--provider claude --fallback none` instead.

```sh
refactor-me init --repo /path/to/target-repo
refactor-me doctor --repo /path/to/target-repo \
  --provider codex --fallback none --no-live-probe
```

`init` preserves existing settings. Resolve blocking `FAIL` checks before continuing. This doctor command makes no model calls. Default doctor checks and `run` consume provider usage.

## 3. Run and inspect

**Set [first-run limits](https://github.com/soom-kang/refactor-me/blob/main/tool/TUTORIAL.md#set-limits-and-run) before running.** Time limits are not monetary caps.

```sh
refactor-me run --repo /path/to/target-repo \
  --provider codex --fallback none \
  --model gpt-6.1-sol --effort xhigh
refactor-me report --repo /path/to/target-repo
```

Choose a model for every selected provider in the command or project configuration. Generated model fields are empty; there is no fixed model default. CLI values take precedence and do not change configuration files. These model and effort values are example choices, not defaults or verified account access. For Claude Code alone, use `--provider claude --fallback none --model claude-sonnet-5-5 --effort xhigh`. Fallback requires its own model choice.

An explicit `--effort` applies to every phase for the primary provider in this command; `--fallback-effort` does the same for the fallback. Omitting these options keeps the configured and phase effort policy. Live doctor needs the same model selection as `run`; offline `doctor --no-live-probe` needs no model and does not prove live provider access or Skill loading. See [model and effort selection](https://github.com/soom-kang/refactor-me/blob/main/tool/README.md#model-and-effort-selection).

Exit `0` can mean partial completion. Inspect the report, diff and local result branch before merging. The CLI does not merge, push or deploy results.

## Update or remove

`brew upgrade refactor-me` updates the executable shared by every project. Repeat offline doctor after upgrading. Update global Skills separately, between runs. `brew uninstall refactor-me` keeps project settings, reports, worktrees, result branches and global Skills.

Use the [release procedure](https://github.com/soom-kang/refactor-me/blob/main/tool/release/HOMEBREW.md) to maintain the formula. For downloaded binaries and macOS warnings, see [installation details](https://github.com/soom-kang/refactor-me/blob/main/tool/release/INSTALL.md).

## License

This tap uses the [MIT License](LICENSE), copyright 2026 soom-kang. Retain the copyright and license notice when redistributing it. The software comes without warranty.

The CLI has its [own MIT license](https://github.com/soom-kang/refactor-me/blob/main/LICENSE). sharpen-me retains its own license; Codex and Claude Code follow their providers' terms.
