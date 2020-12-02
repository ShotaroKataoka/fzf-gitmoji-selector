# Git emoji selector
function _fzf_gitmoji_widget() {
  local lbuf=$LBUFFER
  local tail=${LBUFFER:$(( ${#LBUFFER} - ${#trigger} ))}
  local selected_moji=''
  selected_moji=$(echo $(cat ~/.fzf-gitmoji-selector/git_emoji_list.txt) | sed '/^$/d' | fzf +m --ansi --cycle --bind='alt-h:abort,alt-j:down,alt-k:up,alt-l:accept,alt-c:abort,left:abort,right:accept')
  selected_moji=$(echo $selected_moji | cut -f 3 -d ' ')
  LBUFFER="$lbuf""$selected_moji""$tail"
  zle reset-prompt
}

# Git status
function _fzf_gitstatus_widget() {
  local _git_dir=$(git rev-parse --git-dir 2> /dev/null)
  if [ -n "$_git_dir" ]; then
    git status
    echo 
    echo 
  else
    echo "Not a git repository."
    echo 
    echo 
  fi
  zle reset-prompt
}

# Git log selector
function _fzf_gitlog_widget() {
  local _git_dir=$(git rev-parse --git-dir 2> /dev/null)
  if [ -n "$_git_dir" ]; then
    if [ -f "$_git_dir/.git_moji_list.txt" ]; then
      local _gitmoji=$(echo $(cat $_git_dir/.git_emoji_list.txt) | sed '/^$/d')
    else
      local _gitmoji=$(echo $(cat ~/.fzf-gitmoji-selector/git_emoji_list.txt) | sed '/^$/d')
    fi
    local _gitmoji_text=($(echo $_gitmoji | cut -f 3 -d ' '))
    local _gitmoji_emoji=($(echo $_gitmoji | cut -f 2 -d ' '))
    local _gitlog=$(git log --oneline)
    end_length=10
    for i in $(seq 1 $end_length); do
      local text=${_gitmoji_text[$i]}
      local emoji=${_gitmoji_emoji[$i]}
      _gitlog=$(echo $_gitlog | sed -e "s/$text/$emoji/g")
    done
    _gitlog=$(echo $_gitlog | sed -e 's/^/\\033[33m/g')
    _gitlog=$(echo $_gitlog | sed -e 's/ /\\033[0m /')
    echo
    local selected_commit=$(echo -e $_gitlog | fzf +m --height=70% --no-sort --ansi --cycle --bind='alt-h:abort,alt-j:down,alt-k:up,alt-l:accept,alt-c:abort,left:abort,right:accept')
    selected_commit=$(echo $selected_commit | cut -f 1 -d ' ')
    local lbuf=$LBUFFER
    local tail=${LBUFFER:$(( ${#LBUFFER} - ${#trigger} ))}
    LBUFFER="$lbuf""$selected_commit""$tail"
  else
    echo "Not a git repository."
    echo 
    echo 
  fi
  zle reset-prompt
}

zle     -N   _fzf_gitmoji_widget
bindkey '\eg\ec' _fzf_gitmoji_widget
zle     -N   _fzf_gitstatus_widget
bindkey '\eg\es' _fzf_gitstatus_widget
zle     -N   _fzf_gitlog_widget
bindkey '\eg\el' _fzf_gitlog_widget
