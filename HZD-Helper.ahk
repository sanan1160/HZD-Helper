
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#MaxThreadsPerHotkey 2
#MaxThreads 15

#Include FindText.ahk

; Pictures

Escape_thumb:="|<>**50$28.00000zU007z0E0TQ3U1k04070DVsQ1zDkzjvz3ysC0Q3ws3kDzU701a2Q03s9zzxz7zzXwCNw7U0040000000000000008"


global wheel_mode:=true

global interrupted_w:=false
global interrupted_s:=false
global interrupted_a:=false
global interrupted_d:=false

global keywaittime:=50
global doubleclicktime:=300
global bow_wait:=1500
global shift_time:=250
global reload_time:=150

global script_active:=true
global dodging:=false
global firing_bow:=false
global extra_arrows:=true

global last_time:=A_TickCount
global elapsed_time:=0

global this_item:=0
global this_x:=0
global this_y:=0
global this_location:=0
global last_location:=0
global counter:=0
global immediate_use:=false

global textentry:=false



combat_loop()

return

;--------------AUTOEXEC STOPS HERE---------------------------------------------

Pause::
pause_script()

return





#if (!textentry) ; Conditional hotkey activation
;----------------------------------------Function Keys to Tools----------------

F1:: ;Potion150
potion_150()

return

F2:: ;Potion300
potion_300()

return

F3:: ;PotionBoost
potion_boost()

return

F4:: ;Call_Beast
call_beast()

return


F5:: ;Fire_Resist
fire_resist()


return

F6:: ;Shock_Resist
shock_resist()

return

F7:: ;Freeze_Resist
freeze_resist()

return

F8:: ;Corruption_Resist
corruption_resist()

return


F9:: ;Detonating_Trap
detonating_trap()
return

F10:: ;Shock_Trap
shock_trap()

return

F11:: ;Fire_Trap
fire_trap()

return

F12:: ;Lure_Beast
lure_beast()

return

;----------------------------------------Number keys to delay----------------

~1::
bow_wait:=1500
return

~2::
bow_wait:=1500
return

~3::
bow_wait:=2000
return

~4::
bow_wait:=1500
return

;----------------------------------------Dodge overrides----------------------
~w::
dodge_forward()

return

~s::
dodge_backward()

return

~a::
dodge_left()

return

~d::
dodge_right()

return

;----------------------------------------Shortcuts to Health Potions----------------

z::
potion_150()
return


x:: 
potion_300()

return


c::
potion_boost()

return

v::
call_beast()

return

;~m:: ; allow mousewheel in maps
;wheel_mode:=false

;return

~Esc::
wheel_mode:=true

return

;----------------------------------------Special Mouse Buttons----------------

MButton::
scripted_bow() 

return

WheelLeft::
detonating_trap()

return

WheelRight:
shock_trap()

return


$WheelDown::
if (wheel_mode)
  lure_beast()
else {
  Send {WheelDown}
  ;Sleep, keywaittime
  ;Send {WheelDown up}
} 
return

$WheelUp::
if (wheel_mode)
  fire_trap()
else {
  Send {WheelUp}
  ;Sleep, keywaittime
  ;Send {WheelUp up}
} 
return


CapsLock:: 
if (action_screen())
  SoundPlay, Sounds/1.mp3,1
else
  SoundPlay, Sounds/2.mp3,1
return

;--------------------------------------------------------------------------
#if  ; Conditional hotkey activation ends
;--------------------------------------------------------------------------

;----------------------------------------Utility Functions----------------

ToRGB(color) {
    return { "r": (color >> 16) & 0xFF, "g": (color >> 8) & 0xFF, "b": color & 0xFF }
}


