function omp_setup
	set script_dir (dirname (status --current-filename))/..
	set omp_theme_clone_url git@github.com:ToneAr/ADAPTIVE-oh-my-posh-theme.git
	set omp_config_file adaptive-omp.json
	set omp_config_dir $HOME/.poshthemes/
	set omp_local_dir $script_dir/repos/omp-theme

	function __fetch_omp
		# Try clone first; if repo exists, pull instead
		git clone --depth 1 \
			$omp_theme_clone_url \
			$omp_local_dir \
			&> /dev/null
		set -l clone_exit_code $status
		if test -d \"$omp_local_dir\"
			if test $clone_exit_code -ne 0
				git -C $omp_local_dir pull &> /dev/null
				set -l clone_exit_code $status
			end
			if test $clone_exit_code -eq 0 -o $clone_exit_code -eq 128
				mkdir -p $omp_config_dir
				cp -f \
					$omp_local_dir/$omp_config_file \
					$omp_config_dir/$omp_config_file
			end
		end
	end

	# If theme already installed, source it immediately
	if test ! -f "$omp_config_dir/$omp_config_file"
		__fetch_omp
	end

	# Fetch/update theme asynchronously
	fish -c "$(functions __fetch_omp); __fetch_omp" &

	oh-my-posh init fish \
		--config $omp_config_dir/$omp_config_file \
		| source
end
