pip install powerline-status
# .zshrc
# powerline-daemon -q
# export PATH=~/.local/bin/:$PATH
# . ~/.local/lib/python3.6/site-packages/powerline/bindings/zsh/powerline.zsh

# 文字化け対応
# clone
git clone https://github.com/powerline/fonts.git --depth=1
# install
cd fonts
./install.sh
# clean-up a bit
cd ..
rm -rf fonts
