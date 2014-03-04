role :web,    "107.150.7.215"
role :app,    "107.150.7.215"
role :db,     "107.150.7.215"
server '107.150.7.215', user: 'ezuhaib', roles: %w{web app db}, primary: true