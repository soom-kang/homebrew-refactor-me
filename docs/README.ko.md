![refactor-me](assets/refactor-me-title.png)

# refactor-me Homebrew tap

macOS Apple Silicon에 refactor-me를 설치합니다. Codex 또는 Claude Code가 선택한 Git 저장소의 코드를 격리된 worktree에서 리팩토링하고, 검증을 통과한 커밋을 검토용 로컬 branch에 저장합니다.

[English](../README.md) · [사용법](https://github.com/soom-kang/refactor-me/blob/main/tool/TUTORIAL.ko.md) · [소스](https://github.com/soom-kang/refactor-me)

## 1. 설치

Homebrew, Git, 인증을 마친 Codex 또는 Claude Code CLI와 대상 프로젝트의 빌드 및 테스트 도구를 준비하세요.

[`0.10.0-beta.2`](https://github.com/soom-kang/refactor-me/releases/tag/v0.10.0-beta.2) 릴리스 파일을 공개했습니다. 공개 Homebrew 설치 검증은 아직 대기 중입니다. 릴리스 commit은 `c30dbdadc4229958e29366fdc14d79df3da8cb02`이며 검사가 끝난 뒤 설치 결과를 추가합니다.

```sh
brew tap soom-kang/refactor-me
brew trust --formula soom-kang/refactor-me/refactor-me
brew install refactor-me
refactor-me version --json
```

Homebrew 6 이상에서 tap 등록과 해당 formula의 trust 설정은 처음 한 번만 합니다. 새 환경에서는 먼저 설정해야 짧은 설치 명령으로 refactor-me를 찾을 수 있습니다. formula는 소스 압축파일, SHA-256, commit을 고정하고 Go를 빌드 의존성으로 사용합니다. bottle과 Apple 서명·공증은 제공하지 않습니다.

Skills는 따로 설치합니다. 아래 설치기에는 Node.js가 필요하지만 refactor-me 실행에는 필요하지 않습니다.

```sh
npx skills add soom-kang/sharpen-me \
  --global --skill '*' --agent codex claude-code
```

필수 Skills는 `~/.agents/skills`에서 읽습니다. Homebrew는 Skills나 대상 프로젝트 설정을 설치하지 않습니다.

## 2. 대상 확인

`refactor-me version --json`에 버전 `0.10.0-beta.2`와 commit `c30dbdadc4229958e29366fdc14d79df3da8cb02`가 표시되는지 확인한 뒤 계속하세요. 이전 버전이라면 `brew upgrade refactor-me`로 업데이트합니다. 아래 모델과 추론 수준 옵션은 Beta.2 기능입니다.

경로를 커밋이 하나 이상 있는 깨끗한 Git 저장소로 바꾸세요. 예시는 Codex만 사용합니다. Claude Code의 로컬 준비 상태를 검사하려면 `--provider claude --fallback none`으로 바꿉니다.

```sh
refactor-me init --repo /path/to/target-repo
refactor-me doctor --repo /path/to/target-repo \
  --provider codex --fallback none --no-live-probe
```

`init`은 기존 설정을 보존합니다. 실행을 막는 `FAIL` 항목을 해결한 뒤 다음 단계로 넘어가세요. 위 doctor는 모델을 호출하지 않습니다. 기본 doctor 검사와 `run`은 provider 사용량을 소비합니다.

## 3. 실행과 결과 확인

**실행 전에 [첫 실행 제한](https://github.com/soom-kang/refactor-me/blob/main/tool/TUTORIAL.ko.md#set-limits-and-run)을 설정하세요.** 시간 제한은 금액 상한이 아닙니다.

```sh
refactor-me run --repo /path/to/target-repo \
  --provider codex --fallback none \
  --model gpt-6.1-sol --effort xhigh
refactor-me report --repo /path/to/target-repo --lang ko
```

선택한 provider마다 명령이나 프로젝트 설정으로 모델을 지정하세요. 생성되는 모델 필드는 비어 있으며 고정 기본 모델은 없습니다. CLI 값이 우선하며 설정 파일은 바꾸지 않습니다. 예시의 모델과 추론 수준은 선택값이며 기본값이나 검증한 계정 권한이 아닙니다. Claude Code만 사용하려면 `--provider claude --fallback none --model claude-sonnet-5-5 --effort xhigh`를 지정합니다. fallback을 선택하면 해당 모델도 필요합니다.

`--effort`를 지정하면 이번 명령에서 primary provider의 모든 단계에 같은 추론 수준을 적용합니다. fallback에는 `--fallback-effort`를 사용합니다. 생략하면 설정과 단계별 정책을 유지합니다. 모델을 호출하는 doctor에도 `run`과 같은 모델 지정이 필요합니다. `doctor --no-live-probe`에는 모델이 필요하지 않으며 실제 provider 접근이나 세션의 Skill 로딩을 입증하지 않습니다. [모델과 추론 수준 선택](https://github.com/soom-kang/refactor-me/blob/main/tool/README.ko.md#model-and-effort-selection)을 참고하세요.

종료 코드 `0`에도 부분 완료가 포함됩니다. 보고서, diff, 로컬 결과 branch를 검토한 뒤 직접 병합하세요. CLI는 자동 병합, push, 배포를 하지 않습니다.

## 업데이트와 제거

`brew upgrade refactor-me`는 모든 프로젝트가 사용하는 실행 파일을 갱신합니다. 업데이트 후 모델 호출 없는 doctor 검사를 반복하세요. 전역 Skills는 실행 사이에 따로 갱신합니다. `brew uninstall refactor-me` 후에도 프로젝트 설정, 보고서, worktree, 결과 branch, 전역 Skills는 남습니다.

formula 관리는 [배포 절차](https://github.com/soom-kang/refactor-me/blob/main/tool/release/HOMEBREW.ko.md)를 따릅니다. 직접 다운로드와 macOS 경고 대응은 [설치 안내](https://github.com/soom-kang/refactor-me/blob/main/tool/release/INSTALL.ko.md)를 참고하세요.

## 라이선스

이 tap은 [MIT License](../LICENSE)를 따르며 저작권은 soom-kang에게 있습니다(2026). 재배포할 때 저작권과 라이선스 고지를 포함해야 합니다. 소프트웨어는 보증 없이 제공됩니다.

CLI에는 [별도의 MIT 라이선스](https://github.com/soom-kang/refactor-me/blob/main/LICENSE)가 있습니다. sharpen-me는 자체 라이선스를, Codex와 Claude Code는 각 provider의 약관을 따릅니다.
