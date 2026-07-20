class GitMultirepo < Formula
  desc "Manifest-driven multi-repo git plugin"
  homepage "https://github.com/nicolaei/git-multirepo"
  version "0.3.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/nicolaei/git-multirepo/releases/download/v0.3.1/git-multirepo-aarch64-apple-darwin.tar.xz"
      sha256 "fd6029707dc4f1656f35cc9f9607df1a8984f2a375f15490b5c19710c18061a5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nicolaei/git-multirepo/releases/download/v0.3.1/git-multirepo-x86_64-apple-darwin.tar.xz"
      sha256 "a8655108fa42ced96ae44e639033bf2d5b8b4348344033318b025f0ee4d0ec26"
    end
  end
  license "MPL-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "x86_64-apple-darwin":  {},
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
    bin.install "git-multirepo" if OS.mac? && Hardware::CPU.arm?
    bin.install "git-multirepo" if OS.mac? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
