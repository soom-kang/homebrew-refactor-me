# refactor-me Homebrew tap

Source-built public Beta for macOS Apple Silicon.

```sh
brew install soom-kang/refactor-me/refactor-me
refactor-me version --json
```

The formula pins the source archive, SHA-256 and release commit. Homebrew installs Go as a build dependency. Runtime prerequisites are Git, an authenticated Codex or Claude CLI, and your target project's validation tools.

Install the required Skills separately (this command needs Node.js):

```sh
npx skills add \
  https://github.com/soom-kang/sharpen-me/tree/v0.9.0-beta.2 \
  --global --skill '*' --agent codex claude-code
refactor-me init --repo /path/to/target-repo
refactor-me doctor --repo /path/to/target-repo --no-live-probe
```

[Set run limits before starting](https://github.com/soom-kang/refactor-me/blob/v0.10.0-beta.1/tool/TUTORIAL.md#set-limits-and-run). For Codex only:

```sh
refactor-me run --repo /path/to/target-repo --provider codex --fallback none
refactor-me report --repo /path/to/target-repo
```

For Claude only, use `--provider claude --fallback none` with doctor and run. Model calls consume account usage; time limits are not monetary caps.

`brew upgrade soom-kang/refactor-me/refactor-me` updates the CLI shared by every project. `brew uninstall refactor-me` keeps each project's configuration, reports and result branches, and does not remove global Skills.

No bottle, Apple signing or notarization is provided by this Beta. Formula source and generation are maintained in [refactor-me](https://github.com/soom-kang/refactor-me/tree/v0.10.0-beta.1/tool/release).
