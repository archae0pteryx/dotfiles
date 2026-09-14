function tfaa --wraps='terraform apply -auto-approve' --description 'alias tfaa=terraform apply -auto-approve'
  terraform apply -auto-approve $argv
        
end
