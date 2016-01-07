function [x] = Rbb(u, M)

x = 1./((1 / M.Ril) + u * M.gSL);