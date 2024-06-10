n = 100; 

% the number of monte-carlo trials to perform: 
N_MC = 100; 

%hArray = 10.^[-3,-2,-1,0];
%hArray = 10.^[-1];
hArray = [ 0.03 2 ];  % <- one is too small the other too large ... 

% to mean square error or absolute error: 
% 
DO_MAE = 0; 

for hi=1:length(hArray),
  %h = 0.1;         % <- an example bin width 
  h = hArray(hi); 

  % specify the bin widths: 
  x_lim_left = -4;
  x_lim_rght = +4;
  t0   = x_lim_left;
  tm   = x_lim_rght; 
  rng  = tm-t0; 
  nbin = ceil(rng/h); 
  bins = t0:h:(nbin*h+t0);       % <- the bin edges ... 
  bc  = bins(1:end-1)+0.5*h;     % <- the bin centers ... 
  
  % save each monte-carlo trial estimate of the probability distribution:
  all_fhats = zeros(N_MC,length(bins)-1); 
  % save each monte-carlo trial estimate of the mean square error (we evaluate the MSE on a grid):  
  x_mse_evaluate = linspace(x_lim_left,x_lim_rght,100); 
  all_mse = zeros(N_MC,length(x_mse_evaluate));
  for mci=1:N_MC,
    x = randn(1,n); 
    x(find(x<x_lim_left))=x_lim_left;
    x(find(x>x_lim_rght))=x_lim_rght;
    vk=histc(x,bins); vk(end)=[];
    % normalize: 
    fhat = vk/(n*h);
    all_fhats(mci,:) = fhat; 
    
    % record the MSE of this approximate PDF
    %all_mse(mci,:)   = (fhat-normpdf(bc,0,1)).^2;    
    fhat_interp      = interp1(bc,fhat,x_mse_evaluate); 
    if( ~DO_MAE )
      all_mse(mci,:)   = (fhat_interp-normpdf(x_mse_evaluate,0,1)).^2;
    else
      all_mse(mci,:)   = abs(fhat_interp-normpdf(x_mse_evaluate,0,1));
    end
  end
  
  % plot the last PDF estimate produced above
  if( 0 ) 
    fh=figure; plot( bc, normpdf(bc,0,1), '-go' ); hold on; 
    %plot( bc, fhat, '-rx' );
    stairs( bins, [fhat,fhat(end)], '-r' );
    axis( [x_lim_left,x_lim_rght,0,0.45] ); 
    title( 'the last Monte-Carlo PDF estimate' ); 
  end
  
  % plot the mean PDF estimate and one standard deviation confidence intervals: 
  if( 1 ) 
    %figure; plot( bc, all_fhats, '-' ); 
    mfh = mean(all_fhats); sfh = std(all_fhats); 
    fh=figure; plot( x_mse_evaluate, normpdf( x_mse_evaluate, 0, 1 ), '-go' ); hold on; 
    %plot( bc, mfh, '-xr' ); hold on; 
    %plot( bc, mfh-sfh, '-rx' ); plot( bc, mfh+sfh, '-rx' ); grid on; 
    stairs( bins, [mfh,mfh(end)], '-r' ); 
    tmp = max(mfh-sfh,0); stairs( bins, [tmp,tmp(end)], '-k' ); tmp=mfh+sfh; stairs( bins, [tmp,tmp(end)], '-k' ); grid on; 
    axis( [x_lim_left,x_lim_rght,0,1.0] ); 
    title( 'histogram estimate of the PDF with confidence intervals' ); 
    saveas(gcf,sprintf('prob_8_3_hist_ci_h_%1.0e',h),'epsc'); 
  end
  
  % plot the expected MSE over all of these monte-carlo's:
  if( 1 ) 
    figure; plot( x_mse_evaluate, mean(all_mse), '-r' ); grid on; 
    xlabel( 'x' ); ylabel( 'MSE value' ); 
    title( sprintf('mean MSE for h=%e; with %d MC trials',h,N_MC) ); 
    axis( [x_lim_left,x_lim_rght,0,0.1] ); 
   saveas(gcf,sprintf('prob_8_3_mc_mean_mse_ci_h_%1.0e',h),'epsc'); 
  end

end