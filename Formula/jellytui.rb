class Jellytui < Formula
  desc "Keyboard-first terminal Jellyfin music client (yazi-style, OpenTUI)"
  homepage "https://github.com/mikefreno/jellytui"
  version "0.1.0"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mikefreno/jellytui/releases/download/v0.1.0/jellytui-darwin-arm64.tar.gz"
      sha256 "faf6c663ec2c6eb4ded5f2d26af8557f5e003ff3d0411d887c07ea6c7b634dd7"
    else
      url "https://github.com/mikefreno/jellytui/releases/download/v0.1.0/jellytui-darwin-x64.tar.gz"
      sha256 "PLACEHOLDER_DARWIN_X64"
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mikefreno/jellytui/releases/download/v0.1.0/jellytui-linux-arm64.tar.gz"
      sha256 "PLACEHOLDER_LINUX_ARM64"
    else
      url "https://github.com/mikefreno/jellytui/releases/download/v0.1.0/jellytui-linux-x64.tar.gz"
      sha256 "PLACEHOLDER_LINUX_X64"
    end
  end

  # Playback runs through mpv's JSON-IPC socket; mpv is required, not optional.
  depends_on "mpv"

  # libcavacore ships as an @rpath/@loader dylib; keep brew's post-install
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