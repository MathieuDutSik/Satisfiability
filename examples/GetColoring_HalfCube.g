GetHalfCube:=function(n)
    local ListSet, nbVert, GRA, iVert, jVert, eInt;
    ListSet:=Filtered(Combinations([1..n]), x->Length(x) mod 2 = 0);
    nbVert:=Length(ListSet);
    GRA:=NullGraph(Group(()), nbVert);
    for iVert in [1..nbVert]
      do
        for jVert in [1..nbVert]
          do
            eInt:=Intersection(ListSet[iVert], ListSet[jVert]);
            if Length(eInt)=2 then
                AddEdgeOrbit(GRA, [iVert, jVert]);
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


GRA9:=GetHalfCube(9);
TheColoring:=SAT_TestChromaticNumber(GRA9, 13);
