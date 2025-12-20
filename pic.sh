if ! command -v git >/dev/null 2>&1; then
    echo "install git first"
    exit 1
fi

if ! command -v make >/dev/null 2>&1; then
    echo "install make first"
    exit 1
fi
# make etc & install pfetch
cd ~
mkdir etc
cd etc
git clone --quiet https://github.com/dylanaraps/pfetch
cd pfetch
sudo make install
cd ..

# do some bashrc customization
sed -i '/case $- in/,/esac/{
    /esac/a\
\
clear\
pfetch
}' ~/.bashrc

sed -i "s|^    PS1=.*|    PS1='\\\\[\\\\e[38;5;250m\\\\][\\\\[\\\\e[38;5;141m\\\\]\\\\u\\\\[\\\\e[0m\\\\]\\\\[\\\\e[38;5;110m\\\\]@\\\\h\\\\[\\\\e[38;5;250m\\\\]] \\\\[\\\\e[38;5;215m\\\\]\\\\w › \\\\[\\\\e[0m\\\\]'|" ~/.bashrc

# install nodejs & npm

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# install doual for alias managment
npm i -g doual

# install bucket & aliases
dal bucket add douxxtech/dal-bucket
dal install system-tools --force
dal install systemctl-shortcuts --force
dal install text-processing --force
dal install git-essentials --force