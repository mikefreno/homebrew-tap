class Podtui < Formula
  desc "Keyboard-first terminal podcast client (yazi-style, OpenTUI)"
  homepage "https://github.com/mikefreno/podtui"

  # PodTUI ships per-arch macOS tarballs. `Hardware::CPU.arm?` selects the
  # matching asset at formula-resolve time, so `brew install` works on both
  # Apple Silicon and Intel Macs.
  if Hardware::CPU.arm?
    url "https://github.com/mikefreno/podtui/releases/download/v0.9.1/podtui-darwin-arm64.tar.gz"
    sha256 "c5eae5e076d8febeb5d31a8e6c80b05e542fd8310b69622cbb82fb0e636a0c13"
  else
    url "https://github.com/mikefreno/podtui/releases/download/v0.9.1/podtui-darwin-x64.tar.gz"
    sha256 "33a79d3e884b5f27627469fdf3cb1a5d350ebe54175b93f89c00fddb900f9ac5"
  end

  depends_on "mpv"

  # The app bundle ships dylibs (libopentui, libcavacore) with @rpath IDs and
  # no headerpad. Keep them: brew's post-install linkage fix rewrites dylib
  # IDs to absolute opt paths, which doesn't fit their load-commands header
  # ("needs to be relinked, possibly with -headerpad").
  preserve_rpath

  def install
    # The binary and its two FFI libs (libopentui, libcavacore) must stay
    # SIBLINGS: the loaders resolve them relative to dirname(execPath). Keep
    # everything under libexec and expose only a `podtui` symlink on PATH.
    sub = Dir["podtui-darwin-*"].find { |d| File.directory?(d) } || "."
    libexec.install "#{sub}/podtui"
    libexec.install Dir["#{sub}/lib*.dylib"]
    bin.install_symlink libexec / "podtui"
  end

  test do
    assert_match "PodTUI version", shell_output("#{bin}/podtui --version")
  end
end
