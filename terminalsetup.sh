#!/bin/bash

clear # clears the terminal so the installer is displayed on a clean screen

# Installs dependencies for main installation
install_prereqs() {
    echo "Installation of dependencies has begun. Please wait..."
    # Create base directory if it doesn't exist
    mkdir -p $HOME/gits/dirtmuffin
    # update packages, install git and zsh
    sudo apt update
    sudo apt install -y git zsh unzip cowsay
    # install Oh My ZSH!
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    echo "Dependencies installed sucessfully."
}

# Installs the fonts if desktop installation is chosen.
install_fonts() {
    #Checks if /usr/share/fonts exists, and if not, creates it if user chooses.
    if [ -d "/usr/share/fonts" ]; then
        cd /usr/share/fonts
        sudo mkdir CascadiaCode
    else
        echo "Directory /usr/share/fonts does not exist. Would you like to create it? (1 = Yes/2 = No)"
        read -p "Choice: " CHOICE3
        case $CHOICE3 in
            1)
                echo "Creating /usr/share/fonts and adding CascadiaCode/"
                sudo mkdir -p /usr/share/fonts/CascadiaCode
            2)
                echo "Installation cannot continue without creating directory. Installer aborted."
                exit 1
            *)
                echo "Invalid input. I don't want to do error handling so the installer will just exit."
                exit 1
    fi
    #Unzips the font into the new directory then refreshes font cache to install font.
    unzip $HOME/gits/dirtmuffin/dotfiles/CascadiaCode.zip -d /usr/share/fonts/CascadiaCode
    fc-cache -fv
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
    sudo apt install -y btop
    echo "server packages installed sucessfully."
}

# Removes downloaded files/folders that are no longer needed after installation. User choice changes if/what is removed.
cleanup_process() {
    echo "Cleanup process has begun. Please wait..."
    
    case $CHOICE2 in
        1)
            echo "Cleanup option 1 selected. Removing the DirtMuffin folder and subfolders."
            cd $HOME/gits
            rm -rf dirtmuffin
            ;;
        2)
            echo "Cleanup option 2 selected. No cleanup ran."
            ;;
        *)
            echo "Invalid choice. I don't do the whole 'error handling' thing, so the installer will now exit. try picking a real option next time."
            ;;
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
echo "btop"
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - -"

# Show list of git repos to clone
echo "This script will clone the following repo for customization settings"
echo "Note: this will be deleted after the installation unless you choose 'no cleanup'"
echo "The settings files will remain in your home directory either way"
echo "https://github.com/dirtmuffin/dotfiles"
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - -"

# Prompt user for installation
echo "Select an option:"
echo "1. Server Install (Includes btop and excludes fonts)"
echo "2. Desktop Install (Excludes btop and includes fonts)"
echo "3. EXIT"
read -p "Choice: " CHOICE1

# Exits the program is user chooses to exit, else program moves forward.
if [ "$CHOICE1" -eq 3 ]; then
    echo "Program exited by user."
    exit 1
else
    # Prompt user to choose if cleanup happens
    echo "Post-install cleanup options. Please choose one: "
    echo "1. Standard cleanup (Removes the DirtMuffin folder and its contents)"
    echo "2. No cleanup. Leave ~/gits/DirtMuffin and all subfolders."
    read -p "Choice: " CHOICE2
fi

# Run the installation processes
install_control
cleanup_process

cowsay The installation was sucessful! Oh, I meant to say moo.
exit 0