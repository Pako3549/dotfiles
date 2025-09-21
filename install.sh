#!/bin/bash

# Dotfiles Installation Script
# Author: Pako
# Description: Automated installation script for Hyprland dotfiles
# Supports: Linux distributions only (package installation optimized for Fedora)
# Not supported: Windows, macOS (Hyprland is Linux-only)

# Note: Removed 'set -e' to handle errors more gracefully

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Get the dotfiles root directory (script is now in root)
DOTFILES_DIR="$SCRIPT_DIR"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running on Fedora
check_fedora() {
    # Check for Windows (WSL or native)
    if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" || -n "$WSL_DISTRO_NAME" ]]; then
        print_error "❌ Windows is not supported!"
        print_error "Hyprland is a Linux-only Wayland compositor and cannot run on Windows"
        print_error "Consider using WSL2 with a Linux distribution instead"
        exit 1
    fi
    
    # Check for macOS
    if [[ "$OSTYPE" == "darwin"* ]]; then
        print_error "❌ macOS is not supported!"
        print_error "Hyprland is a Linux-only Wayland compositor and cannot run on macOS"
        print_error "Consider using alternative window managers like yabai or Amethyst for macOS"
        exit 1
    fi
    
    # Check for Linux with Fedora
    if command -v dnf &> /dev/null; then
        print_success "Fedora detected - package installation will be performed"
        return 0
    else
        print_warning "Non-Fedora Linux system detected - skipping package installation"
        print_status "You'll need to manually install the required packages for your distribution"
        return 1
    fi
}

# Add Hyprland COPR repository
add_hyprland_copr() {
    if ! command -v dnf &> /dev/null; then
        print_status "Skipping COPR repository setup (not on Fedora)"
        return 0
    fi
    
    print_status "Adding Hyprland COPR repository..."
    if sudo dnf copr enable solopasha/hyprland -y; then
        print_success "Hyprland COPR repository added successfully"
    else
        print_error "Failed to add Hyprland COPR repository"
        exit 1
    fi
}

# Install dependencies
install_dependencies() {
    if ! command -v dnf &> /dev/null; then
        print_status "Skipping package installation (not on Fedora)"
        echo
        print_status "Please install the following packages manually for your distribution:"
        echo "• hyprland, hyprland-qtutils, hyprpolkitagent, waybar, kitty, fish, dunst"
        echo "• rofi-wayland, wlogout, swww, grim, slurp, wl-clipboard"
        echo "• cliphist, hyprshot, hyprpicker, pavucontrol, blueman"
        echo "• NetworkManager-tui, fastfetch, htop, btop"
        echo "• adwaita-gtk2-theme, adwaita-icon-theme, adw-gtk3-theme, adwaita-qt"
        echo
        return 0
    fi
    
    print_status "Installing dependencies..."
    
    local packages=(
        "hyprland"
        "hyprland-qtutils"
        "hyprpolkitagent"
        "waybar"
        "kitty"
        "fish"
        "dunst"
        "rofi-wayland"
        "wlogout"
        "swww"
        "grim"
        "slurp"
        "wl-clipboard"
        "cliphist"
        "hyprshot"
        "hyprpicker"
        "kdeconnectd"
        "kdeconnect-cli"
        "pavucontrol"
        "blueman"
        "NetworkManager-tui"
        "fastfetch"
        "htop"
        "btop"
        "adwaita-gtk2-theme"
        "adwaita-icon-theme"
        "adw-gtk3-theme"
        "qadwaitadecorations-qt5"
    )
    
    for package in "${packages[@]}"; do
        print_status "Installing $package..."
        if sudo dnf install -y "$package"; then
            print_success "$package installed successfully"
        else
            print_warning "Failed to install $package, continuing..."
        fi
    done
}

# Ask user for installation method
choose_installation_method() {
    echo
    print_status "Choose installation method:"
    echo "1. Symlinks (recommended) - Links to dotfiles, changes are reflected immediately"
    echo "2. Direct copy - Copies files independently of dotfiles"
    echo
    read -p "Enter your choice (1 or 2): " choice
    
    case $choice in
        1)
            print_status "Using symlinks for installation..."
            INSTALL_METHOD="symlink"
            ;;
        2)
            print_status "Using direct copy for installation..."
            INSTALL_METHOD="copy"
            ;;
        *)
            print_warning "Invalid choice, defaulting to symlinks..."
            INSTALL_METHOD="symlink"
            ;;
    esac
}

