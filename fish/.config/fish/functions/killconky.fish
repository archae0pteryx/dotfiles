function killconky --wraps='killall conky && conky -c ~/.config/conky/conky.conf &' --wraps='killall conky && conky -c ~/.config/conky/conky.conf' --description 'alias killconky=killall conky && conky -c ~/.config/conky/conky.conf'
  killall conky && conky -c ~/.config/conky/conky.conf $argv
        
end
