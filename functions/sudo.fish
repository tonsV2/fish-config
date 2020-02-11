# Credits: https://github.com/fish-shell/fish-shell/issues/288#issuecomment-22762823

function sudo
    if test "$argv" = !!
        eval command sudo $history[1]
    else
        command sudo $argv
    end
end

