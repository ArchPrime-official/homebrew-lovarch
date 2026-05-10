# homebrew-lovarch

Official [Homebrew](https://brew.sh) tap for Lovarch tools on macOS and Linux.

## Available formulas

| Formula | Description |
|---|---|
| `lovarch-cli` | AI-powered architectural project execution CLI ([source](https://github.com/ArchPrime-official/lovarch-cli)) |

## Install

```bash
brew tap ArchPrime-official/lovarch
brew install lovarch-cli
```

Then:

```bash
lovarch --version
lovarch info
lovarch signup            # FREE mode
lovarch login --premium   # Premium mode (Lovarch credits)
```

Backward-compat alias `arch` works as `lovarch`.

## Update

```bash
brew update
brew upgrade lovarch-cli
```

## Uninstall

```bash
brew uninstall lovarch-cli
brew untap ArchPrime-official/lovarch
```

State at `~/.lovarch/` is preserved across uninstalls. To purge:

```bash
rm -rf ~/.lovarch/
```

## Development

The formula installs `lovarch-cli` into an isolated Python virtualenv under
`#{libexec}/venv/` and symlinks `lovarch` + `arch` into Homebrew's `bin/`.
Python 3.12 is the runtime (declared via `depends_on "python@3.12"`).

### Bumping the formula

When the upstream CLI ships a new release, the formula must be bumped:

```bash
# Get the new release tarball SHA256
curl -sL https://github.com/ArchPrime-official/lovarch-cli/archive/refs/tags/v0.2.0.tar.gz \
  | shasum -a 256
```

Then edit `Formula/lovarch-cli.rb`:

- `url`: new tag
- `sha256`: new digest
- Commit + push to main

The CI workflow runs `brew test-bot` on every PR to verify the formula installs
+ tests pass on macOS-latest.

A future enhancement is a `repository_dispatch` trigger from the upstream
`lovarch-cli` repo that auto-opens a bump PR here whenever a new tag lands.

## Links

- 🌐 Lovarch: https://lovarch.com
- 📦 lovarch-cli: https://github.com/ArchPrime-official/lovarch-cli
- 🎓 Course (IA Avanzato per Architetti): https://lovarch.com/corso
- 🐛 Issues: https://github.com/ArchPrime-official/lovarch-cli/issues

## License

The tap (this repository) is MIT-licensed. Each formula points to upstream
software with its own license — see the upstream repo for details.
