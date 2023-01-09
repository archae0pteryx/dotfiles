function pgstart --wraps='/usr/local/opt/postgresql@14/bin/postgres -D /usr/local/var/postgresql@14' --description 'alias pgstart=/usr/local/opt/postgresql@14/bin/postgres -D /usr/local/var/postgresql@14'
  /usr/local/opt/postgresql@14/bin/postgres -D /usr/local/var/postgresql@14 $argv; 
end
