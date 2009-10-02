Lua Engine Arranged by h5nc (Leah)
http://www.h5nc.cn
h5nc@yahoo.com.cn

Leah is a lua port to modified HGE. Leah covers all functions in HGE and some of its helpers. HGE (Haaf's Game Engine) is originally an open source 2D game engine. For HGE's information, visit http://hge.relishgames.com. Leah uses a HGE which is modified by h5nc. Leah uses LuaPlus to access lua with C++.

The changes in HGE are marked in each file. Some of changes are marked briefly. That is usually because there are too many similar ones about the following main changes:
1, Changes to DirectX 9
2, Changes to a higher version of zlib
3, Changes to a higher version of BASS.

Besides, Leah makes the following changes to HGE and its helpers:
1, Direct Input for keyboard and joystick
2, D3DXFont and functions to use multi-language characters
3, Very accurate FPS
4, Changes in Vertex Struct to serve both ortho and perspective world matrix
5, Non-Stop loop stream
6, Complete different Effect System composed with Emitters and Affectors
7, Built-in pack and unpack functions
8, Additional 0.5 texture offset.

Some of HGE's original parts are deleted or commented:
1, Codes about HGE_SHOWSPLASH
2, Codes about Music.

There are also some changes with lua and LuaPlus:
1, Changes to get detail messages of lua syntax errors.
2, Changes to compile lua scripts (not complete).

There is two extra tools:
1, EffectSystemEditor: See EffectSystemEditorDocumentation.htm
2, ResourcePack: A tool to pack your resources.

See license.txt license_hge.txt and license_luaplus.txt for licensing information.
A sample game is provided in LuaEngine folder.

Welcome to share your questions, suggestions and bug reports by contacting h5nc.
