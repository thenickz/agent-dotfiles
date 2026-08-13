---
name: notify
description: Sets up, configures, and tests opencode notifications — Telegram bot and OS desktop notifications (WSL/Windows/Linux/macOS). Use when the user wants to be notified when opencode asks a question, asks for permission, or finishes a response; when setting up a Telegram bot (BotFather token, chat id); when configuring the opencode-notify plugin env vars; when the user asks to turn notifications off, enable or disable Telegram or OS notifications, or change a notification event (response finished / permission / question).
---

# notify — opencode notifications (OS + Telegram)

The **opencode-notify** plugin (installed by `install.sh`) sends a notification on
two kinds of events:

| Event | Aviso |
|---|---|
| `session.idle` (root session) | "response finished" |
| `permission.asked` | "asking permission" |
| `question` tool invoked (`tool.execute.before`) | "question" (sent when asked, before you answer) |

Two channels, each independently togglable:
- **OS desktop** — dispatched by `scripts/notify.sh`, auto-detects the platform
  (WSL → Windows toast, macOS → osascript, Linux → notify-send, Windows → BurntToast).
- **Telegram** — optional; only active when a bot token + chat id are configured.

## 1. Check current state

```bash
ls -l ~/.config/opencode/plugins/opencode-notify.js ~/.config/opencode/notify.sh 2>&1
env | grep -E '^OPENCODE_(NOTIFY|TELEGRAM)' || echo "no OPENCODE_NOTIFY/TELEGRAM env vars set"
```

If the plugin/script symlinks are missing, re-run `./install.sh`.

## 2. Set up Telegram (guided)

