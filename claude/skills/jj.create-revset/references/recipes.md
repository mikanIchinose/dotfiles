# Common Recipes

## Basic Navigation

```shell
# Parent of working copy
jj log -r '@-'

# All ancestors
jj log -r '::@'

# Commits since trunk (current branch work)
jj log -r 'trunk()..@'
```

## Filtering

```shell
# By author + description
jj log -r 'author("name") & description("fix")'

# My commits only
jj log -r 'mine()'

# Commits touching a file
jj log -r 'files("src/main.rs")'

# Recent commits
jj log -r 'author_date(after:"1 week ago")'

# Latest N commits
jj log -r 'latest(all(), 5)'
```

## Branch/Stack Work

```shell
# Mutable stack reachable from @
jj log -r 'reachable(@, mutable())'

# Local-only commits (not on any remote)
jj log -r 'remote_bookmarks()..@'

# All mutable commits
jj log -r 'mutable()'
```

## Composing Expressions

```shell
# My recent fixes on this branch
jj log -r 'mine() & description("fix") & trunk()..@'

# Non-empty commits since trunk
jj log -r 'trunk()..@ ~ empty()'

# Commits with conflicts in my stack
jj log -r 'conflicts() & trunk()..@'
```

## Custom Aliases (config)

```toml
[revset-aliases]
'user(x)' = 'author(x) | committer(x)'
'stack()' = 'reachable(@, mutable())'
'wip()' = 'description(regex:"^(wip|WIP|fixup!)")'
```
