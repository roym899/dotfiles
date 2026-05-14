"""Keyboard remapper to work around MacOS limitations for more consistent setup across different operating systems."""

import os
from pynput import keyboard

# Define the action: Opening Launchpad
def open_launchpad():
    # This triggers the Launchpad overlay
    os.system("open -a 'Launchpad'")

def on_press(key):
    try:
        # Listening for the Control key (left or right)
        if key == keyboard.Key.ctrl or key == keyboard.Key.ctrl_l or key == keyboard.Key.ctrl_r:
            open_launchpad()
    except AttributeError:
        pass

def main():
    print("Remapper active: Press 'Ctrl' to open Launchpad.")
    print("Press 'Esc' to stop the script.")
    
    with keyboard.Listener(on_press=on_press) as listener:
        listener.join()

if __name__ == "__main__":
    main()

