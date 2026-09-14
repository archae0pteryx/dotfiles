function myaddr --wraps='curl icanhazip.com' --description 'alias myaddr=curl icanhazip.com'
  curl icanhazip.com $argv
        
end
