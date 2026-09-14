function dcr --wraps='docker compose run --rm' --description 'alias dcr=docker compose run --rm'
  docker compose run --rm $argv
        
end
