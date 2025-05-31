# Terminal Snippet Launcher

This project provides a simple yet powerful shell script to manage and quickly access your frequently used terminal snippets. It leverages `fzf` for fuzzy searching and your system's clipboard utility (`wl-copy` for Wayland or `xclip` for X11) to copy selected snippets to your clipboard.

Unlike a full-fledged snippet manager, this tool focuses on a streamlined workflow where your snippets are stored in a single, human-readable CSV file that you can edit manually.

## Features

- **Fuzzy Search:** Quickly find snippets by their name or associated tags using `fzf`.
- **Clipboard Integration:** Copy the selected snippet content directly to your clipboard.
- **Simple Storage:** All snippets are stored in a single CSV file, making them easy to manage with any text editor.
- **Custom Delimiter:** Uses a robust delimiter (`###`) to avoid conflicts with snippet content.
- **Clean Copy:** Automatically strips leading/trailing whitespace and ensures no trailing newline character is copied.
- **Preview:** Shows a preview of the snippet content directly in `fzf`.

## Prerequisites

Before using the snippet launcher, ensure you have the following tools installed on your Linux system (e.g., Fedora 42):

- **`fzf`**: A command-line fuzzy finder.

```
sudo dnf install fzf
```
- **Clipboard Utility**:
    - For **Wayland** (default on Fedora 42 Gnome):

```
sudo dnf install wl-clipboard # Provides wl-copy
```
    - For **X11**:

```
sudo dnf install xclip
```

- _(You can check your display server with `echo $XDG_SESSION_TYPE`)_
- **`awk`**: Usually pre-installed on Linux.
- **`sed`**: Usually pre-installed on Linux.
- **`tr`**: Usually pre-installed on Linux.

## Installation

1. **Create the script file:** Save the script content (from our previous conversation) into a file named `snippet_launcher.sh` (or any name you prefer).

2. **Make the script executable:**

```
chmod +x snippet_launcher.sh
```
3. **Move the script to your PATH:** It's recommended to place the script in a directory that's already in your system's `PATH` environment variable, such as `~/.local/bin/`.

```
mkdir -p ~/.local/bin
mv snippet_launcher.sh ~/.local/bin/
```

If `~/.local/bin` is not in your `PATH`, add the following line to your shell's configuration file (e.g., `~/.bashrc` or `~/.zshrc`):

```
export PATH="$HOME/.local/bin:$PATH"
```

Then, apply the changes by sourcing your config file:

```
source ~/.bashrc # or source ~/.zshrc
```

## Creating Your Snippets CSV File

The snippet launcher reads your snippets from a single CSV file.

1. **Location:** Create the `snippets.csv` file in the following directory:

```
~/.local/share/snippets/snippets.csv
```

You can create the directory structure using:

```
mkdir -p ~/.local/share/snippets/
touch ~/.local/share/snippets/snippets.csv
```
2. **Format:** Each line in `snippets.csv` represents a single snippet and should follow this format:

```
Snippet Name###tags separated by spaces###actual snippet content
```
    - **`Snippet Name`**: A unique, descriptive name for your snippet. This is the primary identifier you'll see and search by.
    - **`###`**: This is the **delimiter** that separates the fields. It's chosen to be unlikely to appear within your actual snippet content.
    - **`tags separated by spaces`**: A space-separated list of keywords or categories that describe your snippet. These tags are also searchable by `fzf`.
    - **`actual snippet content`**: The full text or command you want to copy to your clipboard.

3. **Example `snippets.csv` content:**

```
git-log-alias###git alias log###git config --global alias.ll "log --oneline --graph --all"
my-email###personal contact###my.email@example.com
current-date###bash date time###date +%Y-%m-%d
ssh-connect###ssh server###ssh user@your_server_ip
```
4. **Editing Snippets:** To add, edit, or delete snippets, simply open `~/.local/share/snippets/snippets.csv` with your favorite text editor and modify it directly.

```
nvim ~/.local/share/snippets/snippets.csv # or gedit, nano, etc.
```

## Usage

Once installed and your `snippets.csv` file is set up, simply run the script from your terminal:

```
snippet_launcher.sh
```

This will launch `fzf` in an interactive mode:

1. **Search:** Start typing to fuzzy search for snippets. `fzf` will match against both the **Snippet Name** and the **Tags**.
2. **Preview:** A preview pane will display the content of the currently highlighted snippet, titled "--- Snippet ---".
3. **Copy:** Press `Enter` on the selected snippet. Its content (the third column) will be automatically copied to your system's clipboard.
4. **Exit:** Press `Ctrl+C` or `Esc` to exit `fzf` without copying.

Enjoy your efficient terminal snippet management!
