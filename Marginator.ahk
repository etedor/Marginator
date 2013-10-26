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