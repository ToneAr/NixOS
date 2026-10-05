# @fish-lsp-disable 4004

# Watch for system accent color changes and auto-refresh theme + Oh My Posh
function fish_theme_watch -d "Watch for system accent color changes"
	# Check if already running
	if set -q __fish_theme_watch_pid
		echo "Theme watcher is already running (PID: $__fish_theme_watch_pid)"
		return 1
	end

	# Store current accent color and parent shell PID
	set -g __fish_theme_last_accent (get_system_accent_color)
	set -g __fish_theme_watch_shell_pid %self

	# Create a temp file to store the new color
	set -g __fish_theme_watch_signal /tmp/fish_theme_watch_(random)
	echo $__fish_theme_last_accent > $__fish_theme_watch_signal

	# Create background job that checks periodically and signals the shell
	fish -c '
		set -l check_interval 3  # Check every 3 seconds
		set -l last_accent (get_system_accent_color)
		set -l signal_file '$__fish_theme_watch_signal'
		set -l shell_pid '$__fish_theme_watch_shell_pid'

		while test -f "$signal_file"
			sleep $check_interval

			set -l current_accent (get_system_accent_color)

			if test "$current_accent" != "$last_accent"
				# Update stored value
				set last_accent $current_accent

				# Write the new color to the signal file
				echo $current_accent > "$signal_file"

				# Send SIGUSR1 to the parent shell to trigger update
				kill -USR1 $shell_pid 2>/dev/null
			end
		end
	' &

	# Store the background job PID
	set -g __fish_theme_watch_pid (jobs -lp | tail -1)
	disown $__fish_theme_watch_pid

	if contains -- --verbose $argv
		echo "Theme watcher enabled"
		echo "  • Monitoring system accent color changes every 3 seconds"
		echo "  • Will update Fish colors automatically"
		echo "  • Will update Oh My Posh environment variables"
		echo "  • Current accent: "(set_color $__fish_theme_last_accent)"████"(set_color normal)" $__fish_theme_last_accent"
		echo "  • Background job PID: $__fish_theme_watch_pid"
		echo "  • Shell PID: $__fish_theme_watch_shell_pid"
	end
end

# Set up signal handler for SIGUSR1 to apply theme changes
function __fish_theme_watch_apply --on-signal SIGUSR1
	if set -q __fish_theme_watch_signal
		if test -f $__fish_theme_watch_signal
			set -l new_accent (cat $__fish_theme_watch_signal 2>/dev/null)
			if test -n "$new_accent"; and test "$new_accent" != "$__fish_theme_last_accent"
				set -g __fish_theme_last_accent $new_accent

				# Sync all themes in the current shell FIRST (silently)
				system_theme_sync

				# OMP caches colors on initialization so reinitialize
				# Oh My Posh to pick up new environment variables
				if test -f ~/.config/omp.json
					eval (oh-my-posh init fish --config ~/.config/omp.json)
				end

				# Now print notification with the NEW colors already applied
				echo ""
				set_color green
				echo "System accent changed to $new_accent"
				echo "✓ Themes synchronized!"
				set_color normal
				echo ""

				# Force prompt refresh
				commandline -f repaint
			end
		end
	end
end
