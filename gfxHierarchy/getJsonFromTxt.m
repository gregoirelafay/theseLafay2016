clear all

addpath(genpath('~/Dropbox/projets/urbanSoundScapeXP2014/analyse/functions/'));
hierarchyPath='~/Dropbox/projets/urbanSoundScapeXP2014/analyse/hierarchy/';

json.startup;

type={'E','T'};

for uu=1:length(type)
    %% get Lvl 0
    [tags0,~,classes0,~] = getHierarchy( type{uu},0,hierarchyPath);
    
    %% get Lvl 1
    [tags1,~,classes1,classes0p] = getHierarchy( type{uu},1,hierarchyPath);
    
    classes0p(cellfun(@(x) isempty(x),classes0p))=classes1(cellfun(@(x) isempty(x),classes0p));
    
    classes0=cellfun(@(x) strrep(x,'_',' '),classes0,'UniformOutput',false);
    classes0p=cellfun(@(x) strrep(x,'_',' '),classes0p,'UniformOutput',false);
    classes1=cellfun(@(x) strrep(x,'_',' '),classes1,'UniformOutput',false);
    %% get data
    switch type{uu}
        case 'E'
            data.name='event';
        case 'T'
            data.name='texture';
    end
    
    data.children=[];
    s=1;
    
    
    for jj=1:length(classes0)
        data.children{jj}.name=classes0{jj};
        data.children{jj}.children=[];
        
        ind1=find(cellfun(@(x) ~isempty(strfind(x,tags0{jj})),tags1));
        
        switch type{uu}
            case 'E'
                
                c1Tmp=classes1(ind1);
                c0pTmp=classes0p(ind1);
                c0pLabelTmp=unique(c0pTmp);
                
                for ii=1:length(c0pLabelTmp)
                    
                    ind2=find(strcmp(c0pLabelTmp{ii},c0pTmp));
                    
                    data.children{jj}.children{ii}.children={};
                    
                    if length(ind2)==1
                        data.children{jj}.children{ii}.children{1}.name=c0pLabelTmp{ii};
                        data.children{jj}.children{ii}.children{1}.size=s;
                        %             data.children{jj}.children{ii}.size=s;
                    else
                        data.children{jj}.children{ii}.name=c0pLabelTmp{ii};
                        for gg=1:length(ind2)
                            data.children{jj}.children{ii}.children{gg}.name=c1Tmp{ind2(gg)};
                            data.children{jj}.children{ii}.children{gg}.size=s;
                        end
                    end
                end
            case 'T'
                for ii=1:length(ind1)
                    data.children{jj}.children{ii}.name=classes1{ind1(ii)};
                    data.children{jj}.children{ii}.size=s;
                end
        end
    end
    
    
    json.write(data,['json/data_' type{uu} '.js']);
    % savejson('',data,['json/data_' type '.js']);
end
disp('')