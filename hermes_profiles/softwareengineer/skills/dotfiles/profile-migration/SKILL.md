---
name: profile-migration
description: Migrate a hermes agent's profile into dotfiles repo; manage skills/config only, DB/cache excluded. Triggers when user wants portable hermes config via symlink in dotfiles.
---

# Migrate a hermes profile into dotfiles repo

When to trigger: user wants to make a hermes agent profile portable by managing it via a dotfiles repository, with symlink from `~/.hermes/profiles/<name>/` → `dotfiles/hermes_profiles/<profile_name>/`.

## Steps

1. **Ensure target dir exists in dotfiles repo, .gitignore is correct.**
   The `.gitignore` must exclude runtime data:
   ```
   # Runtime State & Databases
   state.db*
   *.db
   *.sqlite3
   auth.json
   auth.lock
   cache/
   image_cache/
   provider_models_cache.json
   context_length_cache.yaml
   ollama_cloud_models_cache.json
   models_dev_cache.json
   bin/
   lsp/
   node_modules/
   sandboxes/
   pastes/
   pairing/
   
   # Sessions & Logs
   sessions/
   logs/
   *agent.log
   *update.log
   *error.log
   state-snapshots/
   
   # Memory
   memories/
   *.memory
   *.lock
   
   # System
   .DS_Store
   ```

2. **rsync source → dotfiles target (full mirror, preserve timestamps/permissions).**
   ```bash
   rsync -av --checksum SOURCE_DIR/ TARGET_DIR/
   # e.g.:
   rsync -av --checksum ~/.hermes/profiles/softwareengineer/ ~/dotfiles/hermes_profiles/softwareengineer/
   ```

3. **Backup source, then replace with symlink.**
   ```bash
   mv ~/.hermes/profiles/<name> ~/.hermes/profiles/<name>.bak
   ln -sfn ~/dotfiles/hermes_profiles/<name> ~/.hermes/profiles/<name>
   ls -ld ~/.hermes/profiles/<name>  # verify symlink points to dotfiles path
   ```

4. **Update .gitignore in dotfiles if needed** (especially `*.db` patterns). Use `--cached remove` for DB files already tracked:
   ```bash
   cd ~/dotfiles
   git rm --cached path/to/file.db  # unstage if already committed
   # then add to .gitignore
   ```

5. **Commit only skills/config files.** Skills, config.yaml, SOUL.md, etc. — NOT DB/cache/bin sessions.
   ```bash
   cd ~/dotfiles
   git add hermes_profiles/<name>/skills/ hermes_profiles/<name>/.gitignore hermes_profiles/<name>/config.yaml hermes_profiles/<name>/SOUL.md
   git commit -m "chore: manage <name> profile via dotfiles (skills/config only, DB excluded)"
   ```

6. **Verify link works.** `ls` on the symlink target; optionally start a new session.

7. **Clean up backup** after confirming everything is good:
   ```bash
   rm -rf ~/.hermes/profiles/<name>.bak
   ```

## Pitfalls

- **Don't rm before verifying symlink.** Always mv (backup) first, test, then rm.
- **DB files already tracked by git must be unstaged** with `git rm --cached` — simply adding to `.gitignore` does not unstage already-tracked files.
- **The link.sh script should already contain the symlink line.** Check before creating a duplicate. Typical pattern:
  ```bash
  mkdir -p ${HOME}/.hermes/profiles/
  ln -sfv ${DOTPATH}/hermes_profiles/<NAME> ${HOME}/.hermes/profiles/<NAME>
  ```
