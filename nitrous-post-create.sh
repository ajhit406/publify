#!/bin/bash
rm -rf ~/code/example

sudo apt-get update
sudo apt-get install -y --no-install-recommends imagemagick
sudo apt-get clean

cd ~/code/publify

# publify requires ruby 2.2.0
rbenv install 2.2.0
rbenv global 2.2.0

createdb publify_dev
createdb publify_tests
mv ~/code/publify/config/database.yml.postgres ~/code/publify/config/database.yml

# bundle install
gem install bundler
bundle install
echo -e '\nPORT=3000\nIP=0.0.0.0' >> .env
sed -i 's|rails server|rails server -b $IP|g' Procfile

rake db:setup
rake db:migrate
rake db:seed
rake assets:precompile
rake db:test:prepare

echo -e '#!/bin/bash\nbundle exec foreman start' >> start-app
chmod +x start-app
