# another 
MAKE commands:<br>
`make` - performs `check` and `install` if successful<br>
`make check` - performs a luacheck only<br>
`make install` - copies to attached android device<br>
`make local` - checks and runs a local mirror of the game<br>
`make clean` - deletes log and android files<br>
<br>
## models
-From e.g. MakeHuman, set scale to Meters.<br>
<br>
-From blender, decimate until <5k tris. <br>
<br>
-Export as OBJ:<br>
 [ ]Selection only (optional)<br>
 [x]Objects as OBJ objects<br>
 [x]Objects as OBJ groups<br>
 [x]Material groups<br>
 [ ]Animation<br>
 Scale: 1.0<br>
 Path Mode: Copy (<- IMPORTANT)<br>
 Forward: -Z<br>
 Up: Y<br>
 [x]Apply modifiers<br>
 [x]Smooth groups<br>
 [ ]Bitflag smooth groups<br>
 [x]Write normals<br>
 [x]Include UVs<br>
 [x]Write Materials<br>
 [x]Triangulate Faces<br>
 [ ]Curves as NURBS<br>
 [ ]Keep Vertex Order<br>
