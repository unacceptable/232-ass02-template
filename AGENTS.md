# AGENTS.md - 232-ass02-template

This is Robert's fork of `jpach-cs/232-ass02-template`, the CSCI 232 Assignment 02 ("C Language
Fundamentals") debugging lab: fourteen challenges in `src/code.c`, each solved by observing program
state in a debugger and replacing `return 0;` with the observed value. The umbrella rules in
`~/Git/Montana Tech/AGENTS.md` and `~/Git/Montana Tech/csci-232/AGENTS.md` apply here too; this
file records only what is specific to this repo.

## Where it lives

- Local path: `~/Git/Montana Tech/csci-232/Week 2/Labs/232-ass02-template/`. It is its own git
  repo and is gitignored by `csci-232`.
- `origin` is `unacceptable/232-ass02-template`; `upstream` is `jpach-cs/232-ass02-template`.
  Dr. Pach pushes fixes upstream (challenge 04 was one); fetch `upstream/main` before starting
  work and merge it into the working branch.
- GitHub SSH has been flaky from this machine. Fetch and push over HTTPS when it hangs:
  `git fetch https://github.com/unacceptable/232-ass02-template.git main:refs/remotes/origin/main`.

## Toolchain on the Mac

Dr. Pach's required compiler is GCC 9.2.0 (his MinGW bundle, Windows only). On the Mac the same
version runs in Docker through shims in `~/.bin` (`gcc`, `g++`, `make`, `gdb`, `mingw32-make`,
`docker-gcc`), all symlinks to `csci-232/tools/docker-gcc`. They only intercept commands run from
inside `~/Git/Montana Tech`. Put `~/.bin` first on `PATH` and `make` builds `bin/main`, a Linux
aarch64 ELF that only runs inside the container (`docker-gcc ./bin/main`, or under `gdb`).

The image cannot link 32-bit x86 objects, so `lib/unity.o` and Dr. Pach's `tests02.o` cannot be
run locally. **The GitHub Actions run is the only test.** It downloads the current test object,
compiles `src/code.c` in 32-bit mode on Ubuntu, and runs it on every push to `main` and every PR.

## Debugging

- VS Code: `.vscode/launch.json` has two macOS configurations ahead of Dr. Pach's Windows ones.
  "C: Docker GCC 9.2.0 gdb (macOS)" builds with the shim and attaches gdb through it (VS Code's
  MI protocol works over the shim's stdin/stdout). "C: native clang + lldb (macOS)" is the
  fallback: same source, Apple toolchain, `bin/main-native`. Do not remove the Windows entries.
- Command line: one gdb script per challenge in `csci-232/Week 2/Labs/gdb-scripts/NN.gdb`. Each
  stops where the challenge text says and prints what it asks to be inspected. Run from this
  directory: `gdb -q -batch -x ../gdb-scripts/NN.gdb ./bin/main`. Breakpoints in the scripts are
  by line number, so re-check them after editing `code.c`.
- `src/main.c` calls all fourteen challenges in order (the template shipped with only
  `challenge01()` live), so a breakpoint in any challenge is reached with Continue.

## The work is Robert's

The lab's stated rule is "do not guess the answer." Robert observes the values in the debugger
and decides the return values; agents set up tooling, write gdb scripts, and edit the file at
his direction. The disclosure comment at the top of `src/code.c` says exactly that; keep it
accurate if the division of work changes.

## Submission rules

- `src/code.c` must begin with the four-line syllabus declaration (name, "CSCI 232 Fall 2026",
  "Programming Assignment #2", authorship statement) and must define `AUTHOR_NAME` and
  `AUTHOR_AUTHORSHIP`. A file without the declaration scores 0.
- Work on a branch and open a PR against `main`; Robert merges. Pushing to `main` is what Dr.
  Pach grades, so nothing lands there unreviewed.
- Tracked in Jira as MTECH-178. Never put the ticket key in a source file.
