clear;close all;clc;
tic;
max_iter = 100;
printf('\n');
string = input('Input the data file -->> ','s');
data = load(string);
printf('\n');
if(yes_or_no('Do you have labels in your data file?'))
data(:,columns(data)) = []; %deleting the label column of the data
endif
data = normalize(data);
if(columns(data)==2)
figure;
plot(data(:,1),data(:,2),'ko');
title('Data Points');
endif
data = data(randperm(rows(data)),:); %randomise the data
printf('\n');
K = input('Input the number of clusters you want -->>  ');

index = randperm(rows(data))(1:K);
for i = 1:K
  cluster(i,:) = data(index(i),:);  %k number of cluster center is taken,which are actually any random data points
endfor


for j = 1:max_iter
  clusterCheck = cluster;
  count = zeros(K,1); %to count the number of clusters in every iterations
  clusterSum = zeros(K,columns(data));
  for i = 1:rows(data)
      for k = 1:K
          d(k,:) = distance(data(i,:),cluster(k,:)); %to calculate the distance from the data points to present cluster centers 
      endfor 
      for k = 1:K
         if(min(d) == d(k,:)) 
           clusterIndex(i,:) = k; %assigning the data example to a particular cluster center
           clusterSum(k,:) = clusterSum(k,:) + data(i,:);
           count(k,:)++;
         endif  
      endfor    
  endfor
  
  
  for k = 1:K
  cluster(k,:) = clusterSum(k,:)/count(k,:); %For next iteration,cluster center is changed to the mean of the data points for individual clusters
  endfor
  
  movement_of_clustercenters = 0;
  movement_of_clustercenters = sum(distance(cluster,clusterCheck));
  if(movement_of_clustercenters == 0)
  break
  endif
  
endfor

assignedCluster = [data';clusterIndex']';


printf('\n');
printf('The number of data points in individual clusters = \n');
count
printf('\n');
printf('Program paused,Press Enter to continue\n');
pause;

for k = 1:K
 p = 1;
  for i = 1:size(data,1)
    if(clusterIndex(i,1) == k)
      for j = 1:size(data,2)
        DATA(p,j,k) = data(i,j);
      endfor
      p++;
    endif
  endfor
endfor
printf('\n');
if(yes_or_no('Do you want to print all the data points of each clusters? '))
p = 1;
for k = 1:K
D = DATA(:,:,k);
D(~any(D,2),:) = [];
printf("\nPoints assigned to cluster %d=\n",k);
D 
endfor
endif

if(columns(data)==2)
figure;
cmap = hsv(K);
for k = 1:K
D = DATA(:,:,k);
D(~any(D,2),:) = [];
plot(D(:,1),D(:,2),'o','Color',cmap(k,:));
hold on;
endfor
title('Clusters');
endif


toc;
