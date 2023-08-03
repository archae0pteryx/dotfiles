function gl --wraps='git log --oneline --graph' --description 'alias gl=git log --oneline --graph'
  git log --oneline --graph $argv
        
end