1. **Create a bot** with [@BotFather](https://t.me/botfather): send `/newbot`, pick a
   name and a username ending in `bot`. Copy the token (`123456789:AA...`).
2. **Start the chat**: open the bot and press Start (send `/start`). A bot cannot
   message you until you do this.
3. **Get your chat id**: open in a browser, replacing `<BOT_TOKEN>`:

   ```
   https://api.telegram.org/bot<BOT_TOKEN>/getUpdates
   ```

   Look for `"message": { "chat": { "id": <your-id> } }`. Group chats use a
   negative id. If empty, send another message to the bot and refresh.
4. **Smoke test** (from any shell):

   ```bash
   curl -sS -X POST "https://api.telegram.org/bot<BOT_TOKEN>/sendMessage" \
     -d "chat_id=<CHAT_ID>" --data-urlencode "text=opencode notify smoke test"
   ```

   No response message in the chat? Fix token/chat id before continuing.
5. **Persist the env vars** (add to `~/.bashrc`, then `source ~/.bashrc`):

   ```bash
   export OPENCODE_TELEGRAM_BOT_TOKEN="<BOT_TOKEN>"
   export OPENCODE_TELEGRAM_CHAT_ID="<CHAT_ID>"
   ```

   Never commit the token; never store it in `memory.md` or `AGENTS.md`.
6. **Restart opencode** so the plugin picks up the new environment.

## 3. Set up OS notifications on WSL (optional, recommended)

On WSL the Linux `notify-send` does not surface on Windows. The dispatcher prefers
PowerShell + **BurntToast** (it fails loudly when a toast cannot be created), then
`wsl-notify-send.exe`, then `notify-send`.

1. Install the BurntToast module (per-user, no admin):
   `powershell.exe -NoProfile -NonInteractive -Command "Install-Module -Name BurntToast -Scope CurrentUser -Force -AllowClobber"`
2. (Alternative) `wsl-notify-send.exe` from
   <https://github.com/stuartleeks/wsl-notify-send/releases>, placed somewhere in
   the Windows `PATH`. Caveat: it exits 0 even when Windows silently drops the
   toast (missing Start Menu shortcut for its app id) — BurntToast is more reliable.
3. Test:

   ```bash
   OPENCODE_NOTIFY_DEBUG=1 ~/.config/opencode/notify.sh "opencode" "OS toast test" done
   ```

   You should see a Windows toast. If no channel is available, the dispatcher
   prints the failure only with `OPENCODE_NOTIFY_DEBUG=1`.

## 4. Configuration

All options are env vars; every event toggle defaults to on. The variables live in
`~/.bashrc` (added during Telegram setup) — see the request→change map below.

| Var | Meaning |
|---|---|
| `OPENCODE_NOTIFY_DISABLED=1` | master switch (disables both channels) |
| `OPENCODE_NOTIFY_OS=auto` | `auto` \| `darwin` \| `linux` \| `wsl` \| `windows` \| `none` |
| `OPENCODE_NOTIFY_ON_DONE` / `_ON_PERMISSION` / `_ON_QUESTION=0` | disable an OS event |
| `OPENCODE_NOTIFY_DEBUG=1` | print dispatcher errors |
| `OPENCODE_TELEGRAM_BOT_TOKEN` | enables Telegram |
| `OPENCODE_TELEGRAM_CHAT_ID` | target chat |
| `OPENCODE_TELEGRAM_ON_DONE` / `_ON_PERMISSION` / `_ON_QUESTION=0` | disable a Telegram event |

### Changing config when the user asks

When the user asks to turn notifications on/off, enable or disable a channel, or
change an event, apply the request with this procedure:

1. Find the current values: `grep -n OPENCODE ~/.bashrc`
2. Edit the matching line(s) in `~/.bashrc` (or append new `export ...` lines).
3. Tell the user to **restart opencode** so the plugin picks up the new env.

Request → change map (defaults = all events on, both channels):

| User asks | Change |
|---|---|
| "turn off / desliga notifications" | add `export OPENCODE_NOTIFY_DISABLED=1` |
| "turn notifications back on" | remove/comment that line |
| "only Telegram / desliga o OS" | `export OPENCODE_NOTIFY_OS=none` |
| "turn OS back on" | set `OPENCODE_NOTIFY_OS=auto` (or delete the line) |
| "turn off Telegram / desliga o Telegram" | comment out `OPENCODE_TELEGRAM_BOT_TOKEN` and `OPENCODE_TELEGRAM_CHAT_ID` (channel becomes inactive) |
| "turn Telegram back on" | uncomment / restore the two `OPENCODE_TELEGRAM_*` lines |
| "stop notifying me when a response ends / done" | `OPENCODE_NOTIFY_ON_DONE=0` and/or `OPENCODE_TELEGRAM_ON_DONE=0` |
| "stop notifying on permission / pergunta" | same pattern with `_ON_PERMISSION=0` / `_ON_QUESTION=0` |
| "turn that event back on" | delete the `=0` (or set to `1`) |
| "send to another chat / user" | change `OPENCODE_TELEGRAM_CHAT_ID` |

Note: the plugin snapshots env at startup, so a running opencode ignores edits until
it restarts — always end with the restart reminder.

## 5. Testing all three notifications

Restart opencode, then send this prompt in a session with the plugin loaded:

```
Test notifications: first ask me a question with the question tool, then request
permission to run a harmless command like `pwd` (set permission to ask for bash
if needed), then finish your response.
```

Expected, in order: OS/Telegram "question", "asking permission", then "response
finished". If a channel is quiet, check step 1 (env vars) and
`OPENCODE_NOTIFY_DEBUG=1`.

Notes:
- "response finished" (`session.idle`) can fire twice for the same session in a
  few ms; the plugin dedupes duplicates within a 3s window.
- The "permission" event only fires when opencode actually asks for permission.
  If bash is auto-allowed (default in many setups), no permission.asked event is
  emitted — nothing to fix, it's expected silence.
- For tracing, run opencode with `OPENCODE_NOTIFY_DEBUG=1` (plugin writes
  `/tmp/opencode/notify-debug.log`); remove the var for normal use.

## 6. Troubleshooting

- **Nothing arrives**: `OPENCODE_NOTIFY_DISABLED` must not be `1`; plugin symlink
  must exist; restart opencode after changing env vars.
- **Telegram silent**: `/start` not sent, token/chat id swapped, or the plugin env
  did not reach the opencode process (export in the same shell that starts opencode).
- **OS silent on WSL**: install `wsl-notify-send.exe` (step 3) or check
  `OPENCODE_NOTIFY_DEBUG=1` output.
- **Disable for a while**: `export OPENCODE_NOTIFY_DISABLED=1` (session) or remove
  the env vars / delete the plugin symlink.
