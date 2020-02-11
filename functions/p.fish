function p -d "Grep for running processes"
	set pids (pgrep $argv)

	if test -n "$pids"
		#ps -fp (string join ' ' $pids) | highlight $argv
		set -l MATCH (printf '%s%s%s' (set_color -o red) $argv (set_color normal))
		ps -fp (string join ' ' $pids) | sed -e "s/$argv/$MATCH/g"
	else
		return 1
	end
end

