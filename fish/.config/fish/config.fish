set fish_prompt_pwd_dir_length 0
set fish_greeting ""
#fish_vi_key_bindings

function dup
	urxvt 2> /dev/null 1> /dev/null &
	disown $last_pid
end

export GOPATH=/home/anton/go
set -U fish_user_paths /home/anton/go/bin $fish_user_paths
export EDITOR=vim

function qr
	read in
	qrencode -o - "$in" | display
end
