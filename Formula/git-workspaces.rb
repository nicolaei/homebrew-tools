class GitWorkspaces < Formula
  desc "Manifest-driven multi-repo git plugin"
  homepage "https://github.com/nicolaei/git-workspaces"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/nicolaei/git-workspaces/releases/download/v0.1.0/git-workspaces-aarch64-apple-darwin.tar.xz"
      sha256 "ab0490eb53656accfb6f791cc3fe1a53f1263dba44f9f4f9c12965da4ac9ddc7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nicolaei/git-workspaces/releases/download/v0.1.0/git-workspaces-x86_64-apple-darwin.tar.xz"
      sha256 "17379d8551373f4ca7b72a0d9f121b28a0f00c33c2f2df41565e72b0665c229a"
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
    bin.install "git-workspaces" if OS.mac? && Hardware::CPU.arm?
    bin.install "git-workspaces" if OS.mac? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
