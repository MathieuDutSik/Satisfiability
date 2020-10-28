GetListSet:=function(n, m)
    local ListSet, i, eList, j;
    ListSet:=[];
    for i in [1..n]
      do
        eList:=[];
        for j in [1..m]
          do
            pos:=i+j;
            if pos>n then
                pos:=pos - n;
            fi;
            Add(eList, pos);
        od;
        Add(ListSet, eList);
    od;
    return ListSet;
end;
