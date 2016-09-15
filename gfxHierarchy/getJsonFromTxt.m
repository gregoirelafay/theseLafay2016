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
    
    %% get Lvl 2
    [tags2,~,classes2,~] = getHierarchy( type{uu},2,hierarchyPath);
    
    %% get Lvl 3
    [tags3,~,classes3,~] = getHierarchy( type{uu},3,hierarchyPath);
    
    
    classes0p(cellfun(@(x) isempty(x),classes0p))=classes1(cellfun(@(x) isempty(x),classes0p));
    classes0=cellfun(@(x) strrep(x,'_',' '),classes0,'UniformOutput',false);
    classes0p=cellfun(@(x) strrep(x,'_',' '),classes0p,'UniformOutput',false);
    classes1=cellfun(@(x) strrep(x,'_',' '),classes1,'UniformOutput',false);
    classes2=cellfun(@(x) strrep(x,'_',' '),classes2,'UniformOutput',false);
    classes3=cellfun(@(x) strrep(x,'_',' '),classes3,'UniformOutput',false);
    
    %% get data
    switch type{uu}
        case 'E'
            data.name='event';
        case 'T'
            data.name='texture';
    end
    
    data.children=[];
    s=1;
    
    switch type{uu}
        case 'E'
            
            for jj=1:length(classes0)
                
                data.children{jj}.name=classes0{jj};
                data.children{jj}.children=[];
                
                ind0p=find(cellfun(@(x) ~isempty(strfind(x,tags0{jj})),tags1));
                c0pTmp=classes0p(ind0p);
                
                c0pTmp2=unique(c0pTmp);
                
                for ii=1:length(c0pTmp2)
                    
                    indTmp2=find(strcmp(c0pTmp,c0pTmp2(ii)));
                    
                    data.children{jj}.children{ii}.name=c0pTmp2{ii};
                    data.children{jj}.children{ii}.children=[];
                    
                    ind1=[];
                    
                    for rr=1:length(indTmp2)
                        ind1=[ind1 find(cellfun(@(x) ~isempty(strfind(x,tags1{ind0p(indTmp2(rr))})),tags1))];
                    end
                    
                    c1Tmp=classes1(ind1);
                    
                    for aa=1:length(c1Tmp)
                        
                        data.children{jj}.children{ii}.children{aa}.name=c1Tmp{aa};
                        data.children{jj}.children{ii}.children{aa}.children=[];
                        
                        ind2=find(cellfun(@(x) ~isempty(strfind(x,tags1{ind1(aa)})),tags2));
                        c2Tmp=classes2(ind2);
                        
                        for bb=1:length(c2Tmp)
                            
                            data.children{jj}.children{ii}.children{aa}.children{bb}.name=c2Tmp{bb};
                            data.children{jj}.children{ii}.children{aa}.children{bb}.children=[];
                            
                            ind3=find(cellfun(@(x) ~isempty(strfind(x,tags2{ind2(bb)})),tags3));
                            c3Tmp=classes3(ind3);
                            
                            for cc=1:length(c3Tmp)
                                
                                data.children{jj}.children{ii}.children{aa}.children{bb}.children{cc}.name=c3Tmp{cc};
                                data.children{jj}.children{ii}.children{aa}.children{bb}.children{cc}.size=s;
                                
                            end
                        end
                    end
                end
            end
            
        case 'T'
            for jj=1:length(classes0)
                
                data.children{jj}.name=classes0{jj};
                data.children{jj}.children=[];
                
                ind1=find(cellfun(@(x) ~isempty(strfind(x,tags0{jj})),tags1));
                c1Tmp=classes1(ind1);
                
                for ii=1:length(c1Tmp)
                    
                    data.children{jj}.children{ii}.name=c1Tmp{ii};
                    data.children{jj}.children{ii}.children=[];
                    
                    ind2=find(cellfun(@(x) ~isempty(strfind(x,tags1{ind1(ii)})),tags2));
                    c2Tmp=classes2(ind2);
                    
                    for cc=1:length(c2Tmp)
                        
                        data.children{jj}.children{ii}.children{cc}.name=c2Tmp{cc};
                        data.children{jj}.children{ii}.children{cc}.size=s;
                        
                    end
                end
                
            end
            
    end
    
    json.write(data,['json/data_' type{uu} '.js']);
    
end
disp('')