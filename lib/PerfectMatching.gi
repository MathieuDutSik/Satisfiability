sat_private@GetSatisfiabilityForPerfectMatching:=function(GRA)
    local ListEdges, n, iVert, jVert, nbEdge, ListCNF, eCNF, iEdge, jEdge;
    ListEdges:=[];
    n:=GRA.order
    for iVert in [1..n]
    do
        for jVert in Adjacency(GRA, iVert)
        do
            if jVert>iVert then
                Add(ListEdges, [iVert, jVert]);
            fi;
        od;
    od;
    nbEdge:=Length(ListEdges);
    #
    ListCNF:=[];
    for iVert in [1..n]
    do
        eCNF:=[];
        for iEdge in [1..nbEdge]
        do
            if Position(ListEdges[iEdge], iVert)<>fail then
                Add(eCNF, iEdge);
            fi;
        od;
        Add(ListCNF, eCNF);
    od;
    #
    for iEdge in [1..nbEdge]
    do
        for jEdge in [1+iEdge..nbEdge]
        do
            if Length(Intersection(ListEdges[iEdge], ListEdges[jEdge])) > 0 then
                eCNF:=[-iEdge, -jEdge];
                Add(ListCNF, eCNF);
            fi;
        od;
    od;
    #
    return [ListEdges, ListCNF];
end;



InstallGlobalFunction(SAT_PerfectMatching,
function(GRA)
    local ePair;
    ePair:=sat_private@GetSatisfiabilityForPerfectMatching(GRA);
    ListEdges:=ePair[1];
    ListCNF:=ePair[2];
    SolCNF:=SolveCNF(ListCNF);
    if SolCNF.result then
        TheMatching:=[];
        for iEdge in [1..Length(ListEdges)]
        do
            if SolCNF.sat[ iEdge ]=1 then
                Add(TheMatching, ListEdges[iEdge]);
            fi;
        od;
        return TheMatching;
    fi;
    return fail;
end);

