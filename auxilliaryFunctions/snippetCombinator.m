function finalSnippet = snippetCombinator(snippetType,inputCell,constantPart,fileSep)
%snippetCombinator() is a function that performs assembling of various
%shorter snippets that are needed in the solution sequence. Unlike the main
%structure, which automatically creates an N-dimensional grid of all
%possible permutations, snippetCombinator.m only adds the snippets
%sequentially. This is perfect for operations that essentially consist of
%adding together smaller snippets, such as geometry construction of 3D
%fiber networks and assemblying of test cases to be run. 

numberOfSnippets = numel(inputCell);

if numberOfSnippets > 0
    for xLoop = 1:numberOfSnippets
        snippetPiece = importAnsysSnippet(horzcat(snippetType,fileSep,inputCell{xLoop}));
        fileID = fopen('tempConstruct.txt','a');
        fprintf(fileID,'%s\n',snippetPiece,constantPart);
        fclose(fileID);
    end
else
    fileID = fopen('tempConstruct.txt','a');
    fprintf(fileID,'%s\n',constantPart);
    fclose(fileID);
end

finalSnippet = importAnsysSnippet('tempConstruct');  
delete('tempConstruct.txt')
