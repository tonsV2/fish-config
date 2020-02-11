if status --is-interactive
	# Adjust PATH
	set PATH $HOME/.bin $HOME/.local/bin /snap/bin $PATH

	# No welcome message
	set fish_greeting

	# Colored man-pages
	set -xU LESS_TERMCAP_mb (set_color -o blue)
	set -xU LESS_TERMCAP_md (set_color -o white)
	set -xU LESS_TERMCAP_me (set_color normal)
	set -xU LESS_TERMCAP_se (set_color normal)
	set -xU LESS_TERMCAP_so (set_color -o green)
	set -xU LESS_TERMCAP_ue (set_color normal)
	set -xU LESS_TERMCAP_us (set_color -u cyan)
	set -xU LESSCLOSE '/usr/bin/lesspipe %s %s'
	set -xU LESSOPEN '| /usr/bin/lesspipe %s'

	function parse_git_branch
		set -l branch (git branch 2> /dev/null | grep -e '\* ' | sed 's/^..\(.*\)/\1/')
		set -l git_diff (git diff)

		if test -n "$git_diff"
			echo (set_color red)$branch(set_color normal)
		else
			echo (set_color green)$branch(set_color normal)
		end
	end

	function git_prompt
		if test -d .git
			printf ' (%s)' (parse_git_branch)
		else
			printf '%s' ()
		end
	end

	function fish_prompt -d "Write out the prompt"
		begin
		set -l returnVal $status
		set -l returnCol (set_color red)
		if test $returnVal = 0; set returnCol (set_color green); end

		set -l folderCol (set_color -o yellow)
		if test -w "$PWD"; set folderCol (set_color -o white); end

		set -l OUT (printf '%s<%s%s<%s< ' (set_color -o red) (set_color normal) (set_color red) (set_color normal))
		set -l IN (printf '%s>%s>%s>%s ' (set_color normal) (set_color green) (set_color -o green) (set_color normal))
		set -l SEP (printf ' %s|%s ' (set_color -o blue) (set_color normal))

		set -l firstLine (printf '%s%s%s%s%s%s%s' (echo $OUT) (set_color -o white) (date "+%H:%M:%S %a %b %m") (echo -n $SEP) (echo -n $folderCol) (prompt_pwd) (set_color normal) (git_prompt))
		set -l secondLine (printf '%s%s%s@%s%s%s' (echo $OUT) (set_color -o white) (whoami) (hostname -s) (echo -n $SEP) (echo -n $returnCol$returnVal)) 
		printf '%s\n%s\n%s' (echo $firstLine) (echo $secondLine) (echo $IN)
		end
	end
	
	# do an ls after every successful cd
	function hello_dir --on-variable PWD
		ll
	end	

	function d -d "Grep for installed packages"
		dpkg-query -W | grep "$argv"
	end
	
	function ls 
		/bin/ls -F --color=auto --tabsize=0 --literal --group-directories-first $argv
	end

	function ll --description 'List contents of directory using long format'
		ls -lh $argv
	end

	alias ctop="docker run --rm -ti -v /var/run/docker.sock:/var/run/docker.sock quay.io/vektorlab/ctop:latest"
	alias bettercap='docker run -it --privileged --net=host -v $PWD/bettercap:/root bettercap/bettercap'
end

