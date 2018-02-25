; Restore the active window to allow it to be resized.
restoreWindow()
{
  ActiveWindowHandle := WinExist("A")

  WinRestore A
}

; Resize the active window to be %scale% of the screen width and height and center it on the screen.
resizeWindow(scale)
{
  ActiveWindowHandle := WinExist("A")
  MonitorIndex := GetMonitorIndexFromWindow(ActiveWindowHandle)

  SysGet, BoundingCoordinates, MonitorWorkArea, %MonitorIndex%

  ResolutionWidth := BoundingCoordinatesRight - BoundingCoordinatesLeft
  ResolutionHeight := BoundingCoordinatesBottom - BoundingCoordinatesTop

  AdjustedWidth := scale * ResolutionWidth
  LeftMargin := 0.125 * ResolutionWidth + BoundingCoordinatesLeft
  
  AdjustedHeight := scale * ResolutionHeight
  TopMargin := 0.125 * ResolutionHeight + BoundingCoordinatesTop

  WinMove A, , LeftMargin, TopMargin, AdjustedWidth, AdjustedHeight

  return
}

; Move the active window to the center of the screen it's on.
moveWindow()
{
  ActiveWindowHandle := WinExist("A")
  MonitorIndex := GetMonitorIndexFromWindow(ActiveWindowHandle)

  SysGet, BoundingCoordinates, MonitorWorkArea, %MonitorIndex%

  ResolutionWidth := BoundingCoordinatesRight - BoundingCoordinatesLeft
  ResolutionHeight := BoundingCoordinatesBottom - BoundingCoordinatesTop

  WinGetPos, , , ActiveWidth, ActiveHeight, A

  HorizontalMargin := (ResolutionWidth - ActiveWidth) / 2 + BoundingCoordinatesLeft
  VerticalMargin := (ResolutionHeight - ActiveHeight) / 2 + BoundingCoordinatesTop

  WinMove A, , HorizontalMargin, VerticalMargin

  return
}

; From http://www.autohotkey.com/board/topic/69464-how-to-determine-a-window-is-in-which-monitor/
GetMonitorIndexFromWindow(windowHandle)
{
  ; Starts with 1.
  monitorIndex := 1

  VarSetCapacity(monitorInfo, 40)
  NumPut(40, monitorInfo)
  
  if (monitorHandle := DllCall("MonitorFromWindow", "uint", windowHandle, "uint", 0x2)) 
    && DllCall("GetMonitorInfo", "uint", monitorHandle, "uint", &monitorInfo) 
  {
    monitorLeft   := NumGet(monitorInfo,  4, "Int")
    monitorTop    := NumGet(monitorInfo,  8, "Int")
    monitorRight  := NumGet(monitorInfo, 12, "Int")
    monitorBottom := NumGet(monitorInfo, 16, "Int")
    workLeft      := NumGet(monitorInfo, 20, "Int")
    workTop       := NumGet(monitorInfo, 24, "Int")
    workRight     := NumGet(monitorInfo, 28, "Int")
    workBottom    := NumGet(monitorInfo, 32, "Int")
    isPrimary     := NumGet(monitorInfo, 36, "Int") & 1

    SysGet, monitorCount, MonitorCount

    Loop, %monitorCount%
    {
      SysGet, tempMon, Monitor, %A_Index%

      ; Compare location to determine the monitor index.
      if ((monitorLeft = tempMonLeft) and (monitorTop = tempMonTop)
        and (monitorRight = tempMonRight) and (monitorBottom = tempMonBottom))
      {
        monitorIndex := A_Index
        break
      }
    }
  }
  
  return monitorIndex
}

; Ctrl+Alt+C
; Restores the window.
; Scales the active window to 85% of the screen's width and height.
; Centers the window on the window's current screen.
^!c::
{
 scale:=0.85
 
 restoreWindow()
 resizeWindow(scale)
 moveWindow()

 return
}

; Ctrl+Alt+Shift+C
; Restores the window.
; Scales the active window to 50% of the screen's width and height.
; Centers the window on the window's current screen.
^!+c::
{
 scale:=0.50
 
 restoreWindow()
 resizeWindow(scale)
 moveWindow()

 return
}

return
