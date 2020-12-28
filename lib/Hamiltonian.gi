# We follow here https://www.csie.ntu.edu.tw/~lyuu/complexity/2011/20111018.pdf
sat_private@GetSatisfiabilityForHamiltonianCyclePath:=function(GRA, IsCycle)
    local n, MatrixIndex, pos, i, j, ListCNF, eCNF, i1, i2, j1, j2, ListNotEdges, LNotAdj, eAdj, last_n, k, kNext, eEdge;
    n := GRA.order;
    MatrixIndex:=NullMat(n, n);
    # Variable XIJ is if the entry on position i is vertex j.
    pos:=0;
    for i in [1..n]
    do
        for j in [1..n]
        do
            pos:=pos+1;
            MatrixIndex[i][j]:=pos;
        od;
    od;
    ListCNF:=[];
    # Each vertex j must appear in the path.
    for j in [1..n]
    do
        eCNF:=[];
        for i in [1..n]
        do
            Add(eCNF, MatrixIndex[i][j]);
        od;
        Add(ListCNF, eCNF);
    od;
    # No node j appear twice in the path.
    for j in [1..n]
    do
        for i1 in [1..n]
        do
            for i2 in [i1+1..n]
            do
                eCNF:=[-MatrixIndex[i1][j] , -MatrixIndex[i2][j] ];
                Add(ListCNF, eCNF);
            od;
        od;
    od;
    # Every position i in the path must be occupired
    for i in [1..n]
    do
        eCNF:=[];
        for j in [1..n]
        do
            Add(eCNF, MatrixIndex[i][j]);
        od;
        Add(ListCNF, eCNF);
    od;
    # No two nodes occupy the same position in the path
    for i in [1..n]
    do
        for j1 in [1..n]
        do
            for j2 in [j1+1..n]
            do
                eCNF:=[-MatrixIndex[i][j1] , -MatrixIndex[i][j2] ];
                Add(ListCNF, eCNF);
            od;
        od;
    od;
    # Non-adjacent node cannot be adjacent
    ListNotEdges:=[];
    for i in [1..n]
    do
        LNotAdj:=Difference([i+1..n], Adjacency(GRA, i));
        for eAdj in LNotAdj
        do
            Add(ListNotEdges, [i, eAdj]);
        od;
    od;
    # Non-Adjacenmt node (i,j) cannot be adjacent in the path
    if IsCycle then
        last_n:=n;
    else
        last_n:=n-1;
    fi;
    for k in [1..last_n]
    do
        if k<n then
            kNext:=k+1;
        else
            kNext:=1;
        fi;
        for eEdge in ListNotEdges
        do
            eCNF:=[ -MatrixIndex[k][eEdge[1]], -MatrixIndex[kNext][eEdge[2]] ];
            Add(ListCNF, eCNF);
            eCNF:=[ -MatrixIndex[k][eEdge[2]], -MatrixIndex[kNext][eEdge[1]] ];
            Add(ListCNF, eCNF);
        od;
    od;
    # Returning the List of conditions
    return [MatrixIndex, ListCNF];
end;



sat_private@TestHamiltonianCyclePath:=function(GRA, IsCycle)
    local ePair, MatrixIndex, ListCNF, SolCNF, n, eSeq, i, j;
    ePair:=sat_private@GetSatisfiabilityForHamiltonianCyclePath(GRA, IsCycle);
    MatrixIndex:=ePair[1];
    ListCNF:=ePair[2];
    SolCNF:=SolveCNF(ListCNF);
    if SolCNF.result then
        n:=GRA.order;
        eSeq:=[];
        for i in [1..n]
        do
            for j in [1..n]
            do
                if SolCNF.sat[MatrixIndex[i][j]]=1 then
                    Add(eSeq, j);
                fi;
            od;
        od;
        return eSeq;
    fi;
    return fail;
end;



InstallGlobalFunction(SAT_HamiltonianCycle,
function(GRA)
    return sat_private@TestHamiltonianCyclePath(GRA, true);
end);



InstallGlobalFunction(SAT_HamiltonianPath,
function(GRA)
    return sat_private@TestHamiltonianCyclePath(GRA, false);
end);
