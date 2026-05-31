#!/bin/bash
# Re-runs whenever this file's contents change.
set -euo pipefail

echo "==> Applying macOS defaults"

# --- Keyboard ---
# Fast key repeat
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
# Disable press-and-hold for accents (so holding a key repeats)
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Map Caps Lock -> Control (requires logout to take effect for some setups).
# Uses hidutil; persistent across reboots via LaunchAgent below if desired.
hidutil property --set '{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000039,"HIDKeyboardModifierMappingDst":0x7000000E0}]}' >/dev/null

# --- Finder ---
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"  # list view

# --- Dock ---
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock tilesize -int 42

# --- Screenshots ---
mkdir -p "$HOME/Screenshots"
defaults write com.apple.screencapture location -string "$HOME/Screenshots"
defaults write com.apple.screencapture type -string "png"

# --- Trackpad ---
defaults write NSGlobalDomain com.apple.trackpad.scaling -float 2.5
defaults write -g com.apple.mouse.tapBehavior -int 1   # tap to click

# Restart affected apps
killall Finder >/dev/null 2>&1 || true
killall Dock >/dev/null 2>&1 || true
killall SystemUIServer >/dev/null 2>&1 || true

echo "==> macOS defaults applied"
