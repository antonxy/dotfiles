set fish_prompt_pwd_dir_length 0
set fish_greeting ""
#fish_vi_key_bindings

function dup
	urxvt 2> /dev/null 1> /dev/null &
	disown %last
end
