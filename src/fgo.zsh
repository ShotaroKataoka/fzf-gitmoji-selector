function fgo() {
  local _ANSI_COLOR_RED="\\033[31;1m"
  local _ANSI_COLOR_GREEN="\\033[32m"
  local _ANSI_COLOR_YELLOW="\\033[33m"
  local _ANSI_COLOR_GRAY="\\033[38;05;245m"
  local _ANSI_COLOR_END="\\033[0m"

  local _is_git_dir=$(git rev-parse --git-dir 2> /dev/null)
  if [ -n "$_is_git_dir" ]; then
    local _git_dir=$(git rev-parse --show-toplevel 2> /dev/null)
  fi
  if [ "$1" = "emoji" ]; then
    if [ "$2" = "init" ]; then
      if [ -n "$_git_dir" ]; then
        local cp_status=$(cp -v $HOME/.fgo/user/git_emoji_list.txt "$_git_dir/.fgo_emoji_list.txt")
        local ret="$?"
        if [ $ret -eq 0 ]; then
          if [ -n "$cp_status" ]; then
            echo "$_ANSI_COLOR_GREEN Success:$_ANSI_COLOR_END create $_git_dir/.fgo_emoji_list.txt"
          fi
        fi
      else
        echo "Not a git repository."
      fi
    elif [ "$2" = "edit" ]; then
      if [ "$3" = "global" ]; then
        vim $HOME/.fgo/user/git_emoji_list.txt
      else;
        if [ -n "$_git_dir" ]; then
          if [ -f "$_git_dir/.fgo_emoji_list.txt" ]; then
            vim $_git_dir/.fgo_emoji_list.txt
          else;
            echo "$_ANSI_COLOR_RED Faild:$_ANSI_COLOR_END Not found .fgo_emoji_list.txt"
            echo "$_ANSI_COLOR_YELLOW hint:$_ANSI_COLOR_END exec 'fgo init emoji' first."
          fi
        else
          echo "Not a git repository."
        fi
      fi
    elif [ "$2" = "list" ]; then
      if [ "$3" = "global" ]; then
        cat $HOME/.fgo/user/git_emoji_list.txt
      else;
        if [ -n "$_git_dir" ]; then
          if [ -f "$_git_dir/.fgo_emoji_list.txt" ]; then
            cat $_git_dir/.fgo_emoji_list.txt
          else;
            echo "$_ANSI_COLOR_RED Faild:$_ANSI_COLOR_END$_git_dir /.fgo_emoji_list.txt not found."
          fi
        else
          echo "Not a git repository."
        fi
      fi
    else;
      echo "$_ANSI_COLOR_RED Error:$_ANSI_COLOR_END invalid keyword"
    fi
  else;
    echo "$_ANSI_COLOR_RED Error:$_ANSI_COLOR_END invalid keyword"
  fi

}