function [ xd ]=conXDF(pIndex,sIndex,data)
    pXD=conXD(pIndex,data);
    sXD=conXD(sIndex,data);
    xd=[pXD+sXD*0;sXD];
end