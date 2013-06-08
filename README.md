Olympus
=======
This is a graphics engine developed by four Oregon State University Students in Computer Science. 
Made for our senior design project, this uses the most recent versions of DirectX and PhysX.

Demo Reel:
Bowling Demo      - http://www.youtube.com/watch?v=ng5tQVGfeWc
Jenga Demo    		- http://www.youtube.com/watch?v=2yxbq8L0V14
Point Light Demo 	- http://www.youtube.com/watch?v=W9oUBBAQ8_Y

Note:
Requires a Windows machine, and preferably a discrete graphics card (DirectX 11 Compatible).

To run:
1. Download Repo
2. Delete rainEmitter.apb and RainEmitter.apb (if they exist)
3. Compile
4. If error appears copy the Apex and PhysX DLL's out from Olympus/Olympus  and into Olympus/Released or Olympus/Checked
5. Copy Olympus/Released/Olympus.exe to Olympus/Olympus/Olympus.exe to run

Controls:

(Controller)
L Stick - Movement
R Stick - Aim
Push L Stick - Turbo
Left Trigger - Zoom (+Slow movement)
Right Trigger - Fire Blocks
A - Jump
B - Reset Bowling Lane, Jenga Tower and Projectiles

(Keyboard)
WASD - Movement
LShift - Turbo
Click and drag - Aim
B - Fire Blocks
C - Cascade Shadow Maps
Spacebar - Jump
T - Reset Bowling Lane, Jenga Tower and Projectiles
0 - Switch to scene 0 (Hub Scene)
1 - Switch to scene 1 (Bowling Lane)
2 - Switch to scene 2 (Darkness)
3 - Switch to scene 3 (Jenga Tower)
4 - Switch to scene 4 (Forest Scene)
F1 - Toggle Textures
F2 - Toggle Normal Maps
F3 - Toggle Shadows
F4 - Toggle Emitters
F5 - Toggle Ambient Lighting
F6 - Toggle Diffuse Lighting
F7 - Toggle Specular Lighting
F8 - Toggle Point Lights
F9 - Toggle Directional Lights

(Numpad)
7 - Up luminance
4 - Down Luminance
8 - Up Gamma
5 - Down Gamma
9 - Up DoF Blur
6 - Down DoF Blur

Features:
Render to screen quad for post processing:
Depth of field
Gamma and Luminance correction
Skybox
Apex Particles
FBX Loader
Box Shooter
Dynamic Environment mapping
Scene Switching
Bowling Lanes
Jenga Towers


To get visual studio version working:
1. Move all dlls in the main folder into the sln's Checked/Release folder.
