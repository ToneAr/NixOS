function fish_theme_watch_status -d "Check if theme watcher is running"
	if set -q __fish_theme_watch_pid
		if kill -0 $__fish_theme_watch_pid 2>/dev/null
			echo "Theme watcher is running (PID: $__fish_theme_watch_pid)"
			echo "  • Monitoring shell PID: $__fish_theme_watch_shell_pid"
			echo "  • Current accent: "(set_color $__fish_theme_last_accent)"████"(set_color normal)" $__fish_theme_last_accent"
			return 0
		else
			echo "Theme watcher process died (PID: $__fish_theme_watch_pid)"
			set -e __fish_theme_watch_pid
			return 1
		end
	else
		echo "Theme watcher is not running"
		return 1
	end
end
