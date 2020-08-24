# Short desciption of the design philosophy & first steps

The code is written in segments (usually called "snippets" in the code). Each snippet contains the APDL instructions necessary to perform one modular step. The step can be e.g. providing material data, providing element technology instructions, or providing the meshing instructions.

In this way, the repository tries to strike a balance between manually making changes in a sample file (slow learning rate) and allowing the user to replace absolutely everything via e.g. **strrep()** in MATLAB.

In the repository there are a number of folders, and typically each folder contains different versions of the same module. In this way, you can swap one out without altering anything else. If the thing you are trying to model is not represented by any of the different versions, it is quite easy to make your own by simply following the skeleton provided.

About half of the snippets are obligatory (a choice must be made) and the rest are optional (if you don't specify any of them, then the program just exits once it reaches that point). The optional segments tend to relate to snippets added at the end of the program, where you may wish to add more load cases. 