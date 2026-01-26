# GitHub PR Guidelines

Guidelines for creating human-readable, concise Pull Request descriptions.

## Core Principles

1. **Write like a human** - Avoid robotic AI language, be natural and conversational
2. **Be concise** - Get to the point quickly, don't over-explain
3. **No fluff** - Skip unnecessary preamble, conclusions, and filler words

## Style Guidelines

- be concise and to the point
- avoid filler, empty words
- don't over explain
- avoid repeating yourself (or the meaning already conveyed)
- don't try to be too perfect
- use general guidelines
- insert personality into the message (when appropriate), with words like: personally, I myself, I've had to deal with, etc. Describing related personal story, tell from first person (all when appropriate), and etc
- avoid using em dashes
- don't use emojis
- don't use parallel sentences ("it's not just about X, it's about Y")
- use harder/aggressive/sad words (not 'safe') sometimes. Avoid sounding corporate, be more sincere

## Structure

### Title

- Clear, descriptive, action-oriented
- Start with verb: "Add", "Fix", "Improve", "Refactor"
- Max 60 characters

### Body

**Opening sentence**

- One sentence summary of what the PR does
- Include user benefit or problem solved

**Organized sections**

Use this structure to organize your PR body:

```markdown
## What changed

**[Category]**

- Specific change with context
- Another specific change

**[Another category]**

- Specific change

## Files

- `/path/to/file` - Brief description of changes
- `/path/to/another/file` - What was modified

## Impact

Brief explanation of the user-facing or technical impact of these changes.
```

**Guidelines:**

- Group changes by their purpose or impact, not by file structure or technical layer
- Add supporting sections only if they add value
- Files section is optional but helpful for larger PRs (use paths relative to project root)
- Impact section explains the "why" - what this enables or improves
- If PR doesnt doesnt entroduce a lot of changes - PR body should be extra concise

## Creating PR

Use `gh pr create` with HEREDOC for multi-line descriptions to avoid quote escaping issues.
