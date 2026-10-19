class RefactorMe < Formula
  desc "Automated refactoring with isolated Git worktrees and global sharpen-me skills"
  homepage "https://github.com/soom-kang/refactor-me"
  url "https://github.com/soom-kang/refactor-me/releases/download/v0.10.0-beta.10/refactor-me_0.10.0-beta.10_source.tar.gz"
  sha256 "c7e41a880c147853b86633802aed3b103c964a32c5d17645462f632e223e670e"
  license "MIT"

  depends_on "go" => :build
  depends_on arch: :arm64
  depends_on :macos

  def install
    cd "tool/go" do
      system "go", "build", "-trimpath", "-buildvcs=false",
             "-ldflags=-s -w -X main.version=#{version} -X main.commit=89f47d831d63fad2d4c9246daf7f0513ffafc591",
             "-o", bin/"refactor-me", "./cmd/refactor-me"
    end
  end

  def caveats
    <<~EOS
      Install the required global sharpen-me skills separately; this formula does not modify your home directory.
      Git, an authenticated Codex or Claude CLI, and your target project's validation tools are required.
      See https://github.com/soom-kang/refactor-me#quick-start
      This beta does not provide Apple signing or notarization.
    EOS
  end

  test do
    require "json"
    info = JSON.parse(shell_output("#{bin}/refactor-me version --json"))
    assert_equal version.to_s, info.fetch("version")
    assert_equal "89f47d831d63fad2d4c9246daf7f0513ffafc591", info.fetch("commit")
    assert_match "refactor-me", shell_output((bin/"refactor-me").to_s)
    repo = testpath/"target repo"
    system "git", "init", "-q", repo
    system bin/"refactor-me", "init", "--repo", repo
    config_path = repo/".refactor/config.json"
    config = JSON.parse(config_path.read)
    assert_equal 2, config.fetch("schema_version")
    assert_empty config.fetch("agents").fetch("codex").fetch("model")
    assert_empty config.fetch("agents").fetch("claude").fetch("model")
    assert_path_exists repo/".refactor/runs"
    refute_path_exists repo/".refactor/bin"
    config.fetch("policy")["max_cycles"] = 1
    config_path.open("w") { |file| file.write JSON.pretty_generate(config) + "\n" }
    config_before = config_path.read
    system bin/"refactor-me", "init", "--repo", repo
    assert_equal config_before, config_path.read
  end
end
