function asgci --wraps='aws sts get-caller-identity' --description 'alias asgci=aws sts get-caller-identity'
  aws sts get-caller-identity $argv
        
end
