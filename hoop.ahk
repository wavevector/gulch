/*
    hoop.ahk
    Copyright (C) 2024, 202 wavenumber

    This script is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as
    published by the Free Software Foundation, either version 3 of the
    License, or (at your option) any later version.

    This script is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this script.  If not, see <http://www.gnu.org/licenses/>.
*/

;===============================================================================
;                           SCRIPT INFORMATION
;===============================================================================
; Version:      1.0
; Description:  Directional hooping to help my homie Aziz
; Last Update:  12/December/2024
; Creator:      wavevector
; URL:          https://github.com/wavevector/gulch/
;
; Purpose:
; - Combines directional keys with spacebar for perfect timing
; - Watches for direction keys within a time window of spacebar press
; - Supports automated jump sequences with custom timings
;
; Usage:
; - Edit the user config section below
; - Create custom jump sequences in the hotkeys array
; - Use LAlt+Esc to reload, LAlt+Ctrl+Esc to exit
;-------------------------------------------------------------------------------


;===============================================================================
;                           INITIALIZATION
;===============================================================================
#Requires AutoHotkey v2.0
#SingleInstance Force
SetWorkingDir A_ScriptDir
Persistent

;===============================================================================
;                           CONFIGURATION
;===============================================================================
; Configuration class holds all adjustable parameters and sequences
class Config {
    ; Timing configurations
    static JUMP_WINDOW := 150        ; Time window for jump detection (ms)
    static MIN_DELAY := 1            ; Minimum key press delay
    static MAX_DELAY := 15           ; Maximum key press delay
    static DIR_PREFIRE := 16         ; Time between direction and space (ms)
    
    ; Valid directional keys to monitor
    ; Default layout:
    ;   Q W E
    ;   A   D
    static DIR_KEYS := ["q", "w", "e", "a", "d"]
    
    ; Predefined jump sequences
    static SEQUENCES := [
        {
            trigger: "F11",          ; Mount jump
            directionKey: "w",       ; Forward jump
            holdTime: 3150,          ; 3s mount cast + buffer
            postKey: "F12",          ; Dismount key
            postDelay: 10            ; Quick dismount after landing
        },
        {
            trigger: "F13",          ; Quick hop
            directionKey: "w",       ; Forward jump
            holdTime: 50             ; Brief tap for small hop
        }
    ]
}

;===============================================================================
;                           UTILITY FUNCTIONS
;===============================================================================
; Check if array contains value
HasValue(haystack, needle) {
    if !IsObject(haystack)
        return false
    if haystack.Length = 0
        return false
    for value in haystack {
        if (value = needle)
            return true
    }
    return false
}

; Safely send key combinations with directional pre-fire
SafeSend(keys, holdTime := 50) {
    try {
        ; Separate directional key and space
        dirKey := keys[1]    ; First key is always directional
        
        ; Send directional key first
        Send "{" dirKey " down}"
        Sleep(Config.DIR_PREFIRE)    ; Tiny delay before space
        
        ; Send space
        Send "{Space down}"
        
        ; Hold for specified duration
        Sleep(holdTime)
        
        ; Release in reverse order (space first, then direction)
        Send "{Space up}"
        Sleep(Random(Config.MIN_DELAY, Config.MAX_DELAY))
        Send "{" dirKey " up}"
        
    } catch Error as err {
        ; Emergency release all keys if error occurs
        Send "{Space up}"
        Send "{" dirKey " up}"
    }
}

;===============================================================================
;                           KEY MONITORING
;===============================================================================
; Handles all key input monitoring and jump detection
class KeyMonitor {
    ; Static properties for state management
    static ih := InputHook()         ; Input hook instance
    static isActive := false         ; Monitoring state
    static lastSpaceTime := 0        ; Timestamp of last space press
    static lastDirectionKey := ""    ; Last detected direction key
    
    ; Initialize the key monitor
    static Init() {
        ; Configure input hook to monitor all keys
        this.ih.KeyOpt("{All}", "E")
        
        ; Bind callbacks with proper context
        this.ih.OnKeyDown := this.OnKeyDown.Bind(this)
        this.ih.OnKeyUp := this.OnKeyUp.Bind(this)
        
        ; Start monitoring
        this.Start()
    }
    
    ; Start key monitoring if not already active
    static Start() {
        if (!this.isActive) {
            this.ih.Start()
            this.isActive := true
        }
    }
    
    ; Stop key monitoring if active
    static Stop() {
        if (this.isActive) {
            this.ih.Stop()
            this.isActive := false
        }
    }
    
    ; Handle key down events
    static OnKeyDown(ih, vk, sc) {
        ; Only process if WoW window is active
        if (!WinActive("World of Warcraft") && !WinActive("ahk_exe Wow.exe"))
            return
            
        ; Convert virtual key code to key name
        key := GetKeyName(Format("vk{:x}", vk))
        
        ; Handle space presses
        if (key = "Space") {
            this.lastSpaceTime := A_TickCount
            this.CheckJumpCombination()
        }
        ; Handle direction key presses
        else if (HasValue(Config.DIR_KEYS, key)) {
            this.lastDirectionKey := key
        }
    }
    
    ; Handle key up events
    static OnKeyUp(ih, vk, sc) {
        key := GetKeyName(Format("vk{:x}", vk))
        ; Clear direction key when released
        if (key = this.lastDirectionKey)
            this.lastDirectionKey := ""
    }
    
    ; Check and execute jump combinations
    static CheckJumpCombination() {
        ; Check each direction key
        for key in Config.DIR_KEYS {
            if (GetKeyState(key, "P")) {
                JumpHandler.ExecuteJump(key)
                return
            }
        }
        ; If no direction key pressed, send normal space
        Send "{Space}"
    }
}

;===============================================================================
;                           JUMP HANDLING
;===============================================================================
; Handles execution of jumps and jump sequences
class JumpHandler {
    ; Execute a basic directional jump
    static ExecuteJump(directionKey, holdTime := 50) {
        SafeSend([directionKey], holdTime)
    }
    
    ; Execute a predefined jump sequence
    static ExecuteSequence(sequence) {
        ; Execute the main jump
        SafeSend([sequence.directionKey], sequence.holdTime)
        
        ; Handle post-jump actions if defined
        if (sequence.HasProp("postKey")) {
            if (sequence.HasProp("postDelay"))
                Sleep(sequence.postDelay)
            SafeSend([sequence.postKey])
        }
    }
}

;===============================================================================
;                           HOTKEY SETUP
;===============================================================================
; Only activate hotkeys when WoW window is active
#HotIf WinActive("World of Warcraft") || WinActive("ahk_exe Wow.exe")

; Register all sequence hotkeys from config
for sequence in Config.SEQUENCES {
    Hotkey sequence.trigger, JumpHandler.ExecuteSequence.Bind(sequence)
}

#HotIf

;===============================================================================
;                           SCRIPT CONTROLS
;===============================================================================
; Control hotkeys
<!Esc:: Reload              ; LAlt + Esc to reload
<!^Esc:: ExitApp           ; LAlt + Ctrl + Esc to exit

; Tray menu setup
A_TrayMenu.Delete
A_TrayMenu.Add("&Reload Script", (*) => Reload())
A_TrayMenu.Add("&Exit", (*) => ExitApp())

;===============================================================================
;                           INITIALIZATION
;===============================================================================
; Start key monitoring system
KeyMonitor.Init()