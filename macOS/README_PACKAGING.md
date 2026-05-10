# Memories Wizard - macOS Packaging Guide

To create the **.dmg** file for macOS, you need to open this project on a Mac with **Xcode** installed.

### 1. Open the Project
Copy the `macOS/` folder to your Mac and open it in Xcode.

### 2. Create the App Bundle
- In the top menu, go to **Product > Archive**.
- Once the archive is created, the Organizer window will open.
- Click **Distribute App** and choose **Copy App**.
- This will give you the `MemoriesWizard.app` bundle.

### 3. Create the .dmg (Standard Way)
1. Open **Disk Utility** on your Mac.
2. Go to **File > New Image > Image from Folder**.
3. Select the folder containing your `MemoriesWizard.app`.
4. Set 'Image Format' to **read-only** or **compressed**.
5. Save it, and you have your `.dmg`!

### 4. Create the .dmg (Premium Way - Recommended)
Use a tool like **create-dmg** (available via Homebrew):
```bash
brew install create-dmg
create-dmg \
  --volname "Memories Wizard Installer" \
  --window-pos 200 120 \
  --window-size 800 400 \
  --icon-size 100 \
  --icon "MemoriesWizard.app" 200 190 \
  --hide-extension "MemoriesWizard.app" \
  --app-drop-link 600 185 \
  "MemoriesWizard.dmg" \
  "path/to/folder_with_app/"
```
