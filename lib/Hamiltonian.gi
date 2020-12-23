# We follow here https://www.csie.ntu.edu.tw/~lyuu/complexity/2011/20111018.pdf
sat_private@GetSatisfiabilityForHamiltonianCycle:=function(GRA)
    local MatrixIndex;
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
    for k in [1..n]
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
        od;
    od;
    # Returning the List of conditions
    return [MatrixIndex, ListCNF];
end;


InstallGlobalFunction(SAT_HamiltonianCycle,
function(GRA)
    local ListCNF, SolCNF, n;
    ePair:=sat_private@GetSatisfiabilityForHamiltonianCycle(GRA);
    MatrixIndex:=ePair[1];
    ListCNF:=ePair[2];
    SolCNF:=SolveCNF(ListCNF);
    if SolCNF.result then
        n:=GRA.order;
        eCycle:=[];
        for i [1..n]
        do
            for j in [1..n]
            do
                if SolCNF.sat[MatrixIndex[i][j]]=1 then
                    Add(eCycle, j);
                fi;
            od;
        od;
        return eCycle;
    fi;
    return fail;
end);
