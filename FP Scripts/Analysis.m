HitRate = [];
FARate = [];
disp('input dbcont when finished');
keyboard;

HitRate = nonzeros(HitRate);
FARate = nonzeros(FARate);
HRlen = length(FARate);


figure;
plot(HitRate,'-ok','MarkerFaceColor','k');
hold on
plot(FARate,'-o','MarkerFaceColor',[0.7 0.7 0.7],'color',[0.7,0.7,0.7]);
ylabel("Sensitivity (d') / Bias");
xlabel('Sessions');
yline(1.85,'--','Sensitivity Expert Threshold','color','k');
ylim([-1 4]);
xlim([1 15]);


%{
figure;
plot(HitRate,'-ok','MarkerFaceColor','k')
hold on
plot(FARate,'-o','MarkerFaceColor',[0.7 0.7 0.7],'color',[0.7 0.7 0.7]);
ylim([0 1]);
xlim([1 15]);
ylabel('Hit Rate / FA Rate');
xlabel('Sessions');
yline(0.3,'--','FA Rate Threshold','color',[0.7 0.7 0.7]);
yline(0.8,'--','Hit Rate Threshold','color','k');
%}