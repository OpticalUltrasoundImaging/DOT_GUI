function x = thre(x,lambda)

xl = abs(x)-lambda;
xl(xl<0) = 0;
x = sign(x).*xl;

end