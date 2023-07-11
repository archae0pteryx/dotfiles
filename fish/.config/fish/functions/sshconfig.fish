function sshconfig --wraps='vim ~/.ssh/config' --wraps='vim ~/.ssh' --description 'alias sshconfig=vim ~/.ssh'
  vim ~/.ssh $argv
        
end
