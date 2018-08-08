
# Yarn Repo
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

# NodeJS Repo
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -

# Install packages
sudo apt-get install -y git python-dev curl software-properties-common libmysqlclient-dev nodejs yarn python-pip


# Install bench package and init bench folder
cd /home/vagrant/
git clone https://github.com/frappe/bench .bench
sudo pip install ./.bench
bench init frappe-bench

# Move apps to shared Vagrant folder
mv /home/vagrant/frappe-bench/apps /vagrant/
mkdir -p /home/vagrant/frappe-bench/apps

# Auto-mount shared folder to into bench
echo -e "\nsudo mount --bind /vagrant/apps /home/vagrant/frappe-bench/apps\n" >> ~/.profile