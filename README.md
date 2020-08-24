# pulpFiberModel
The pulpFiberModel repository contains basic building blocks (snippets) for ANSYS APDL code that can be used to construct a FEM model of a single or a few (typically two) fibers and then subject them to various loads. The code is written with modularity in mind, the idea being that a user should focus on the section of the code that they want to change rather than scrolling up and down a long file of instructions.

## What is this repository for?
The code in this repository was created to double check results obtained using a seperate method in LS-Dyna by me, August Brandberg. I then used the code to perform structured queries (using a wrapper not included in this repository) to sample the response of the model and beam representations of the fiber network.

Now, the code is provided here for anyone looking to write their own FEM model of a single fiber who wishes to "compare notes". 

The code in this repository is a scrubbed version of a private repository, so I advice anyone working with it to remain deeply sceptical in the face of any results that "seem wrong". Maybe they are!

## How do I get set up?
1. Make sure you have an ANSYS distribution installed. The code is not version sensitive but was developed using ANSYS 18.2.

2. Make sure you have a MATLAB distribution installed. The code is not version sensitive but was developed using MATLAB 2017b.

3. Clone this repository somewhere. If you want to generate and execute models, this should ideally be at least a workstation. If you don't have a workstation, you can still clone the repository and generate the model. However, actually solving the model will probably be quite slow (on the order of hours). A good compromise is to generate the code locally, but execute it on a remote cluster. 

## Where can I read more about the equations implemented?
There is nothing particularly difficult in the repository that requires understanding.  It is all standard ANSYS code. If you are interested in the modeling choices made, you may start by reading the following two papers

    Borodulina, S., Kulachenko, A., & Tjahjanto, D. D. (2015). 
    Constitutive modeling of a paper fiber in cyclic loading applications. 
    Computational Materials Science, 110, 227–240. https://doi.org/10.1016/j.commatsci.2015.08.039

    Brandberg, A., Kulachenko, A. (2017)
    The effect of geometry changes on the mechanical stiffness of fibre-fibre bonds
    In: Advances in Pulp and Paper Research (pp. 683-719). Manchester



## Contribution guidelines
If you want to add your own snippets to the framework designed here, feel free to do so by contacting me or submitting a pull request.

## Who do I talk to?

August Brandberg augustbr at k t h . s e.




