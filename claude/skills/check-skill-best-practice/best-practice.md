# Skill authoring best practices

Good Skills are concise, well-structured, and tested with real usage.

## Core principles

### Concise is key

Only add context Claude doesn't already have. Challenge each piece of information:
- "Does Claude really need this explanation?"
- "Can I assume Claude knows this?"
- "Does this paragraph justify its token cost?"

### Set appropriate degrees of freedom

Match the level of specificity to the task's fragility and variability.

- **High freedom**: Multiple approaches are valid, decisions depend on context
- **Medium freedom**: A preferred pattern exists, some variation is acceptable
- **Low freedom**: Operations are fragile, consistency is critical

### Test with all models you plan to use

- **Claude Haiku**: Does the Skill provide enough guidance?
- **Claude Sonnet**: Is the Skill clear and efficient?
- **Claude Opus**: Does the Skill avoid over-explaining?

## Skill structure

### YAML Frontmatter

- `name`: Max 64 chars, lowercase letters/numbers/hyphens only, no reserved words ("anthropic", "claude")
- `description`: Max 1024 chars, non-empty, no XML tags. Should describe what the Skill does and when to use it.

### Naming conventions

Use **gerund form** (verb + -ing) for Skill names: `processing-pdfs`, `analyzing-spreadsheets`

### Writing effective descriptions

- Always write in third person
- Be specific and include key terms
- Include both what the Skill does and when to use it

### Progressive disclosure

- Keep SKILL.md body under 500 lines
- Split content into separate files when approaching this limit
- Keep references one level deep from SKILL.md
- Structure longer reference files with table of contents

## Workflows and feedback loops

- Break complex operations into clear, sequential steps
- Provide checklists for multi-step workflows
- Implement feedback loops: Run validator -> fix errors -> repeat

## Content guidelines

- Avoid time-sensitive information
- Use consistent terminology throughout
- Provide templates for output format
- Include input/output examples for quality-dependent tasks

## Anti-patterns to avoid

- Windows-style paths (use forward slashes)
- Offering too many options (provide a default with escape hatch)
- Deeply nested references
- Assuming tools are installed
- Vague descriptions

## Checklist for effective Skills

### Core quality
- [ ] Description is specific and includes key terms
- [ ] SKILL.md body is under 500 lines
- [ ] Additional details in separate files (if needed)
- [ ] Consistent terminology throughout
- [ ] Examples are concrete, not abstract
- [ ] Workflows have clear steps

### Code and scripts
- [ ] Scripts solve problems rather than punt to Claude
- [ ] Error handling is explicit and helpful
- [ ] Required packages listed in instructions

### Testing
- [ ] At least three evaluations created
- [ ] Tested with real usage scenarios
