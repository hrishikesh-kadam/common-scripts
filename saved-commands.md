# Saved Commands

## Search

### Search only in git tracked files

```bash
git ls-files --full-name --recurse-submodules \
  | xargs -I {} grep --color=auto --with-filename "to be sourced" {}
```
