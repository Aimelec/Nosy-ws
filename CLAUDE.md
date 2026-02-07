# Claude Code Guidelines

## Commit Rules

- Never add Co-Authored-By lines
- Start every commit message with a keyword prefix:
  - `Feat:` — new feature or functionality
  - `Fix:` — bug fix
  - `Refactor:` — code restructuring without behavior change
  - `Test:` — adding or updating tests
  - `Chore:` — maintenance tasks (dependencies, config, CI, etc.)
  - `Docs:` — documentation changes
  - `Style:` — code formatting, linting fixes
- Keep commit titles clear, concise, and readable
- Examples:
  - `Feat: Add IGDB API client for game catalog`
  - `Fix: Remove exposed master key from tracking`
  - `Test: Add RSpec tests for IGDB client`
  - `Chore: Add RSpec, VCR, and WebMock dependencies`
  - `Refactor: Extract Authenticator from IGDB Client`

## Pull Request Rules

- Only create a PR when explicitly asked by the user
- Use `gh pr create` to create PRs
- Always follow this format:

```
## Summary
Brief description of what this PR does (2-3 bullet points).

## Motivation
Why this change was made — the problem it solves or the goal it achieves.

## Changes
List of notable changes grouped by area (files, modules, etc.).

## How to Test
Steps to verify the changes work correctly (console commands, test commands, etc.).
```

## Project Setup

- Everything runs inside Docker — never install Ruby or gems on the host
- Run Rails commands via: `docker compose run --rm ws bin/rails <command>`
- Run tests via: `docker compose run --rm ws bundle exec rspec`
