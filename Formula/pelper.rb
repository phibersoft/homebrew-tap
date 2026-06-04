class Pelper < Formula
  desc "A terminal DX helper that brings your everyday dev tools into one TUI"
  homepage "https://github.com/phibersoft/pelper"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/phibersoft/pelper/releases/download/v0.2.0/pelper-aarch64-apple-darwin.tar.xz"
      sha256 "13356500ab75b3b5425c4205fba3609478c75f3ef6b750bad1db34e9b86fc3e1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/phibersoft/pelper/releases/download/v0.2.0/pelper-x86_64-apple-darwin.tar.xz"
      sha256 "4790e3f073e14ee5352ef17b02967f2ea584479a07a8c8b8758a6bb8b06d263f"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":  {},
    "x86_64-apple-darwin":   {},
    "x86_64-pc-windows-gnu": {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "pelper" if OS.mac? && Hardware::CPU.arm?
    bin.install "pelper" if OS.mac? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
