FileMINISAT:=Filename(DirectoriesPackagePrograms("MyPolyhedral"),"minisat");
FileConvertMINISAToutput:=Filename(DirectoriesPackagePrograms("MyPolyhedral"),"MinisatToGAP");


InstallGlobalFunction(GetSatisfiabilityConstraintsTiling,
function(nbPoint, ListTiles)
    local nbTile, ListPairPack, iTile, jTile, TheInt, ListCovering, iPt, ePt, ListCNF, ePairPack, iTile1, iTile2, eCNF;
    nbTile:=Length(ListTiles);
    ListPairPack:=[];
    for iTile in [1..nbTile-1]
      do
        for jTile in [iTile+1..nbTile]
          do
            TheInt:=Intersection(ListTiles[iTile], ListTiles[jTile]);
            if Length(TheInt)>0 then
                Add(ListPairPack, [iTile, jTile]);
            fi;
        od;
    od;
    ListCovering:=[];
    for iPt in [1..nbPoint]
      do
        Add(ListCovering, []);
    od;
    for iTile in [1..nbTile]
      do
        for ePt in ListTiles[iTile]
          do
            Add(ListCovering[ePt], iTile);
        od;
    od;
    ListCNF:=[];
    for ePairPack in ListPairPack
      do
        iTile1:=ePairPack[1];
        iTile2:=ePairPack[2];
        eCNF:=[-iTile1, -iTile2];
        Add(ListCNF, eCNF);
    od;
    Append(ListCNF, ListCovering);
    return ListCNF;
end);
