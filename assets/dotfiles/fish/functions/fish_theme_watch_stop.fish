function fish_theme_watch_stop -d "Stop watching for theme changes"
	set -l verbose 0
	for arg in $argv
		if test $arg = "--verbose"
			set verbose 1
		end
	end

	if set -q __fish_theme_watch_pid
		# Kill the background job
		kill $__fish_theme_watch_pid 2>/dev/null
		disown $__fish_theme_watch_pid 2>/dev/null
		if test $status -eq 0
			if test $verbose -eq 1
				echo "Theme watcher stopped (PID: $__fish_theme_watch_pid)"
			end
		else
			if test $verbose -eq 1
				echo "Theme watcher process not found (PID: $__fish_theme_watch_pid)"
			end
		end
		set -e __fish_theme_watch_pid
	else
		if test $verbose -eq 1
			echo "Theme watcher is not running"
		end
	end

	# Remove signal file
	if set -q __fish_theme_watch_signal
		rm -f $__fish_theme_watch_signal 2>/dev/null
		set -e __fish_theme_watch_signal
	end

	# Remove the signal handler
	functions -e __fish_theme_watch_apply

	set -e __fish_theme_last_accent
	set -e __fish_theme_watch_shell_pid
end
