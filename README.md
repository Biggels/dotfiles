# dotfiles
## Deployment
```
cd ~
git clone https://github.com/Biggels/dotfiles.git
cd dotfiles
```
Make sure GNU Stow is installed, then use `stow` and the name of one of the program subfolders. For example, `stow emacs` will install/symlink everything underneath the `emacs` subfolder. By default it will install into the parent directory of where the `stow` command was run, in other words the home folder in our case. So for programs where you want to install the config files elsewhere, like Nix, you need to set the `--target` directory. So for Nix, `stow -t /etc/nixos`.

[This](https://brandon.invergo.net/news/2012-05-26-using-gnu-stow-to-manage-your-dotfiles.html) article is a good overview of this approach, including a nice directory diagram explaining where things go when you `stow` them.
