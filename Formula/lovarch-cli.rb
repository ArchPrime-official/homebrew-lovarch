class LovarchCli < Formula
  desc "AI-powered architectural project execution CLI by Lovarch"
  homepage "https://github.com/ArchPrime-official/lovarch-cli"
  url "https://github.com/ArchPrime-official/lovarch-cli/archive/refs/tags/v0.3.4.tar.gz"
  sha256 "4c04e883f64c2bafb29ed67a8377e994d16c22fa9173072a9adfca9ffd92c05b"
  license "MIT"
  head "https://github.com/ArchPrime-official/lovarch-cli.git", branch: "main"

  depends_on "python@3.12"

  # Style choice: homebrew-core formulas list every Python dependency as a
  # `resource` block with pinned SHA256s. This tap does NOT follow that
  # convention — we install deps via `pip` from PyPI at install time. This is
  # acceptable for a custom tap (not homebrew-core) and keeps maintenance
  # cheap during the BETA. When the CLI graduates to homebrew-core, we'll
  # generate proper resource blocks via `homebrew-pypi-poet` or
  # `brew bump-formula-pr`.

  def install
    python = Formula["python@3.12"].opt_bin/"python3.12"
    venv_root = libexec/"venv"

    system python, "-m", "venv", venv_root
    system venv_root/"bin/python", "-m", "pip", "install", "--upgrade", "pip", "setuptools", "wheel"
    # Install with the [mcp] extra so `lovarch mcp serve` works out of the box.
    system venv_root/"bin/python", "-m", "pip", "install", "#{buildpath}[mcp]"

    # Symlink primary + alias binaries into Homebrew's bin
    %w[lovarch arch].each do |entrypoint|
      (bin/entrypoint).write_env_script venv_root/"bin/#{entrypoint}",
                                        PATH: "#{venv_root}/bin:$PATH"
    end
  end

  def caveats
    <<~EOS
      lovarch-cli installed.

      Quick start:
        lovarch --version              # → lovarch-cli #{version}
        lovarch info                   # status panel
        lovarch signup                 # FREE mode (own API keys)
        lovarch login --premium        # Premium mode (Lovarch credits)
        lovarch init villa-toscana --sample
        lovarch audit villa-toscana
        lovarch run dal-brief-al-cantiere villa-toscana

      Backward-compat alias: `arch` works as `lovarch`.

      State lives at ~/.lovarch/ — projects, cache, and config.

      Course: https://lovarch.com/corso (€1.497)
      Issues: https://github.com/ArchPrime-official/lovarch-cli/issues
    EOS
  end

  test do
    # Smoke checks: version flag exits 0 and prints the declared semver.
    output = shell_output("#{bin}/lovarch --version")
    assert_match "lovarch-cli", output
    assert_match version.to_s.split("-").first, output

    # `arch` alias resolves to the same entry point
    arch_output = shell_output("#{bin}/arch --version")
    assert_match "lovarch-cli", arch_output

    # `info` panel runs without network (free mode, not-configured state)
    info_output = shell_output("#{bin}/lovarch info")
    assert_match "architettura-progetto", info_output
  end
end
