# 🎯 Hooping Quick Start Guide

## Contents
- [What It Does](#what-it-does)
- [Getting Started](#getting-started)
- [How It Works](#how-it-works)
- [Configuration](#configuration)
- [Safety & Controls](#safety--controls)
- [FAQ](#faq)
- [Community](#community)

## What It Does

This script helps perfect your directional jumps in WoW by synchronizing your movement keys with spacebar. The default layout is:
```
Q W E
A   D
```
Perfect for:
- 🎯 Gulch hoopin
- 🐎 Mount jumps
- 🗺️ Exploration

## Getting Started

You can find a compiled hoop.exe in the Releases section toward the right of the page under the `About` section.
For those who don't want to run a random .exe, you can see whats in the hoop.ahk file in this repo, and run that.

### 1. Install AutoHotkey v2

If you're on modern Windows, you have winget. Access it through the terminal.

1. Press windows+R, type `powershell`, type `winget --help`
2. Search for autohotkey `winget search autohotkey`
3. Install it by running the command below or grab it from [autohotkey.com](https://www.autohotkey.com)

```PowerShell
winget install AutoHotkey.AutoHotkey
```

### 2. Setup
1. Download `hoop.ahk` 
2. Review the code (always smart!) or just use hoop.exe
3. Double-click the hoop.ahk to run
4. Look for the tray icon

## How It Works

### Core Logic
The script uses an advanced input monitoring system that:

1. **Watches Keys**: Monitors your directional keys (Q,W,E,A,D) and spacebar
2. **Perfect Timing**: Sends directional input slightly before spacebar
3. **Natural Feel**: Adds tiny random delays for authentic movement

```
Timing Example:
[Direction]--[tiny delay]--[Space]--[Hold]--[Release]
     ^           16ms        ^        50ms      ^
```

### Pre-configured Jumps
```ahk
F11 = Mount + Forward jump + Dismount
F13 = Quick forward hop
```

## Configuration

### Default Settings

```ahk
JUMP_WINDOW  := 150    ; Detection window (ms)
MIN_DELAY    := 1      ; Minimum key delay
MAX_DELAY    := 15     ; Maximum key delay
DIR_PREFIRE  := 16     ; Direction->Space delay
```

### Customization
Edit in the Config class:

```ahk
; Adjust which keys to watch
DIR_KEYS := ["q", "w", "e", "a", "d"]

; Tweak timing (milliseconds)
JUMP_WINDOW := 150  ; Detection window
DIR_PREFIRE := 16   ; Direction->Space delay
```

## Safety & Controls

### Quick Controls
- `LAlt + Esc` = Reload script
- `LAlt + Ctrl + Esc` = Emergency stop
- Tray icon for quick access

### Safety Features
- ✅ Only works in WoW window
- ✅ Passive key monitoring (no movement interference)
- ✅ Emergency key release system
- ✅ Clean exit handling

## FAQ

### "Is this safe to use?"
Like any automation tool, use at your own risk. This script uses standard input methods and doesn't modify the game.

### "My jumps feel off?"
Try adjusting these values in the Config class:
- `JUMP_WINDOW`: Detection window
- `DIR_PREFIRE`: Delay between direction and space

### "Keys getting stuck?"
The script has multiple safety systems, but if needed:
- `LAlt + Esc` to reload
- `LAlt + Ctrl + Esc` to stop completely

### "Is this a crutch?"
It's a tool that helps overcome keyboard hardware limitations. Meaning it lets you use a keyboard from the [modern age without handicapping yourself](https://youtu.be/3oaJXgiqW3E?si=SZATTkSQNLs2Hcm1&t=112)


### "I still can't hoop maybe I'm too old"
The script helps with timing consistency, but the best hoopers have failed more times than you've tried probably. Practice.

## Community

### Kromkrush OG (who taught me to FC)
[![Sqwippy](https://img.youtube.com/vi/YGYnf9nGpeY/default.jpg)](https://www.youtube.com/watch?v=YGYnf9nGpeY)

### Shoutouts to the Homies
- kff
- hello hello
- Purge Squad
- WHO
- good talk
- Aziz & company who request the same ahk every new server
- Have fun

#### [![it's only game](https://img.youtube.com/vi/xzpndHtdl9A/default.jpg)](https://www.youtube.com/watch?v=xzpndHtdl9A)

---

# See yall in the gulch 

---

## Possible Next Steps

I open-sourced this so be creative. 
If you add something let me know though.

### Add new jump sequences

Inside the Config class, add to sequences array:

```autohotkey
static SEQUENCES := [
    ; Existing sequences
    {
        trigger: "F11",          ; Mount jump
        directionKey: "w",       ; Forward jump
        holdTime: 3150,          ; 3s mount cast + buffer
        postKey: "F12",          ; Dismount key
        postDelay: 10            ; Quick dismount after landing
    },
    
    ; New sequence examples:
    {
        trigger: "XButton1",     ; Mouse side button
        directionKey: "e",       ; Right-forward diagonal
        holdTime: 75             ; Longer hop
    },
    {
        trigger: "XButton2",     ; Other mouse side button
        directionKey: "q",       ; Left-forward diagonal
        holdTime: 50,            ; Quick hop
        postKey: "Space",        ; Double-jump
        postDelay: 100          ; Wait before second jump
    },
    {
        trigger: "F9",           ; WSG flag room jump
        directionKey: "w",       ; Forward
        holdTime: 65,            ; Precise timing
        postKey: "e",           ; Strafe right after
        postDelay: 50           ; Quick strafe timing
    }
]
```

### Experiment with timing windows

1. Jump timings

```autohotkey

50-65    ; Quick hop
65-85    ; Medium jump
85-100   ; Long jump
3150     ; Mount cast + jump
```

2. Post delays

```autohotkey
10-25    ; Quick follow-up
50-100   ; Mid-air action
100-200  ; Landing action
750+     ; Mount jump chain
```

### Fine-tune scenarios by location

Specific jump owns you? There's probably a way.

```autohotkey
; WSG flag room jumps
{
    trigger: "F5",           ; Horde roof
    directionKey: "w",
    holdTime: 75,
    postKey: "q",
    postDelay: 25
},
{
    trigger: "F6",           ; Alliance tunnel
    directionKey: "w",
    holdTime: 65,
    postKey: "d",
    postDelay: 50
},

; AB jumps
{
    trigger: "F7",           ; BS to road
    directionKey: "w",
    holdTime: 85,
    postKey: "Space",
    postDelay: 100
},

; AV jumps
{
    trigger: "F8",           ; IBGY skip
    directionKey: "w",
    holdTime: 95,
    postKey: "e",
    postDelay: 75
}
```

### Add new macro pattern logic

Basic directional hops to complex ideas

```autohotkey
{
    trigger: "NumpadEnd",    ; Numpad 1
    directionKey: "a",       ; Left
    holdTime: 50            ; Quick hop
},
{
    trigger: "NumpadDown",   ; Numpad 2
    directionKey: "s",       ; Back
    holdTime: 50
},
{
    trigger: "NumpadPgdn",   ; Numpad 3
    directionKey: "d",       ; Right
    holdTime: 50
}
```

```autohotkey
{
    trigger: "F8",           ; WSG roof jump
    directionKey: "w",       ; Forward
    holdTime: 75,           ; Longer jump
    postKey: "q",           ; Diagonal after
    postDelay: 25           ; Quick transition
},
{
    trigger: "^w",          ; Ctrl+W
    directionKey: "w",      ; Forward
    holdTime: 3150,         ; Mount cast
    postKey: "Space",       ; Second jump
    postDelay: 750         ; Wait for apex
}
```

###  Available modifiers

Sample of available modifiers

```autohotkey
; Modifier symbols:
^ = Ctrl
! = Alt
+ = Shift
# = Windows key

"^F1"    ; Ctrl+F1
"!a"     ; Alt+A
"+Space" ; Shift+Space
"^!c"    ; Ctrl+Alt+C

XButton1  ; Mouse 4
XButton2  ; Mouse 5
MButton   ; Middle click
```