# Setup fonts
setup_fonts() {
    print_status "Setting up fonts..."
    
    # Create fonts directory
    mkdir -p ~/.local/share
    
    # Check if fonts directory exists in dotfiles
    if [ -d "$DOTFILES_DIR/.local/share/fonts" ]; then
        if [ "$INSTALL_METHOD" = "symlink" ]; then
            print_status "Creating symlink for fonts..."
            # Remove existing fonts directory/symlink if it exists
            rm -rf ~/.local/share/fonts
            ln -sf "$DOTFILES_DIR/.local/share/fonts" ~/.local/share/fonts
            print_success "Fonts symlink created"
        else
            print_status "Copying fonts directly..."
            # Create fonts directory if it doesn't exist
            mkdir -p ~/.local/share/fonts
            # Copy fonts if they exist, continue even if some fail
            if ls "$DOTFILES_DIR/.local/share/fonts"/* >/dev/null 2>&1; then
                cp -r "$DOTFILES_DIR/.local/share/fonts"/* ~/.local/share/fonts/ || true
                print_success "Fonts copied to ~/.local/share/fonts"
            else
                print_warning "No font files found to copy"
            fi
        fi
        
        # Refresh font cache
        print_status "Refreshing font cache..."
        fc-cache -fv >/dev/null 2>&1 || true
        print_success "Font cache refreshed"
    else
        print_warning "Fonts directory not found in dotfiles, skipping font setup"
    fi
}

# Setup configurations
setup_configurations() {
    print_status "Setting up configurations..."
    
    # Backup existing configs if they exist - dynamically detect all config directories
    local backup_created=false
    if [ -d "$DOTFILES_DIR/.config" ]; then
        for item in "$DOTFILES_DIR/.config"/*; do
            if [ -d "$item" ]; then
                config_name=$(basename "$item")
                # Skip fonts directory as it's handled separately
                if [ "$config_name" != "fonts" ]; then
                    if [ -d ~/.config/"$config_name" ] || [ -L ~/.config/"$config_name" ]; then
                        # Check if it's a symlink to avoid backing up symlinks pointing to our dotfiles
                        if [ -L ~/.config/"$config_name" ]; then
                            # It's a symlink, check if it points to our dotfiles
                            link_target=$(readlink ~/.config/"$config_name")
                            if [[ "$link_target" == "$DOTFILES_DIR"* ]]; then
                                print_status "Skipping backup of $config_name (already a symlink to dotfiles)"
                                continue
                            else
                                print_status "Backing up external symlink: $config_name -> $link_target"
                            fi
                        fi
                        
                        # Create backup directory only when needed
                        if [ "$backup_created" = false ]; then
                            print_status "Creating backup of existing configurations..."
                            mkdir -p ~/.config/backup
                            backup_created=true
                        fi
                        
                        cp -r ~/.config/"$config_name" ~/.config/backup/ 2>/dev/null || {
                            print_warning "Failed to backup $config_name configuration, continuing..."
                        }
                        if [ -d ~/.config/backup/"$config_name" ] || [ -L ~/.config/backup/"$config_name" ]; then
                            print_status "Backed up $config_name configuration"
                        fi
                    fi
                fi
            fi
        done
    fi
    
    # Setup configurations based on chosen method
    if [ -d "$DOTFILES_DIR/.config" ]; then
        # Find all items in .config except fonts
        for item in "$DOTFILES_DIR/.config"/*; do
            if [ -e "$item" ]; then
                basename_item=$(basename "$item")
                # Skip if it's a fonts directory
                if [ "$basename_item" != "fonts" ]; then
                    if [ "$INSTALL_METHOD" = "symlink" ]; then
                        # Remove existing directory/symlink if it exists
                        rm -rf ~/.config/"$basename_item"
                        ln -sf "$item" ~/.config/
                        print_success "Linked $basename_item configuration"
                    else
                        # Remove existing directory if it exists, then copy
                        rm -rf ~/.config/"$basename_item"
                        cp -r "$item" ~/.config/
                        print_success "Copied $basename_item configuration"
                    fi
                fi
            fi
        done
    else
        print_warning "Dotfiles .config directory not found"
    fi
}

# Change default shell to fish
change_shell_to_fish() {
    print_status "Changing default shell to fish..."
    
    # Check if fish is installed
    if ! command -v fish &> /dev/null; then
        print_warning "Fish shell not found, skipping shell change"
        return
    fi
    
    # Get current shell
    current_shell=$(basename "$SHELL")
    
    if [ "$current_shell" = "fish" ]; then
        print_success "Fish is already your default shell"
        return
    fi
    
    # Get fish path
    fish_path=$(which fish)
    
    # Check if fish is in /etc/shells
    if ! grep -q "$fish_path" /etc/shells; then
        print_status "Adding fish to /etc/shells..."
        echo "$fish_path" | sudo tee -a /etc/shells > /dev/null
    fi
    
    # Change user shell to fish
    if chsh -s "$fish_path"; then
        print_success "Default shell changed to fish"
        print_status "You'll need to logout and login again for the shell change to take effect"
    else
        print_warning "Failed to change shell to fish, you can do it manually with: chsh -s $fish_path"
    fi
}

# Main installation function
main() {
    print_status "Starting dotfiles installation..."
    print_status "Dotfiles directory detected: $DOTFILES_DIR"
    
    check_fedora
    add_hyprland_copr
    install_dependencies
    choose_installation_method
    setup_fonts
    setup_configurations
    change_shell_to_fish
    
    print_success "Dotfiles installation completed!"
    
    echo
    print_warning "⚠️  HYPRLAND SPECIFIC: Please review and update the following in hyprland.conf:"
    echo "• Keyboard layout: Check 'input { kb_layout = }' section"
    echo "• Monitor configuration: Check 'monitor = ' lines for your displays"
    echo "• Display resolution and refresh rate settings"
    echo "• Workspace assignments to monitors"
    echo
    
    print_status "Next steps:"
    if command -v dnf &> /dev/null; then
        echo "1. Logout and login to Hyprland session"
        echo "2. Enjoy your new setup!"
    else
        echo "1. Install the required packages for your distribution (see list above)"
        echo "2. Logout and login to Hyprland session"
        echo "3. Enjoy your new setup!"
    fi
}

# Run main function
main "$@"