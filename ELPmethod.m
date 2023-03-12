function [pert,Measmnt,sddist,pairs] = ELPmethod(pertXX_2d,MeasmntXX,sddistXX,pairsXX,source,detect,range)

numOfFiles = length(pertXX_2d);             % pertXX_2d format is one cell one data file
pert = cell(1,numOfFiles);                  % need a cell array because of uneven pert arrays after their outliers are removed
Measmnt = cell(1,numOfFiles);
sddist = cell(1,numOfFiles);
pairs = cell(1,numOfFiles);

for k = 1:numOfFiles
    pertXX = pertXX_2d{k};
    dataXX = [real(pertXX).',imag(pertXX).'];
%     figure;plot(dataXX(:,1),dataXX(:,2),'.');hold on;
%     ang = 0:0.01:2*pi; xp = cos(ang);yp = sin(ang);plot(xp,yp);
    
    [sig,mu,mah,outliers]=robustcov_adaptive_range(dataXX,range);
    idxELP = find(outliers == 1);
%     figure;gscatter(dataXX(:,1),dataXX(:,2),outliers,'br','ox')
%     data = dataXX;
%     covariance = sig;
%     [eigenvec, eigenval ] = eig(covariance);
% 
%     % Get the index of the largest eigenvector
%     [largest_eigenvec_ind_c, r] = find(eigenval == max(max(eigenval)));
%     largest_eigenvec = eigenvec(:, largest_eigenvec_ind_c);
% 
%     % Get the largest eigenvalue
%     largest_eigenval = max(max(eigenval));
% 
%     % Get the smallest eigenvector and eigenvalue
%     if(largest_eigenvec_ind_c == 1)
%         smallest_eigenval = max(eigenval(:,2));
%         smallest_eigenvec = eigenvec(:,2);
%     else
%         smallest_eigenval = max(eigenval(:,1));
%         smallest_eigenvec = eigenvec(1,:);
%     end
% 
%     % Calculate the angle between the x-axis and the largest eigenvector
%     angle = atan2(largest_eigenvec(2), largest_eigenvec(1));
%     
%     % This angle is between -pi and pi.
%     % Let's shift it such that the angle is between 0 and 2pi
%     if(angle < 0)
%         angle = angle + 2*pi;
%     end
%     angle * 57.2957795
%     % Get the coordinates of the data mean
%     avg = mean(data);
% 
%     % Get the 97.5% confidence interval error ellipse
%     chisquare_val = sqrt(chi2inv(range, 2));
%     theta_grid = linspace(0,2*pi);
%     phi = angle;
%     X0=avg(1);
%     Y0=avg(2);
%     a=chisquare_val*sqrt(largest_eigenval);
%     b=chisquare_val*sqrt(smallest_eigenval);
% 
%     % the ellipse in x and y coordinates 
%     ellipse_x_r  = a*cos( theta_grid );
%     ellipse_y_r  = b*sin( theta_grid );
% 
%     %Define a rotation matrix
%     R = [ cos(phi) sin(phi); -sin(phi) cos(phi) ];
% 
%     %let's rotate the ellipse to some angle phi
%     r_ellipse = [ellipse_x_r;ellipse_y_r]' * R;
%     figure;
%     % Draw the error ellipse
%     plot(r_ellipse(:,1) + X0,r_ellipse(:,2) + Y0,'-')
%     hold on;
%     outliersdata = dataXX(outliers,:);
%     insidedata = dataXX(~outliers,:);
%     % Plot the original data
% %     plot(data(:,1), data(:,2), '.');
%     plot(outliersdata(:,1),outliersdata(:,2),'rx','MarkerSize',10)
%     plot(insidedata(:,1),insidedata(:,2),'bo','MarkerSize',5)
% %     gscatter(dataXX(:,1),dataXX(:,2),outliers,'br','ox')
%     % mindata = min(min(data));
%     % maxdata = max(max(data));
%     % xlim([mindata-3, maxdata+3]);
%     % ylim([mindata-3, maxdata+3]);
%     % hold on;
%     r = 1;
%     th = 0:pi/100:2*pi;
%     xunit = r * cos(th) ;
%     yunit = r * sin(th) ;
%     plot(xunit, yunit);
%     % Plot the eigenvectors
% %     quiver(X0, Y0, largest_eigenvec(1)*sqrt(largest_eigenval), largest_eigenvec(2)*sqrt(largest_eigenval), '-m', 'LineWidth',2);
% %     quiver(X0, Y0, smallest_eigenvec(1)*sqrt(smallest_eigenval), smallest_eigenvec(2)*sqrt(smallest_eigenval), '-g', 'LineWidth',2);
%     hold on;
% 
%     % Set the axis labels
%     hXLabel = xlabel('x');
%     hYLabel = ylabel('y');


    MeasmntTemp = MeasmntXX{k};
    sddistTemp = sddistXX{k};
    pairsTemp = pairsXX{k};
    
    if ~isempty(idxELP)
        dataXX(idxELP,:) = [];
        MeasmntTemp(idxELP,:) = [];         % remove those which are corresponding to NaN
        sddistTemp(idxELP) = [];
    end
    
    counter = 1;
    for ii=1:source;
        for jj=1:detect;
            if pairsTemp(ii,jj) == 1
                found = find(idxELP == counter);
                if ~isempty(found)
                    pairsTemp(ii,jj) = 0;
                end
                counter = counter + 1;
            end
        end
    end
   
    dataLength = size(dataXX,1);
    pertXX = zeros(1,dataLength);
    for kk = 1:dataLength
        pertXX(kk) = complex(dataXX(kk,1),dataXX(kk,2));
    end
    
    pert{k} = pertXX;
    sddist{k} = sddistTemp;
    Measmnt{k} = MeasmntTemp;
    pairs{k} = pairsTemp;
end
return