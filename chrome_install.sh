sudo apt update
sudo apt install -y curl unzip xvfb libxi6 libgconf-2-4
curl -O https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
sudo apt --fix-broken install
sudo dpkg -i google-chrome-stable_current_amd64.deb
google-chrome-stable
