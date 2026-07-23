if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
  # Get a list of tmux session names
  SESSIONS=$(tmux ls 2>/dev/null | awk -F: '{print $1}')

  if [ -n "$SESSIONS" ]; then
    # Loop through the sessions to check if any are unattached
    for SESSION in $SESSIONS; do
      # Check if session is attached or not using tmux's session status
      ATTACHED=$(tmux list-sessions -F '#{session_name} #{session_attached}' | grep "$SESSION" | awk '{print $2}')

      if [ "$ATTACHED" -eq 0 ]; then
        # If session is not attached, attach to it (without detaching)
        tmux attach-session -t "$SESSION" || tmux new-session -s "$SESSION"
        exit 0
      fi
    done

    # If all sessions are attached, create a new session with a unique name
    NEW_SESSION_NAME="new-session-$(($(tmux ls | grep -o 'new-session-[0-9]*' | sed 's/[^0-9]*//g' | sort -n | tail -n 1)+1))"
    tmux new-session -s "$NEW_SESSION_NAME"
  else
    # If no sessions exist, create a new one
    tmux new-session -s "new-session-1"
  fi
fi
