class Jellytui < Formula
  desc "Keyboard-first terminal Jellyfin music client (yazi-style, OpenTUI)"
  homepage "https://github.com/mikefreno/jellytui"

  # JellyTUI ships per-platform tarballs (bun --compile can't cross-compile, so
  # the release workflow builds one per runner). `Hardware::CPU` selects the
  # arm64/x64 asset at formula-resolve time, so `brew install` works natively
  # on Apple Silicon, Intel Macs, and Linux x86_64/aarch64.
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/mikefreno/jellytui/releases/download/v0.1.0/jellytui-darwin-arm64.tar.gz"
    sha256 "6ebb38e12e9fc9f556fa62aeffe65081031e55e4914f65958f1c7193c59d423c"
  elsif OS.mac? && !Hardware::CPU.arm?
    url "https://github.com/mikefreno/jellytui/releases/download/v0.1.0/jellytui-darwin-x64.tar.gz"
    sha256 PLACEHOLDER_DARWIN_X64
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://github.com/mikefreno/jellytui/releases/download/v0.1.0/jellytui-linux-arm64.tar.gz"
    sha256 PLACEHOLDER_LINUX_ARM64
  else
    url "https://github.com/mikefreno/jellytui/releases/download/v0.1.0/jellytui-linux-x64.tar.gz"
    sha256 PLACEHOLDER_LINUX_X64
  end

  # Playback runs through mpv's JSON-IPC socket; mpv is required, not optional.
  depends_on "mpv"

  # libcavacore ships as an @rpath/@loaderdylib; keep brew's post-install
  # linkage fix from rewriting its ID (same reason podtui uses this).
  preserve_rpath

  def install
    # The binary resolves libcavacore.{dylib,so} from dirname(process.execPath)
    # — they must stay SIBLINGS. Keep both under libexec and expose only a
    # `jellytui` symlink on PATH (mirrors the podtui formula).
    sub = Dir["jellytui-{darwin,linux}-*"].find { |d| File.directory?(d) } || "."
    libexec.install "#{sub}/jellytui"
    libexec.install Dir["#{sub}/libcavacore.{dylib,so}"]
    bin.install_symlink libexec / "jellytui"
  end

  test do
    assert_match "0.1.0", shell_output("#{bin}/jellytui --version")
  end
end
