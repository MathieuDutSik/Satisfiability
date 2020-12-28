GRA:=ComplementGraph(JohnsonGraph(5,3));
for i in [1..GRA.order]
do
    Print("i=", i, " LAdj=", Adjacency(GRA,i), "\n");
od;


PetersenPath:=SAT_HamiltonianPath(GRA);
Print("PetersenPath=", PetersenPath, "\n");

PetersenCycle:=SAT_HamiltonianCycle(GRA);
Print("PetersenCycle=", PetersenCycle, "\n");
