# Homebrew tap: `mikefreno/tap`

Homebrew tap for my TUI clients.

## Install

```sh
brew tap mikefreno/tap
```

## Formulas

### podtui

Keyboard-first terminal podcast client.

```sh
brew install podtui
```

Requires `mpv` for playback (pulled in automatically).

### jellytui

Keyboard-first terminal Jellyfin music client.

```sh
brew install jellytui
```

Requires `mpv` for playback (pulled in automatically).

## Updating formulas after a release

After you push a new `vX.Y.Z` release tag on the main repo:

```sh
./scripts/sync-formula.sh podtui X.Y.Z
git add Formula/podtui.rb && git commit -m "podtui X.Y.Z" && git push
```

This re-downloads the platform tarballs, recomputes sha256s, and bumps the formula's version. Requires `gh` authenticated with read access to the release assets.

## Layout

- `Formula/podtui.rb` — PodTUI formula (arch-aware)
- `Formula/jellytui.rb` — JellyTUI formula (arch-aware)
- `scripts/sync-formula.sh` — helper to refresh version/sha256 on each tag