#!/bin/bash
START=`date +%s`

#log file
LOGFILE="script.log"

#Security Level
LEVEL[6]="\033[0;32m[Info]"
LEVEL[3]="\033[0;31m[Err]"
LEVEL[5]="\033[0;33m[Notice]"

#Mensage Function
function msg {
        echo -e "${LEVEL[$1]} $2"
}

#Distro check
DISTRO_CHECK="$(cat /etc/issue | grep 'SUSE')"

if [[ $DISTRO_CHECK ]]; then
	msg 6 "You are running openSuse"
	PKG_MGR="zypper --non-interactive "
else
	msg 6 "You are running Ubuntu"
	PKG_MGR="apt-get -y "
fi

#Packages
PKGS=(git vim zsh)

#Check Function
function package_check {
        command -v $1 &>> $LOGFILE
}

function package_install {
        for i in "$@"
        do
                package_check $i && msg 5 "Package already installed" && continue;
                if eval sudo ${PKG_MGR} install $i; then
                        msg 6 "Package ${i} installed"
                else
                        msg 3 "Package ${i} not installed"
                fi
        done
}

function subl_pkg {
    if [ -d "${HOME}/.config/sublime-text-3/Packages/$1" ]; then
        msg 5 "Package $1 already installed"
    else
        git clone $2 "$1"
        mv "$1" "${HOME}/.config/sublime-text-3/Packages/"
    fi
}

msg 6 "Updating repos..."
#eval sudo ${PKG_MGR} update

package_install "${PKGS[@]}"

#Setup zsh
if [ -d "${HOME}/.oh-my-zsh" ] ; then
        msg 5 "Oh-my-zsh is already installed"
else
        sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
fi

#Install sublime text
if package_check "sublime"; then
        msg 5 "Sublime Text 3 is already installed"
else
        msg 6 "Installing Sublime Text"
        wget https://download.sublimetext.com/sublime_text_3_build_3114_x64.tar.bz2
        tar vxjf sublime_text_3_build_3114_x64.tar.bz2
        sudo mv sublime_text_3 /opt/
        sudo ln -s /opt/sublime_text_3/sublime_text /usr/bin/sublime
        rm sublime_text_3_build_3114_x64.tar.bz2
fi

if [ -f "${HOME}/.config/sublime-text-3/Installed Packages/Package Control.sublime-package" ] ; then
    msg 5 "Sublime packages are set"
else
    wget --no-check-certificate https://sublime.wbond.net/Package%20Control.sublime-package    
    mv "Package Control.sublime-package" "${HOME}/.config/sublime-text-3/Installed Packages/Package Control.sublime-package"
    msg 6 "Sublime successfully set"
fi

#Sublime packages
subl_pkg "AdvancedNewFile" "https://github.com/skuroda/Sublime-AdvancedNewFile.git" 
subl_pkg "Theme - Phoenix" "https://github.com/netatoo/phoenix-theme.git"
subl_pkg "emment-sublime"  "https://github.com/sergeche/emmet-sublime.git"
subl_pkg "SublimeAllAutocomplete"  "https://github.com/alienhard/SublimeAllAutocomplete"
subl_pkg "DocBlockr"  "https://github.com/spadgos/sublime-jsdocs.git"
subl_pkg "SublimeCodeIntel"  "https://github.com/SublimeCodeIntel/SublimeCodeIntel.git"

#Sublime settings
cp "Preferences.sublime-settings" "${HOME}/.config/sublime-text-3/Packages/User/" && msg 6 "Sublime Preferences created"
cp "Default.sublime-keymap" "${HOME}/.config/sublime-text-3/Packages/User/Default \(Linux\).sublime-keymap"

#VIM setups
cp vimpackage "${HOME}/.vimrc" && msg 6 ".vimrc file created"
if [ -d "${HOME}/.vim/bundle/Vundle.vim" ]; then
	msg 5 "Vim already ready to go..."
else
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi
vim +PluginInstall +qall
cat vimrc >> "${HOME}/.vimrc" && msg 6 ".vimrc is ready to go.."

RUNTIME=$((`date +%s`-START))
msg 6 "Script delayed ${RUNTIME} seconds"

