GetHalfCube:=function(n)
    local ListSet, nbVert, GRA, iVert, jVert, eInt, eUnion, eDiff;
    ListSet:=Filtered(Combinations([1..n]), x->Length(x) mod 2 = 0);
    nbVert:=Length(ListSet);
    GRA:=NullGraph(Group(()), nbVert);
    for iVert in [1..nbVert]
      do
        for jVert in [iVert+1..nbVert]
        do
            eUnion:=Union(ListSet[iVert], ListSet[jVert]);
            eInt:=Intersection(ListSet[iVert], ListSet[jVert]);
            eDiff:=Difference(eUnion, eInt);
            if Length(eDiff)=2 then
                AddEdgeOrbit(GRA, [iVert, jVert]);
                AddEdgeOrbit(GRA, [jVert, iVert]);
            fi;
        od;
    od;
    return GRA;
end;


for n in [4..8]
  do
    GRA:=GetHalfCube(n);
    Print("n=", n, " chromatic=", SAT_ChromaticNumber(GRA), "\n");
od;


Print("Computing a coloring for n=9\n");
GRA9:=GetHalfCube(9);
TheColoring:=SAT_TestChromaticNumber(GRA9, 13);
