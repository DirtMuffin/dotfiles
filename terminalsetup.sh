#!/bin/bash

# Installs dependencies for main installation
install_prereqs() {
    echo "Installation of dependencies has begun. Please wait..."
    # Create base directory if it doesn't exist
    mkdir -p $HOME/gits/dirtmuffin
    # update packages, install git and zsh
    sudo apt update
    sudo apt install -y git zsh
    echo "Dependencies installed sucessfully."
}

# clones the entire nerd fonts repo and installs the needed fonts
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
    # Check if dotfiles directory already exists. If so, do git pull rather than clone.
    if [ -d "$HOME/gits/dirtmuffin/dotfiles" ]; then
        echo "Dirtmuffin's dotfiles directory exists. Running pull..."
        cd $HOME/gits/dirtmuffin/dotfiles
        git pull
    else
        cd $HOME/gits/dirtmuffin
        git clone https://github.com/dirtmuffin/dotfiles
        cd $HOME/gits/dirtmuffin/dotfiles
    fi
    # coppies/overwrites config files from repo to user's home directory
    cp ./.tmux.conf $HOME
    cp ./.zshrc $HOME
    echo "Main installation has been completed sucessfully."
}

# Installs server-specific packages
server_addons() {
    echo "Installing server packages and configurations..."
    sudo apt install -y btop bottom
    echo "server packages installed sucessfully."
}

cleanup_process() {
    echo "Cleanup process has begun. Please wait..."
    
    case $CHOICE2 in
        1)
            echo "Cleanup option 1 selected. Removing all unnessecary files..."
            cd $HOME/gits
            rm -rf dirtmuffin
            rm -rf nerd-fonts
            ;;
        2)
            echo "Cleanup option 2 selected. Only removing unused fonts..."
            cd $HOME/gits
            rm -rf nerd-fonts
            ;;
        3)
            echo "Cleanup option 3 selected. No cleanup done..."
    esac
    echo "Cleanup process completed sucessfully."
}

# parses the user's choices and calls the needed functions.
install_control() {
    case $CHOICE1 in
    1)
        echo "Running server installation."
        install_prereqs
        install_main
        server_addons
        echo "Installation has completed."
        ;;
    2)
        echo "Running desktop installation."
        install_prereqs
        install_fonts
        install_main
        echo "Installation has completed."
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
}

# Startup message
echo ""
echo "Welcome to Dirtmuffin's Automatic Terminal Customizer!"
echo "This script will install everything needed to set up your terminal."

# Show lists of programs to be installed
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo "Included in all installations:"
echo "Git"
echo "ZSH"
echo "TMUX - https://github.com/tmux"
echo "Oh My ZSH - https://ohmyz.sh"
echo ""
echo "Added when choosing desktop installation:"
echo "Font(s)"
echo ""
echo "Added when choosing server installation:"
echo "btop, bottom"
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - -"

# Show list of git repos to clone
echo "This script will clone the following repo for customization settings"
echo "Note: this will be deleted after the installation unless you choose 'no cleanup'"
echo "The settings files will remain in your home directory either way"
echo "https://github.com/dirtmuffin/dotfiles"
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - -"

# Prompt user for installation
echo "Select an option:"
echo "1. Server Install (Includes btop, bottom, and excludes fonts)"
echo "2. Desktop Install (Excludes btop, bottom, and includes fonts) (Font install is slow)"
echo "3. EXIT"
read -p "Choice: " CHOICE1

# Prompt user to choose if cleanup happens
echo "Post-install cleanup options. Please choose one: "
echo "1. Cleanup everything (Removes DirtMuffin repo and unused fonts)"
echo "2. Cleanup fonts only (Removes unused fonts, leaves DirtMuffin repo intact)"
echo "3. No cleanup"
read -p "Choice: " CHOICE2

# Run the installation processes
install_control
cleanup_process
echo "If you're reading this, everything should have ran and the setup has exited."
exit 0