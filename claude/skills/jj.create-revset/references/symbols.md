# Symbols & Operators

## Symbols

| Symbol | Meaning |
|--------|---------|
| `@` | Working copy commit (current workspace) |
| `<workspace>@` | Working copy commit (other workspace) |
| `<name>@<remote>` | Remote-tracking bookmark/tag |

Commit/Change ID は完全一致またはユニークなプレフィックスで指定可能。

名前解決の優先順位: Tag > Bookmark > Git ref > Commit/Change ID

## Operators (binding strength: strong → weak)

| Operator | Meaning | Example |
|----------|---------|---------|
| `x-` | Parents | `@-` = parent of working copy |
| `x+` | Children | `trunk()+` = children of trunk |
| `::x` | Ancestors (inclusive) | `::@` = all ancestors |
| `x::` | Descendants (inclusive) | `trunk()::` = all descendants of trunk |
| `x::y` | Ancestry path (x→y) | `trunk()::@` |
| `x..y` | Ancestors of y, excluding ancestors of x | `trunk()..@` = commits since trunk |
| `..x` | Ancestors of x, excluding root | |
| `x..` | Non-ancestors of x | |
| `~x` | Complement | `~immutable()` |
| `x & y` | Intersection | |
| `x ~ y` | Difference | |
| `x \| y` | Union | |

### Parent shorthand

`-` は連鎖可能: `@---` = `parents(@, 3)` = 3世代前

### `..` vs `::` の違い

- `A..B`: B の祖先のうち A の祖先でないもの（Git の `A..B` と同じ）
- `A::B`: A の子孫かつ B の祖先（ancestry path、A と B 自身を含む）
