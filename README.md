# viewVSrenderer

Demo iOS application to compare performance of Mapkit's MKOverlayView VS MKOverlayRenderer.

Prior to iOS7, MKOverlayViews were the standard method to display overlays on a mapview. With the introduction of iOS7, MKOverlayView has been deprecated in favour of MKOverlayRenderer.

==============
This demo app shows the tiling-based performance issues when using MKOverlayRender, in particular when allowing the user to interact with & manipulate the underlying MKOverlay instance.

1. A pan gesture is attached to the map view, and a MKCircle is added to the map view.
2. Panning with a single finger will increase/reduce the size of the MKCircle’s radius, removing the old overlay & adding a new one as the distance from the MKCircle’s center.
3. Tapping the button will toggle between displaying the overlay with a MKOverlayView and with a MKOverlayRenderer.

# Results
Panning quickly/scrubbing when using the MKOverlayRender has noticeable tiling-based redrawing issues. Manipulating the layer-backed MKOverlayView has noticeably better performance, particularly at large zoom levels.
