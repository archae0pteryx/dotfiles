function pbcopy --wraps='xsel -i --trim' --description 'alias pbcopy=xsel -i --trim'
  xsel -i --trim $argv
        
end
