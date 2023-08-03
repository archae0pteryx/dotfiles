function gpu --wraps='git push -u origin' --description 'alias gpu=git push -u origin'
  git push -u origin $argv
        
end
