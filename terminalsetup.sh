#!/bin/bash

# Creates directories needed for install
create_directories() {
    mkdir -p $HOME/gits/dirtmuffin || { echo "ERROR: Failed to create directory: ~/gits/dirtmuffin. Exiting..."; exit 1; }
}

# Installs dependencies for main installation
install_prereqs() {
    echo "Installation of dependencies has begun. Please wait..."
    # update packages, install git and zsh
    sudo apt update
    sudo apt install -y git zsh
    echo "Dependencies installed sucessfully."
}

# Installs fonts
install_fonts() {
echo "Installing font(s). Please wait..."
cd $HOME/gits
git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git # Only way to do this according to official docs... Takes a while
cd nerd-fonts/
./install.sh CaskaydiaCove # runs nerdfont's installer script to unpack needed font from downloaded repo.
echo "Font(s) installed sucessfully."
}

# Pulls dirtmuffin/dotfiles repo and replaces relevant config files in home directory
install_main() {
    echo "Installation of main components has begun. Please wait..."
    cd $HOME/gits/dirtmuffin
    git clone https://github.com/dirtmuffin/dotfiles
    cd $HOME/gits/dirtmuffin/dotfiles
    cp ./.tmux.conf $HOME
    cp ./.zshrc $HOME
    echo "Main installation has been completed sucessfully."
}

cleanup_process() {
    echo "Cleanup process has begun. Please wait..."
    cd $HOME/gits
    rm -rf dirtmuffin
    rm -rf nerd-fonts
    echo "Cleanup process completed sucessfully."
}

# Startup message
echo "Welcome to Dirtmuffin's Automatic Terminal Customizer!"
echo "This script will install everything needed to set up your terminal."

# Show list of programs to be installed
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo "This script will install the following programs:"
echo "Git"
echo "ZSH"
echo "TMUX - https://github.com/tmux"
echo "Oh My ZSH - https://ohmyz.sh"
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - -"

# Show list of git repos to clone
echo "This script will clone the following repo for customization settings"
echo "Note: this will be deleted after the installation unless you choose 'no cleanup'"
echo "The settings files will remain in your home directory either way"
echo "https://github.com/dirtmuffin/dotfiles"
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - -"

# Show list of fonts to install
echo "The required fonts will be installed from NerdFont:"
echo "CaskaydiaCove Mono"
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - -"

# Prompt user for installation
echo "Select an option:"
echo "1. Install"
echo "2. Install (NO CLEANUP)"
echo "3. EXIT"
read -p CHOICE

# Process user choice and run cooresponding install
case $CHOICE in
    1)
        echo "Running standard installation."
        install_prereqs
        install_fonts
        install_main
        cleanup_process
        echo "Installation has completed."
        ;;
    2)
        echo "Running NO CLEANUP installation."
        install_prereqs
        install_fonts
        install_main
        echo "No cleanup installation has completed. All git repo paths and files intact."
        ;;
    3)
        echo "Installation aborted by user. Exiting..."
        exit 1
        ;;
    *)
        echo "Invalid choice. Exiting..."
        exit 1
        ;;
esac
