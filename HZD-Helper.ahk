
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#MaxThreadsPerHotkey 2
#MaxThreads 15

#Include FindText.ahk



global interrupted_w:=false
global interrupted_s:=false
global interrupted_a:=false
global interrupted_d:=false

global keywaittime:=50
global doubleclicktime:=300
global bow_wait:=1500
global shift_time:=250
global reload_time:=150

global stop_loop:=false
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


global errt:=0.3
global errb:=0.3


combat_loop()

return
;--------------AUTOEXEC STOPS HERE---------------------------------------------


F1:: ;Potion150
this_item:=0xA6AAA6
this_x:=206
this_y:=958
this_location:=1

return

F2:: ;Potion300
this_item:=0xCACFCA
this_x:=178
this_y:=955
this_location:=3

return

F3:: ;PotionBoost
this_item:=0xE5BC69
this_x:=174
this_y:=991
this_location:=4

return

F4:: ;Call_Beast
this_item:=0xF4F6F4
this_x:=187
this_y:=961
this_location:=11

return


F5:: ;Fire_Resist
this_item:=0xEEAE2C
this_x:=193
this_y:=997
this_location:=5


return

F6:: ;Shock_Resist
this_item:=0x2FA2DA
this_x:=186
this_y:=997
this_location:=6

return

F7:: ;Freeze_Resist
this_item:=0x7CD6CB
this_x:=189
this_y:=994
this_location:=7

return

F8:: ;Corruption_Resist
this_item:=0x40C949
this_x:=194
this_y:=998
this_location:=8

return


F9:: ;Detonating_Trap
this_item:=0xF48B44
this_x:=200
this_y:=975
this_location:=2

return

F10:: ;Shock_Trap
this_item:=0x1F9FEF
this_x:=202
this_y:=984
this_location:=9 

return

F11:: ;Fire_Trap
this_item:=0xEBC54C
this_x:=205
this_y:=984
this_location:=10  

return

F12:: ;Lure_Beast
this_item:=0xF5F8F5
this_x:=187
this_y:=998
this_location:=12  

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


MButton::

scripted_bow() 


return


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

scripted_bow() {
    if (firing_bow) { 
       Click, Left Up ; fire if we press this again
       fired_already:=true
       return 
    }

    firing_bow:=true
    fired_already:=false

    SoundPlay, *-1

    
    Click, Right Down
    ;Sleep, 200

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

~w::     

    
    If (A_ThisHotkey = A_PriorHotkey)   {
      ;SoundPlay, Sounds/1.mp3
      if (A_TimeSincePriorHotkey < doubleclicktime) {
        if (interrupted_w)
            dodge()
        
      }
        
    }
 
interrupted_w:=false

return

~s::     

    
    If (A_ThisHotkey = A_PriorHotkey)   {
      ;SoundPlay, Sounds/1.mp3
      if (A_TimeSincePriorHotkey < doubleclicktime) {
        if (interrupted_s)
            dodge()
        
      }
        
    }
 
interrupted_s:=false

return


~a::     

    
    If (A_ThisHotkey = A_PriorHotkey)   {
      ;SoundPlay, Sounds/1.mp3
      if (A_TimeSincePriorHotkey < doubleclicktime) {
        if (interrupted_a)
            dodge()
        
      }
        
    }
 
interrupted_a:=false

return

~d::    

    
    If (A_ThisHotkey = A_PriorHotkey)   {
      ;SoundPlay, Sounds/1.mp3
      if (A_TimeSincePriorHotkey < doubleclicktime) {
        if (interrupted_d)
             dodge()
      }
        
    }
 
interrupted_d:=false

return

z::
stop_loop:=false
combat_loop()
return


x:: 
stop_loop:=true

return

combat_loop() {
   SoundPlay, Sounds/ScriptActive.mp3,1

   loop {
  
       if (stop_loop) {
          SoundPlay, Sounds/ScriptDisabled.mp3,1
          break
       } 
       
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

       if (counter>13)
            this_item:=0
       
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
              SoundPlay, *16
              counter:=0
              ;Send {f down}
              ;Sleep, keywaittime
              ;Send {f up}

           } else {
              shift_tools()
              counter++
              last_time:=A_TickCount
           } 
        }
       }
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
    Sleep, 50
    Send {] up} 
} else {
    Send {[ down}
    Sleep, 50
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





;The color at 156 and 950  is 0x1A1D22 and it took 31 milliseconds 
;The color at 226 and 1003  is 0x25282F and it took 31 milliseconds 

Thumb_Ready(Byref item, epic, ebac) {  ; 
  ;Thumbnail detection
  
  result:=false
  
  thumb:=item
  
         xul:=156
         yul:=950
         xlr:=226
         ylr:=1003

         
         Outx:=""
         Outy:=""
         resultObj:=FindText(Outx,Outy,xul,yul,xlr,ylr,epic,ebac,thumb,1,0)
         if ((resultObj[1].1>xul) && (resultObj[1].1<xlr) && (resultObj[1].2>yul) && (resultObj[1].2<ylr)) {
          
           return true
         } else {
          
           return false

         }
        


      
  
}


