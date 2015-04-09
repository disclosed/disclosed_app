set :stage, :production

# Replace 127.0.0.1 with your server's IP address!
server '104.131.36.44', user: 'deploy', roles: %w{web app db}, port: 32000

