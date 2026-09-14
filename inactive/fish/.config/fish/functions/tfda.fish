function tfda --wraps='terraform destroy -auto-approve' --description 'alias tfda=terraform destroy -auto-approve'
  terraform destroy -auto-approve $argv
        
end
