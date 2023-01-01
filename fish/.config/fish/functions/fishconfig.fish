function fishconfig --wraps='code ~/.config/fish' --description 'alias fishconfig=code ~/.config/fish'
  code ~/.config/fish $argv; 
end
