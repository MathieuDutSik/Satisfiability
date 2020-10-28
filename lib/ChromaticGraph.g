sat_private@GetSatisfiabilityForColoring:=function(GRA, nbColor)
  local MatrixIndex, n, i, eC, ListCNF, eCNF, fC, eAdj, pos1, pos2, pos;
  n:=GRA.order;
  MatrixIndex:=NullMat(n, nbColor);
  pos:=0;
  for i in [1..n]
  do
    for eC in [1..nbColor]
    do
      pos:=pos+1;
      MatrixIndex[i][eC]:=pos;
    od;
  od;
  ListCNF:=[];
  #
  # At least one color should be selected for each vertex
  #
  for i in [1..n]
  do
    eCNF:=[];
    for eC in [1..nbColor]
    do
      Add(eCNF, MatrixIndex[i][eC]);
    od;
    Add(ListCNF, eCNF);
  od;
  #
  # For each vertex at most one color should be selected
  #
  for i in [1..n]
  do
    for eC in [1..nbColor]
    do
      for fC in [eC+1..nbColor]
      do
        pos1:=MatrixIndex[i][eC];
        pos2:=MatrixIndex[i][fC];
	Add(ListCNF, [-pos1, -pos2]);
      od;
    od;
  od;
  #
  # for each edge we should not have the same color on both
  #
  for i in [1..n]
  do
    for eAdj in Adjacency(GRA, i)
    do
      if eAdj > i then
        for eC in [1..nbColor]
	do
	  pos1:=MatrixIndex[i][eC];
	  pos2:=MatrixIndex[eAdj][eC];
	  Add(ListCNF, [-pos1, -pos2]);
	od;
      fi;
    od;
  od;
  #
  # Returning the system
  #
  return ListCNF;
end;







sat_private@GetColoring:=function(SolCNF, nbVert, nbColor)
  local MatrixIndex, pos, i, eC, ThePartition, VectorColoring;
  if SolCNF.result=false then
    return false;
  fi;
  MatrixIndex:=NullMat(nbVert, nbColor);
  pos:=0;
  for i in [1..nbVert]
  do
    for eC in [1..nbColor]
    do
      pos:=pos+1;
      MatrixIndex[i][eC]:=pos;
    od;
  od;
  ThePartition:=[];
  for eC in [1..nbColor]
  do
    Add(ThePartition, []);
  od;
  VectorColoring:=ListWithIdenticalEntries(nbVert, -1);
  for i in [1..nbVert]
  do
    for eC in [1..nbColor]
    do
      pos:=MatrixIndex[i][eC];
      if SolCNF.sat[pos]=1 then
        VectorColoring[i]:=eC;
	Add(ThePartition[eC], i);
      fi;
    od;
  od;
  return rec(ThePartition:=ThePartition, VectorColoring:=VectorColoring);
end;


sat_private@GetListCNFspecifyPartialColoring:=function(nbVert, nbColor, ListPair)
  local MatrixIndex, pos, i, eC, eCNF, iVert, eVert, eColor, ListCNF, ePair;
  MatrixIndex:=NullMat(nbVert, nbColor);
  pos:=0;
  for i in [1..nbVert]
  do
    for eC in [1..nbColor]
    do
      pos:=pos+1;
      MatrixIndex[i][eC]:=pos;
    od;
  od;
  ListCNF:=[];
  for ePair in ListPair
  do
    eVert:=ePair.eVert;
    eColor:=ePair.eColor;
    pos:=MatrixIndex[eVert][eColor];
    Add(ListCNF, [pos]);
  od;
  return ListCNF;
end;

SAT_ExtendPartialColoring:=function(GRA, nbColor, ListPair)
    local ListCNF;
    ListCNF:=sat_private@GetSatisfiabilityForColoring(GRA, nbColor);
    nbVert:=GRA.order;
    Append(ListCNF, sat_private@GetListCNFspecifyPartialColoring(nbVert, nbColor, ListPair));
    SolCNF:=SolveCNF(ListCNF);
    if SolCNF.result=false then
        return false;
    fi;
    return sat_private@GetColoring(SolCNF, nbVert, nbColor);
end;



SAT_TestChromaticNumber:=function(GRA, nbColor)
    local ListCNF, SolCNF, nbVert;
    ListCNF:=sat_private@GetSatisfiabilityForColoring(GRA, nbColor);
    SolCNF:=SolveCNF(ListCNF);
    if SolCNF.result=false then
        return false;
    fi;
    nbVert:=GRA.order;
    return sat_private@GetColoring(SolCNF, nbVert, nbColor);
end;



SAT_ChromaticNumber:=function(GRA)
  local CliqueNr, nbColor, ListCNF, SolCNF;
  CliqueNr:=Maximum(List(CompleteSubgraphs(GRA), Length));
  nbColor:=CliqueNr;
  while(true)
  do
    ListCNF:=sat_private@GetSatisfiabilityForColoring(GRA, nbColor);
    SolCNF:=SolveCNF(ListCNF);
    if SolCNF.result then
      return nbColor;
    fi;
    nbColor:=nbColor+1;
  od;
end;