Check_pixel(xcoord, ycoord, colormatch) {

    c1 := ToRGB(colormatch)

    vary:=25

    PixelGetColor, color, %xcoord%, %ycoord%, RGB 
    c2 := ToRGB(color)

    rdiff := Abs( c1.r - c2.r )
    gdiff := Abs( c1.g - c2.g )
    bdiff := Abs( c1.b - c2.b )

    ;FileAppend, %color% - %rdiff% - %gdiff% - %bdiff% `n, Test2.txt

    if ( rdiff <= vary && gdiff <= vary && bdiff <= vary) {
       return true 

    } else
       return false
}

;----------------------------------------Scripted Combat Functions----------------

scripted_bow() {
    if (firing_bow) { 
       ; fire if we press this again
       fired_already:=true
       return 
    }

    firing_bow:=true
    fired_already:=false

    SoundPlay, *-1

    
    Click, Right Down
   

    if (extra_arrows) {
        
        
        Send {r down}
        Sleep, keywaittime
        Send {r up}
        Sleep, reload_time

        Send {r down}
        Sleep, keywaittime
        Send {r up}
        Sleep, reload_time

        Send {r down}
        Sleep, keywaittime
        Send {r up}
        Sleep, reload_time
        
        
        
      }

    Click, Left Down

   ot1:=A_TickCount
   t_elapsed:=0

   loop {
      Sleep, 100

      
      
      t_elapsed:=A_TickCount-ot1
      if (t_elapsed>bow_wait) {       
         break
      }

      GetKeyState, state, LButton, P
      if (state = "D") {        
              break
      }

      if (fired_already)
             break
   
    }

    Click, Left Up
    Sleep, 100
    Click, Right Up

    firing_bow:=false
    

}


;----------------------------------------Double tap to Dodge----------------

    
dodge_forward() {
    
    If (A_ThisHotkey = A_PriorHotkey)   {
      ;SoundPlay, Sounds/1.mp3
      if (A_TimeSincePriorHotkey < doubleclicktime) {
        if (interrupted_w)
            dodge()
        
      }
        
    }
 
interrupted_w:=false
}



    
dodge_backward() {
    
    If (A_ThisHotkey = A_PriorHotkey)   {
      ;SoundPlay, Sounds/1.mp3
      if (A_TimeSincePriorHotkey < doubleclicktime) {
        if (interrupted_s)
            dodge()
        
      }
        
    }
 
interrupted_s:=false
}



    
dodge_left() {
    
    If (A_ThisHotkey = A_PriorHotkey)   {
      ;SoundPlay, Sounds/1.mp3
      if (A_TimeSincePriorHotkey < doubleclicktime) {
        if (interrupted_a)
            dodge()
        
      }
        
    }
 
interrupted_a:=false
}


    
dodge_right() {
    
    If (A_ThisHotkey = A_PriorHotkey)   {
      ;SoundPlay, Sounds/1.mp3
      if (A_TimeSincePriorHotkey < doubleclicktime) {
        if (interrupted_d)
             dodge()
      }
        
    }
 
interrupted_d:=false
}

;----------------------------------------Tools Functions-----------------------------


potion_150() {
  this_item:=0xA6AAA6
  this_x:=206
  this_y:=958
  this_location:=1
  immediate_use:=true
}

potion_300() {
  this_item:=0xCACFCA
  this_x:=178
  this_y:=955
  this_location:=3
  immediate_use:=true
}

potion_boost() {
  this_item:=0xE5BC69
  this_x:=174
  this_y:=991
  this_location:=4
  immediate_use:=true
}

call_beast() {
  this_item:=0xF4F6F4
  this_x:=187
  this_y:=961
  this_location:=11
  immediate_use:=true
}

fire_resist() {
  this_item:=0xEEAE2C
  this_x:=193
  this_y:=997
  this_location:=5
  immediate_use:=true
}


shock_resist() {
  this_item:=0x2FA2DA
  this_x:=186
  this_y:=997
  this_location:=6
  immediate_use:=true
}


freeze_resist() {
  this_item:=0x7CD6CB
  this_x:=189
  this_y:=994
  this_location:=7
  immediate_use:=true
}

corruption_resist() {
  this_item:=0x40C949
  this_x:=194
  this_y:=998
  this_location:=8
  immediate_use:=true
}

detonating_trap() {
  this_item:=0xF48B44
  this_x:=200
  this_y:=975
  this_location:=2
  immediate_use:=false
}

shock_trap() {
  this_item:=0x1F9FEF
  this_x:=202
  this_y:=984
  this_location:=9 
  immediate_use:=false
}

fire_trap() {
  this_item:=0xEBC54C
  this_x:=205
  this_y:=984
  this_location:=10  
  immediate_use:=false
}

lure_beast() {
  this_item:=0xF5F8F5
  this_x:=187
  this_y:=998
  this_location:=12 
  immediate_use:=true 
}


;----------------------------------------Combat Loop---------------------------------


combat_loop() {
   SoundPlay, Sounds/ScriptActive.mp3,1

   loop {
  
       

       if (!script_active) {
          SoundPlay, Sounds/ScriptDisabled.mp3,1
          break
       } 
       
       if (!action_screen()) ; just jump to end of loop if we are in a menu screen
          continue

       GetKeyState, state, w, P
          if (state = "U")
             interrupted_w:=true

       GetKeyState, state, s, P
          if (state = "U")
             interrupted_s:=true

       GetKeyState, state, a, P
          if (state = "U")
             interrupted_a:=true

       GetKeyState, state, d, P
          if (state = "U")
             interrupted_d:=true

       elapsed_time:=A_TickCount -  last_time

       if (counter>13) { ; did not find the item
            this_item:=0
            counter:=0
            SoundPlay, *16
       }
       
       if (this_item) {
         
         
         if (last_time)
           elapsed_time:=A_TickCount -  last_time
         else
           elapsed_time:=shift_time

         if (elapsed_time>=shift_time)
           
           if (Check_pixel(this_x, this_y, this_item)) {
              this_item:=0
              last_time:=0
              last_location:=this_location
              SoundPlay, *48
              counter:=0
              if (immediate_use) {
                  Send {f down}
                  Sleep, keywaittime
                  Send {f up}
              }
           } else {
              shift_tools()
              counter++
              last_time:=A_TickCount
           } 
        }
       }
}

;----------------------------------------Helper Functions---------------------------------


action_screen() {

  ;The color at 189 and 923  is 0xACEAC0 and it took 0 milliseconds 
  if (Check_pixel(189, 923, 0xACEAC0)) { ; Plus sign detected
      wheel_mode:=true
  } else {                               ; Probably in a menu screen
      wheel_mode:=false
  }
 
  
  return wheel_mode 
}

shift_tools() {
    direction:=0 ; left

    if (last_location>this_location)        ;  T . <- . L
       direction:=0
    else if (this_location>last_location)   ;  L . -> . T
       direction:=1 

    magnitude:=abs(last_location-this_location)
    if (magnitude>6)
       direction:=!direction

    if (direction) {
        Send {] down}
        Sleep, keywaittime
        Send {] up} 
    } else {
        Send {[ down}
        Sleep, keywaittime
        Send {[ up} 
    }

}

dodge() {
    if (dodging)
       return

    dodging:=true
    Send {/ down}
    Sleep, keywaittime
    Send {/ up} 
    dodging:=false
}

pause_script()
{
   script_active:=!script_active
   if (script_active) {
      SoundPlay, Sounds/ScriptActive.mp3
      textentry:=false
      combat_loop()

   }
   else ; not script_active
   {
      
      textentry:=true
      SoundPlay, Sounds/ScriptDisabled.mp3
   }
}



