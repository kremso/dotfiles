function get_git_status -d "Gets the current git status"
  if command git rev-parse --is-inside-work-tree >/dev/null 2>&1
    set -l dirty (command git status -s --ignore-submodules=dirty | wc -l | sed -e 's/^ *//' -e 's/ *$//' 2> /dev/null)
    set -l ref (command git symbolic-ref HEAD | sed  "s-refs/heads/--" | sed -e 's/^ *//' -e 's/ *$//' 2> /dev/null)

    if [ "$dirty" != "0" ]
      set_color -b normal
      set_color CC333F
      echo "$dirty changed file"
      if [ "$dirty" != "1" ]
        echo "s"
      end
      echo " "
      set_color -b CC333F
      set_color white
    else
      set_color -b 00A0B0
      set_color white
    end

    echo " $ref "
    set_color normal
   end
end

function fish_right_prompt -d "Prints right prompt"
  get_git_status
end
