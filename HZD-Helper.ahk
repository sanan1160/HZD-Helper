
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#MaxThreadsPerHotkey 2
#MaxThreads 15

global this_item         := {name: ""        , pixel: "", x: "", y: "", loc: "" ,  avail: "", auto: "" }

global potion_150        := {name: "potion_150"        , pixel: "0xA6AAA6", x: "206", y: "958", loc: "1" ,  avail: "1", auto: "1" , err: "25"}
global potion_300        := {name: "potion_300"        , pixel: "0xCACFCA", x: "178", y: "955", loc: "3" ,  avail: "1", auto: "1" , err: "25"}
global potion_boost      := {name: "potion_boost"      , pixel: "0xE5BC69", x: "174", y: "991", loc: "4" ,  avail: "1", auto: "1" , err: "25"}
global call_beast        := {name: "call_beast"        , pixel: "0xF4F6F4", x: "187", y: "961", loc: "11",  avail: "1", auto: "1" , err: "25"}

global fire_resist       := {name: "fire_resist"       , pixel: "0xEEAE2C", x: "193", y: "997", loc: "5" ,  avail: "1", auto: "1" , err: "50"}
global shock_resist      := {name: "shock_resist"      , pixel: "0x2FA2DA", x: "186", y: "997", loc: "6" ,  avail: "1", auto: "1" , err: "50"}
global freeze_resist     := {name: "freeze_resist"     , pixel: "0x7CD6CB", x: "189", y: "994", loc: "7" ,  avail: "1", auto: "1" , err: "50"}
global corruption_resist := {name: "corruption_resist" , pixel: "0x40C949", x: "194", y: "998", loc: "8" ,  avail: "1", auto: "1" , err: "50"}

global detonating_trap   := {name: "detonating_trap"   , pixel: "0xF48B44", x: "200", y: "975", loc: "2" ,  avail: "1", auto: "0" , err: "25"}
global shock_trap        := {name: "shock_trap"        , pixel: "0x1F9FEF", x: "202", y: "984", loc: "9" ,  avail: "1", auto: "0" , err: "25"}
global fire_trap         := {name: "fire_trap"         , pixel: "0xEBC54C", x: "205", y: "984", loc: "10",  avail: "1", auto: "0" , err: "25"}
global lure_beast        := {name: "lure_beast"        , pixel: "0xF5F8F5", x: "187", y: "998", loc: "12",  avail: "1", auto: "1" , err: "25"}

global Tools := {  potion_150:potion_150
                  ,potion_300:potion_300
                  ,potion_boost:potion_boost
                  ,call_beast:call_beast

                  ,fire_resist:fire_resist
                  ,shock_resist:shock_resist
                  ,freeze_resist:freeze_resist
                  ,corruption_resist:corruption_resist

                  ,detonating_trap:detonating_trap
                  ,shock_trap:shock_trap
                  ,fire_trap:fire_trap
                  ,lure_beast:lure_beast }




;The color at 203 and 102  is 0xADADAD and it took 0 milliseconds 
;The color at 197 and 131  is 0xEC5974 and it took 31 milliseconds 

;The color at 246 and 103  is 0xF7F7F7 and it took 0 milliseconds 
;The color at 245 and 123  is 0x5FA5E8 and it took 0 milliseconds 

;The color at 290 and 104  is 0xF5F5F5 and it took 31 milliseconds 
;The color at 285 and 126  is 0xADF7F7 and it took 31 milliseconds 

;The color at 332 and 104  is 0xEEEEEE and it took 31 milliseconds 
;The color at 329 and 119  is 0xF0D75A and it took 31 milliseconds 

global corruption_pixel:= { pixel: "0xEC5974", x: "197", y: "131", status_pixel: "0xF5F5F5", status_pixel_x: "203", status_pixel_y:"103" }
global shock_pixel:=      { pixel: "0x5FA5E8", x: "245", y: "123", status_pixel: "0xF5F5F5", status_pixel_x: "246", status_pixel_y:"103" }
global freeze_pixel:=     { pixel: "0xADF7F7", x: "285", y: "126", status_pixel: "0xF5F5F5", status_pixel_x: "290", status_pixel_y:"103" }
global fire_pixel:=       { pixel: "0xF0D75A", x: "329", y: "119", status_pixel: "0xF5F5F5", status_pixel_x: "332", status_pixel_y:"103" }

global protect_from_corruption:=false
global protect_from_shock:=false
global protect_from_freezing:=false
global protect_from_fire:=false

global in_combat:=false

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

global auto_timer:=0
global auto_last:=0

global script_active:=true
global dodging:=false
global firing_bow:=false
global extra_arrows:=true

global last_time:=A_TickCount
global elapsed_time:=0

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
;----------------------------------------Modifier keys-------------------------

Insert::
   protect_from_shock:=true
   auto_last:=0
return


Delete::
   protect_from_shock:=false   
   return

Home::
  protect_from_freezing:=true
  auto_last:=0
  return




End::
  protect_from_freezing:=false
  return



PgUp::
   
   protect_from_fire:=true
   auto_last:=0
   return



PgDn::
   protect_from_fire:=false
   return



;----------------------------------------Function Keys to Tools----------------

