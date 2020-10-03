function TS_FeatureFeatureScatter(whatData,opIDs)
% For Empirical1000

if nargin < 1
    whatData = load('HCTSA_merged.mat');
end
if nargin < 2
    opIDs = [871,7704];
end

assert(length(opIDs)==2);

tsClasses = {'noise','SDE',{'AR','MA'},'dynsys',...
        'map','finance','meteorology','sound',...
        'seismology','ecg','ecg'};

colorCell = GiveMeColors(length(tsClasses));


[TS_DataMat,TimeSeries,Operations] = TS_LoadData(whatData);
filterToTwo = ismember(Operations.ID,opIDs);
TS_DataMat = TS_DataMat(:,filterToTwo);
Operations = Operations(filterToTwo,:);

f = figure('color','k');
hold('on')
ax = gca();
for i = 1:length(tsClasses);
    if iscell(tsClasses{i})
        classIDs = cell(length(tsClasses{i}),1);
        for j = 1:length(tsClasses{i})
            classIDs{j} = TS_GetIDs(tsClasses{i}{j},whatData,'ts','Keywords');
        end
        classIDs = vertcat(classIDs{:});
    else
        classIDs = TS_GetIDs(tsClasses{i},whatData,'ts','Keywords');
    end
    isClass = ismember(TimeSeries.ID,classIDs);
    x = TS_DataMat(isClass,1);
    y = TS_DataMat(isClass,2);
    plot(x,y,'.','color',colorCell{i})

    offset_x = 0.1*range(TS_DataMat(:,1));
    if iscell(tsClasses{i})
        text(median(x)+offset_x,median(y),BF_cat(tsClasses{i}),'color',colorCell{i})
    else
        text(median(x)+offset_x,median(y),tsClasses{i},'color',colorCell{i})
    end
end

axis('square');
ax.Color = 'k';
ax.XColor = 'w';
ax.YColor = 'w';
xlabel(Operations.Name{1},'interpreter','none')
ylabel(Operations.Name{2},'interpreter','none')

r = corr(TS_DataMat(:,1),TS_DataMat(:,2),'type','Spearman');
title(sprintf('rho = %.3f',r),'color','w')

end
