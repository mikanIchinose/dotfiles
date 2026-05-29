# Functions

## Traversal

| Function | Description |
|----------|-------------|
| `parents(x, [depth])` | Parents at given depth |
| `children(x, [depth])` | Children at given depth |
| `ancestors(x, [depth])` | Same as `::x`, optionally depth-limited |
| `descendants(x, [depth])` | Same as `x::`, optionally depth-limited |
| `connected(x)` | Same as `x::x` |
| `reachable(srcs, domain)` | All commits reachable from srcs within domain |
| `fork_point(x)` | Common ancestor(s) of all commits in x |

## References

| Function | Description |
|----------|-------------|
| `bookmarks([pattern])` | Local bookmark targets |
| `remote_bookmarks([name], [remote=pattern])` | Remote bookmark targets |
| `tracked_remote_bookmarks([name], [remote=pattern])` | Tracked remote bookmarks |
| `tags([pattern])` | Tag targets |
| `trunk()` | Head of main/master/trunk on default remote |
| `visible_heads()` | All visible heads |
| `root()` | Virtual oldest ancestor |

## Filtering

| Function | Description |
|----------|-------------|
| `description(pattern)` | Match commit description |
| `subject(pattern)` | Match first line of description |
| `author(pattern)` | Match author name or email |
| `author_date(pattern)` | Match author date |
| `committer(pattern)` | Match committer name or email |
| `committer_date(pattern)` | Match committer date |
| `mine()` | Author email matches current user |
| `files(expression)` | Commits modifying matching paths |
| `diff_lines(text, [files])` | Commits with diffs matching text |
| `empty()` | Commits modifying no files |
| `conflicts()` | Commits with unresolved conflicts |
| `merges()` | Merge commits |

## Set Operations

| Function | Description |
|----------|-------------|
| `all()` | All visible commits |
| `none()` | Empty set |
| `heads(x)` | Commits in x with no descendants in x |
| `roots(x)` | Commits in x with no ancestors in x |
| `latest(x, [count])` | Latest N commits by committer timestamp |
| `present(x)` | Same as x, but `none()` if commits don't exist |
| `coalesce(revsets...)` | First non-empty revset |

## Built-in Aliases

| Alias | Definition |
|-------|------------|
| `trunk()` | Head of default bookmark on default remote |
| `immutable()` | `::immutable_heads()` |
| `mutable()` | `~immutable()` |
