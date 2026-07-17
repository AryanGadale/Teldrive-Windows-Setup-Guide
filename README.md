# ☁️ Teldrive Complete Windows Setup Guide

*Turn your Telegram account into an unlimited, streaming cloud drive with zero complex local database setup.*

[![View Live Website](https://img.shields.io/badge/View-Live_Website-blue?style=for-the-badge)](https://aryangadale.github.io/Teldrive-Windows-Setup-Guide/)
[![Download HTML Guide](https://img.shields.io/badge/Download-Offline_HTML_Guide-success?style=for-the-badge)](https://raw.githubusercontent.com/AryanGadale/Teldrive-Windows-Setup-Guide/main/index.html)

*(Note: To download the offline HTML guide, right-click the green Download button above and select "Save link as...")*

---

## 🛠️ Phase 1: Downloading the Correct File
The official GitHub instructions require complex coding knowledge and a painful local database setup. We are bypassing all of that by downloading the pre-packaged Windows version directly from SourceForge.

1. **Go to SourceForge:** Open your web browser and go to the official mirror: [Teldrive SourceForge Link](https://sourceforge.net/projects/telegram-drive.mirror/files/1.8.3/)
2. **Download the App:** Look through the list and click on the file named exactly `teldrive-1.8.3-windows-amd64.zip` (approx. 19.2 MB).
3. **Create the Main Folder:** Open your `C:` drive in Windows File Explorer. Right-click, create a new folder, and name it exactly `teldrive`.
4. **Extract Carefully:** Open your downloaded `.zip` file. Inside, you will see a file named `teldrive.exe`. Drag and drop this file directly into your new `C:\teldrive` folder.

> ⚠️ **BEGINNER TRAP:** Do not put it inside a folder within a folder. The path must be exactly `C:\teldrive\teldrive.exe`.

## 🔑 Phase 2: Getting Telegram Credentials
Teldrive needs secure permission to talk to Telegram on your behalf.

**1. Get the API Keys**
* Go to [my.telegram.org](https://my.telegram.org) and log in.
* Click on **API development tools**.
* If asked for an app name, type any random word.
* Copy two things: your **App ID** and your **App Hash**.

**2. Create the Storage Bucket**
* Open the Telegram app on your phone or PC.
* Create a **New Channel**.
* Name it **"My Cloud Drive"**.
* Set the channel type to **Private**.

**3. Create a Bot Worker**
* Search for **@BotFather** in Telegram (look for the verified checkmark).
* Send the command `/newbot`. Give it a name and a username ending in "bot".
* BotFather will reply with an HTTP API Token (e.g., `123...:ABC...`). **Copy this token.**

**4. Link the Bot**
* Go back to your private "My Cloud Drive" channel.
* Click channel name -> **Administrators** -> **Add Admin**.
* Search for your new bot and add it. **Crucial:** Ensure the **"Post Messages"** permission is enabled so it can upload files.

## 🗄️ Phase 3: Database (The Supabase Shortcut)
This step replaces the headache of installing PostgreSQL locally. Supabase hosts the database for you in the cloud for free.

1. Go to [Supabase.com](https://supabase.com), sign up, and click **New Project**.
2. Give your project a name and create a **strong database password**. Write it down!
3. Once built (takes ~2 mins), click the **Gear Icon** (Settings) on the left -> **Database**.
4. Scroll to the **Connection String** section, click the **URI** tab, and copy that entire link.

> 🚨 **THE PORT 6543 RULE:** Look at the link you just copied. Near the end, if it says `:5432`, you **must** manually change it to `:6543`. This forces the database into pooler mode and prevents crashing.

## ⚙️ Phase 4: The Configuration File

1. **Show File Extensions:** In File Explorer, click **View -> Show -> check File name extensions**.
2. **Open Notepad:** Copy and paste the text below exactly as it appears:

```toml
[db]
data-source = "postgresql://postgres:REPLACE_WITH_PASSWORD@your-supabase-link.com:6543/postgres"
prepare-stmt = false 

[jwt]
secret = "type_any_random_words_here"

[tg]
app-id = REPLACE_WITH_APP_ID 
app-hash = "REPLACE_WITH_APP_HASH"
auto-channel-create = false

[server]
port = 8080
```

**Fill in the Blanks:**
* `data-source`: Replace the link with the Supabase URI. Change `REPLACE_WITH_PASSWORD` to your password. *(Remove the `[ ]` brackets if you added any).*
* `app-id`: Replace with your Telegram App ID number.
* `app-hash`: Replace with your Telegram Hash *(Keep the quotation marks!)*.

💾 **Save the File:** Click **File -> Save As**. Change "Save as type" to **All Files (*.*)**. Save it directly into `C:\teldrive\` and name it exactly `config.toml`.

## 🚀 Phase 5: Launching the App

1. Click your Windows Start button, type **PowerShell**, and open it.
2. Type the following command and press Enter:
   ```powershell
   cd C:\teldrive
   ```
3. Type the launch command and press Enter:
   ```powershell
   .\teldrive.exe run -c config.toml
   ```
   *(If Windows Firewall pops up, click **Allow**).*
4. Open your browser and go to [http://localhost:8080](http://localhost:8080). Log in using your Telegram phone number. 
   > *Note: Telegram will instantly send a login code to your Telegram app (from the official Telegram service account). Enter that code on the website to complete the login.*
5. Click your **Profile Icon** (top right) -> **Settings**.
6. Go to the **Bots** tab. Paste your BotFather token and click **Add**.
7. Go to the **Channels** tab. Click on your "My Cloud Drive" channel so it highlights.

## 🎬 Phase 6: The VLC Streaming Fix
Web browsers have a strict bug that breaks VLC streaming links. These invisible scripts fix the bug so you can stream 4K movies directly from your new cloud.

**1. Create the VBS Wrapper**
Open a new Notepad, copy the code below, and save it as **All Files (*.*)** into `C:\teldrive\` named exactly `vlc-wrapper.vbs`.
```vbscript
Set objArgs = WScript.Arguments
If objArgs.Count > 0 Then
    url = objArgs(0)
    url = Replace(url, "vlc://", "")
    url = Replace(url, "http//", "http://")
    url = Replace(url, "https//", "https://")
    vlcPath = """C:\Program Files\VideoLAN\VLC\vlc.exe"""
    Set objShell = CreateObject("WScript.Shell")
    objShell.Run vlcPath & " """ & url & """", 1, False
End If
```

**2. Create the Registry Fix**
Open another new Notepad, copy the code below, and save it as **All Files (*.*)** to your **Desktop** named exactly `vbs-fix.reg`.
```registry
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Software\Classes\vlc]
@="URL:VLC Protocol"
"URL Protocol"=""

[HKEY_CURRENT_USER\Software\Classes\vlc\shell]

[HKEY_CURRENT_USER\Software\Classes\vlc\shell\open]

[HKEY_CURRENT_USER\Software\Classes\vlc\shell\open\command]
@="wscript.exe \"C:\\teldrive\\vlc-wrapper.vbs\" \"%1\""
```

**3. Apply the Fix & Configure VLC**
* Double-click the `vbs-fix.reg` file on your Desktop and click **Yes**.
* Open VLC Media Player. Go to **Tools -> Preferences**.
* At the bottom left, set "Show settings" to **All**.
* Click **Input / Codecs** on the left, scroll to **Network caching (ms)** on the right, and change it to `30000`.
* Click **Save**.

## 🔋 Phase 7: Keeping it Running (Background Mode)
If you close the PowerShell window, Teldrive stops working. To keep it running silently in the background whenever you turn on your computer, follow these quick steps:

**1. Create the Silent Script**
Open a new Notepad, copy the code below, and save it as `start-teldrive.vbs` directly into your `C:\teldrive\` folder (Save as All Files *.*).
```vbscript
Set WshShell = CreateObject("WScript.Shell")
WshShell.CurrentDirectory = "C:\teldrive"
WshShell.Run "cmd /c .\teldrive.exe run -c config.toml", 0, False
```

**2. Add to Windows Startup**
* Press **Win + R** on your keyboard, type `shell:startup`, and press Enter. This opens your Windows Startup folder.
* Go to your `C:\teldrive\` folder, right-click your new `start-teldrive.vbs` file, and click **Copy**.
* Go back to the Startup folder, right-click an empty space, and click **Paste shortcut**.

🎉 Teldrive will now automatically run invisibly every time you turn on your PC!
