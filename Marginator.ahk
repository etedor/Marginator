; When Win+Shift+Up is pressed, resize the active window to be 75% of the screen width
; and centre it. Useful for widescreen resolutions >= 1080p, but uses the resolution
; of the primary monitor.

#+Up::

SysGet, BoundingCoordinates, MonitorWorkArea

ResolutionWidth := BoundingCoordinatesRight - BoundingCoordinatesLeft
ResolutionHeight := BoundingCoordinatesBottom - BoundingCoordinatesTop

AdjustedWidth := 0.75 * ResolutionWidth
LeftMargin := 0.125 * ResolutionWidth

WinMove A, , LeftMargin, 0, AdjustedWidth, ResolutionHeight
return

; When Win+Shift+C is pressed, move the active window to the centre of the screen.

#+c::

SysGet, BoundingCoordinates, MonitorWorkArea

ResolutionWidth := BoundingCoordinatesRight - BoundingCoordinatesLeft
ResolutionHeight := BoundingCoordinatesBottom - BoundingCoordinatesTop

WinGetPos, , , ActiveWidth, ActiveHeight, A

HorizontalMargin := (ResolutionWidth - ActiveWidth) / 2
VerticalMargin := (ResolutionHeight - ActiveHeight) / 2

WinMove A, , HorizontalMargin, VerticalMargin