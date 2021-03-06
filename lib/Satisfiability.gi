BindGlobal("SATISFIABILITY_tmpdir",DirectoryTemporary());

FileMINISAT:=Filename(DirectoriesPackagePrograms("MyPolyhedral"),"minisat");
FileConvertMINISAToutput:=Filename(DirectoriesPackagePrograms("MyPolyhedral"),"MinisatToGAP");


InstallGlobalFunction(SolveCNF,
function(ListCNF)
  local FileIn, FileErr, FileOut, FileRes, nbCNF, nbVAR, eCNF, LVal, output, eVal, TheCommand, TheRes;
  FileIn:=Filename(SATISFIABILITY_tmpdir,"Minisat.in");
  FileErr:=Filename(SATISFIABILITY_tmpdir,"Minisat.err");
  FileOut:=Filename(SATISFIABILITY_tmpdir,"Minisat.out");
  FileRes:=Filename(SATISFIABILITY_tmpdir,"Minisat.res");
  nbCNF:=Length(ListCNF);
  nbVAR:=0;
  for eCNF in ListCNF
  do
    LVal:=List(eCNF, AbsInt);
    nbVAR:=Maximum(nbVAR, Maximum(LVal));
  od;
  output:=OutputTextFile(FileIn, true);
  AppendTo(output, "p cnf ", nbVAR, " ", nbCNF, "\n");
  for eCNF in ListCNF
  do
    for eVal in eCNF
    do
      AppendTo(output, eVal, " ");
    od;
    AppendTo(output, "0\n");
  od;
  CloseStream(output);
  TheCommand:=Concatenation(FileMINISAT, " ", FileIn, " ", FileOut, " > ", FileErr);
  Exec(TheCommand);
  TheCommand:=Concatenation(FileConvertMINISAToutput, " ", FileOut, " ", FileRes);
  Exec(TheCommand);
  TheRes:=ReadAsFunction(FileRes)();
  RemoveFile(FileIn);
  RemoveFile(FileErr);
  RemoveFile(FileOut);
  RemoveFile(FileRes);
  return TheRes;
end);


InstallGlobalFunction(AllSolutionCNF,
function(ListCNF, nbMax)
  local ListSolution, ListCNFcomplex, eCNF, eSol, fCNF, len, iVert, SolCNF;
  ListSolution:=[];
  while(true)
  do
    ListCNFcomplex:=[];
    for eCNF in ListCNF
    do
      Add(ListCNFcomplex, eCNF);
    od;
    for eSol in ListSolution
    do
      fCNF:=[];
      len:=Length(eSol);
      for iVert in [1..len]
      do
        if eSol[iVert]=1 then
	  Add(fCNF, -iVert);
	else
	  Add(fCNF, iVert);
	fi;
      od;
      Add(ListCNFcomplex, fCNF);
    od;
    SolCNF:=SolveCNF(ListCNFcomplex);
    if SolCNF.result=false then
      break;
    fi;
    Add(ListSolution, SolCNF.sat);
    if nbMax>0 then
      if Length(ListSolution)=nbMax then
        break;
      fi;
    fi;
  od;
  return ListSolution;
end);