F1:: ;Potion150
this_item:=potion_150
counter:=0

return

F2:: ;Potion300
this_item:=potion_300
counter:=0

return

F3:: ;PotionBoost
this_item:=potion_boost
counter:=0

return

F4:: ;Call_Beast
this_item:=call_beast
counter:=0

return

F5:: ;Fire_Resist
this_item:=fire_resist
counter:=0

return

F6:: ;Shock_Resist
this_item:=shock_resist
counter:=0

return

F7:: ;Freeze_Resist
this_item:=freeze_resist
counter:=0

return

F8:: ;Corruption_Resist
this_item:=corruption_resist
counter:=0

return

F9:: ;Detonating_Trap
this_item:=detonating_trap
counter:=0

return

F10:: ;Shock_Trap
this_item:=shock_trap
counter:=0

return

F11:: ;Fire_Trap
this_item:=fire_trap
counter:=0

return

F12:: ;Lure_Beast
this_item:=lure_beast
counter:=0

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
this_item:=potion_150
return


x:: 
this_item:=potion_300

return


c::
this_item:=potion_boost

return

v::
this_item:=call_beast

return

y::
reset_tools()

return


;----------------------------------------Special Mouse Buttons----------------

MButton::
scripted_bow() 

return

WheelLeft::
this_item:=detonating_trap

return

WheelRight:
this_item:=shock_trap

return


$WheelDown::
if (wheel_mode)
  this_item:=lure_beast
else {
  Send {WheelDown}
} 
return

$WheelUp::
if (wheel_mode)
  this_item:=fire_trap
else {
  Send {WheelUp}
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


Check_pixel(xcoord, ycoord, colormatch, vary) {

    c1 := ToRGB(colormatch)

    

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

autoresist_shock() {
  if (!this_item.name)  
    if (!Check_Pixel(shock_pixel.x, shock_pixel.y, shock_pixel.pixel, 25))
      if (!Check_Pixel(shock_pixel.status_pixel_x, shock_pixel.status_pixel_y, shock_pixel.status_pixel,25)) {    
              this_item:=shock_resist
              counter:=0
     }
}

autoresist_freezing() {
  if (!this_item.name)  
    if (!Check_Pixel(freeze_pixel.x, freeze_pixel.y, freeze_pixel.pixel, 25))
      if (!Check_Pixel(freeze_pixel.status_pixel_x, freeze_pixel.status_pixel_y, freeze_pixel.status_pixel,25)) {      
              this_item:=freeze_resist
              counter:=0
      }
}

autoresist_fire() {
  if (!this_item.name)  
    if (!Check_Pixel(fire_pixel.x, fire_pixel.y, fire_pixel.pixel, 25))
      if (!Check_Pixel(fire_pixel.status_pixel_x, fire_pixel.status_pixel_y, fire_pixel.status_pixel,25)) {
              this_item:=fire_resist
              counter:=0
      }
}


;----------------------------------------Combat Loop---------------------------------


combat_loop() {
   if (in_combat)
      return

   in_combat:=true
   SoundPlay, Sounds/ScriptActive.mp3,1

   loop {
  
       if (!script_active) {
          SoundPlay, Sounds/ScriptDisabled.mp3,1
          break
       } 
       
       if (!action_screen())  { ; just jump to end of loop if we are in a menu screen
         auto_last:=A_TickCount ; but refresh the auto timer so automatic tools will not suddenly get activated
         continue
       }
       

       elapsed_time:=A_TickCount -  last_time

       auto_timer:=A_TickCount - auto_last

       if (auto_timer>=500) { ; prevent from launching the automated tools until the screen has had a chance to refresh. 
         if (protect_from_shock)
             autoresist_shock()
         if (protect_from_freezing)
             autoresist_freezing()
         if (protect_from_fire)
             autoresist_fire()
       }


       if (counter>13) { ; did not find the item
            
            counter:=0
            SoundPlay, *16
            this_item.avail:=0
            this_item:=""
       } 
       
     
        if (this_item.avail) { 
         
       
         if (elapsed_time>=shift_time) {
           
           if (Check_pixel(this_item.x, this_item.y, this_item.pixel, this_item.err)) {
           
              last_time:=A_TickCount

              last_location:=this_item.loc
              SoundPlay, *48
              counter:=0

              if (this_item.auto) {
                  Send {f down}
                  Sleep, keywaittime
                  Send {f up}
                  auto_last:=A_TickCount
              }
             
              
              this_item:=""
             

           } else  {
                  
                    shift_tools()
              
              
           } ; check_pixel

          

          } ; shift time
        } ; item.avail



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


      } ; loop
       
      in_combat:=false
}

;----------------------------------------Helper Functions---------------------------------

reset_tools() {
  for key, value in Tools {
      value.avail:=1
   } ; for
}



action_screen() {

  ;The color at 189 and 923  is 0xACEAC0 and it took 0 milliseconds 
  if (Check_pixel(189, 923, 0xACEAC0, 25)) { ; Plus sign detected
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
        counter++
        last_time:=A_TickCount
    } else {
        Send {[ down}
        Sleep, keywaittime
        Send {[ up}
        counter++ 
        last_time:=A_TickCount
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



