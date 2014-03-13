; When Win+Shift+Up is pressed, resize the active window to be 75% of the screen width
; and centre it on the screen. Useful for widescreen resolutions >= 1080p.

#+Up::

ActiveWindowHandle := WinExist("A")
MonitorIndex := GetMonitorIndexFromWindow(ActiveWindowHandle)

SysGet, BoundingCoordinates, MonitorWorkArea, %MonitorIndex%

ResolutionWidth := BoundingCoordinatesRight - BoundingCoordinatesLeft
ResolutionHeight := BoundingCoordinatesBottom - BoundingCoordinatesTop

AdjustedWidth := 0.75 * ResolutionWidth
LeftMargin := 0.125 * ResolutionWidth + BoundingCoordinatesLeft

WinMove A, , LeftMargin, BoundingCoordinatesTop, AdjustedWidth, ResolutionHeight
return

; When Win+Shift+C is pressed, move the active window to the centre of the screen it's on.

#+c::

ActiveWindowHandle := WinExist("A")
MonitorIndex := GetMonitorIndexFromWindow(ActiveWindowHandle)

SysGet, BoundingCoordinates, MonitorWorkArea, %MonitorIndex%

ResolutionWidth := BoundingCoordinatesRight - BoundingCoordinatesLeft
if BoundingCoordinatesTop < 0
{
  ResolutionHeight := BoundingCoordinatesBottom + BoundingCoordinatesTop
}
else
{
  ResolutionHeight := BoundingCoordinatesBottom - BoundingCoordinatesTop
}

WinGetPos, , , ActiveWidth, ActiveHeight, A

HorizontalMargin := (ResolutionWidth - ActiveWidth) / 2 + BoundingCoordinatesLeft
VerticalMargin := (ResolutionHeight - ActiveHeight) / 2 + BoundingCoordinatesTop

WinMove A, , HorizontalMargin, VerticalMargin
return

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
