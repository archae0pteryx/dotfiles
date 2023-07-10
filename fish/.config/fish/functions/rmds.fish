function rmds --wraps=`ls` --wraps='find . ! -name ".git" ! -name "node_modules" -name ".DS_Store" -type f -print' --wraps='find . ! -name ".git" ! -name "node_modules" -name ".DS_Store" -type f -delete' --description 'alias rmds=find . ! -name ".git" ! -name "node_modules" -name ".DS_Store" -type f -delete'
  find . ! -name ".git" ! -name "node_modules" -name ".DS_Store" -type f -delete $argv
        
end
