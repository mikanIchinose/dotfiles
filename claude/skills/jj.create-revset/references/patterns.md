# String & Date Patterns

## String Patterns

Used in `description()`, `author()`, `bookmarks()`, etc.

| Pattern | Meaning |
|---------|---------|
| `exact:"string"` | Exact match |
| `substring:"string"` | Contains substring |
| `glob:"pattern"` | Unix shell wildcard |
| `regex:"pattern"` | Regular expression |

- Default is `substring` for most functions, `glob` for `bookmarks()`/`tags()`
- Append `-i` for case-insensitive: `glob-i:"Fix*"`, `regex-i:"error"`

### Pattern combinators

Patterns support logical operators (same as revset operators):

```
~exact:"WIP"                    # NOT
glob:"feat*" & ~glob:"feat/old*" # AND
glob:"fix*" | glob:"bugfix*"    # OR
```

## Date Patterns

Used in `author_date()`, `committer_date()`.

| Pattern | Example |
|---------|---------|
| `after:"date"` | `after:"2024-02-01"` |
| `before:"date"` | `before:"2024-02-01T12:00:00"` |

Relative dates supported: `after:"2 days ago"`, `before:"yesterday 5pm"`, `after:"1 week ago"`

Combinators work here too:

```
author_date(after:"2024-01-01" & before:"2024-03-01")
```
