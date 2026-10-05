function proj_setup
	set script_dir (dirname (status --current-filename))/..
	set proj_function_location $script_dir/functions/proj.fish

	function __fetch_proj -a dir
		set script_dir $dir
		set proj_clone_url git@github.com:ToneAr/proj-cli.git
		set local_repo_dir $script_dir/repos/proj-cli/

		begin
			mkdir -p "$script_dir/repos"
			# Try clone first
			begin
				git clone $proj_clone_url $local_repo_dir --single-branch
			end &> /dev/null
			set -l clone_exit_code $status
			if test -d "$local_repo_dir"
				if test $clone_exit_code -ne 0
					# repository exists already; try to pull
					git -C $local_repo_dir pull &> /dev/null
					set -l clone_exit_code $status
				end
				if test $clone_exit_code -eq 0 -o $clone_exit_code -eq 128
					cp -f \
						$local_repo_dir/proj.fish \
						$script_dir/functions/proj.fish
					cp -f \
						$local_repo_dir/completions/proj.fish \
						$script_dir/completions/proj.fish
				else
					if not test -f "$script_dir/functions/proj.fish"
						printf "%s\n" "Failed to fetch proj.fish" >&2
					end
				end
			else
				if not test -f "$script_dir/functions/proj.fish"
					printf "%s\n" "Failed to fetch proj.fish" >&2
				end
			end
		end
	end

	# If function already exists, source it in background
	if test -f "$proj_function_location"
		source "$proj_function_location"
	else
		__fetch_proj $script_dir
		source "$proj_function_location"
	end
	# Run everything asynchronously
	fish -c "$(functions __fetch_proj); __fetch_proj $script_dir" &
end
