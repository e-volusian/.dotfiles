# dotfiles
it's my dotfiles

```bash
if [ -f /usr/bin/git ] && [ ! -d ~/.dotfiles ]; then
  mv $HOME/.bashrc $HOME/.bashrc_$(date +%F-%H-%M-%S).bak
  git clone https://github.com/e-volusian/.dotfiles $HOME/.dotfiles
  /bin/bash $HOME/.dotfiles/install
fi
```

<br>

| file              | ready?     |
|-------------------|:----------:|
|bashrc             |✔           |
|screenrc           |✔           |
|tmux.conf          |✔           |
|vimrc              |✔           |
|alias              |✔           |
|functions          |✔           |
|inputrc            |✔           |
|spectrwm.conf      |✔           |
|openbox_rc.xml     |✔           |
