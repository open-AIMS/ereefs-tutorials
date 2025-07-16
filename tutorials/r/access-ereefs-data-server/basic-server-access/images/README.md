# Generation of the Animated GIF - thredds_navigation.gif

## Screen recording

Use the `kazam` tool, on Ubuntu.
It generated good quality MP4.

## Convertion from MP4 to GIF

Use `ffmpeg` to convert the MP4 into an animated GIF.

1. Make an optimised colour palette  
    `$ ffmpeg -i recording.mp4 -vf palettegen palette.png`

2. Find the video FPS  
    `$ ffprobe recording.mp4`  
    The video was recorded at 15 FPS:  
    `Stream #0:0[0x1](und): Video: h264 ... 952 kb/s, 15 fps, ...`

3. Generate the animated GIF using the colour palette, at half the FPS  
    `$ ffmpeg -i recording.mp4 -i palette.png -lavfi "fps=7.5,paletteuse=dither=none" thredds_navigation.gif`
