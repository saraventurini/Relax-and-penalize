% Kiwiel Algorithm 
function x = kiwiel(T,d,a,b,r,l,u,eps,t_U,t_L,maxiter)
    %g=@(t) b'* min(max(l, diag (1./ d)*(a-t.*b)),u);
    g=@(t) sum(min(max(l,a-t),u));
    niter = 1;
    while niter <= maxiter
        ind = ceil ( length (T)* rand (1 ,1));
        t_hat=T(ind); % scelgo t in T a random
        obj_fun=g(t_hat);
        %objfun(niter)=obj_fun;
        if obj_fun >r+eps
            t_L=t_hat ;
            T=T(ind +1: end); %T=T(T>t_L);
        elseif obj_fun <r-eps
            t_U=t_hat;
            T=T(1: ind -1); %T=T(T<t_U);
        else %obj_fun ==r
            t_star =t_hat;
            break ;
        end
        if length(T) <1
            t_star =t_L -(g(t_L)-r)*(t_U-t_L)/(g(t_U)-g(t_L));
            %obj_fun=g(t_star);
            %objfun(niter)=obj_fun;
            break ;
        end
        niter = niter +1;
    end
    %x=(min(max (l, diag (1./ d)*(a-t_star *b)),u))';
    x=(min(max(l,a-t_star),u))';
end
