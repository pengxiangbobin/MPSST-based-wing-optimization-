function [objvalue,MAXIMUMSPCFORCES,MAXIMUMDISPLACEMENTS,MAXIMUMAPPLIEDLOADS] = cal_best(bestindividual,bestthick,thickpredict,nsubergion,minlayer,difthick)
bdfFilePath = 'C:\Users\Chen Kenan\Desktop\wingtest\original.bdf';
modifiedBdfFilePath = 'C:\Users\Chen Kenan\Desktop\wingtest\latest.bdf';
f06FilePath = 'C:\Users\Chen Kenan\Desktop\wingtest\latest.f06';
batFilePath = 'C:\Users\Chen Kenan\Desktop\wingtest\run_nastran_mode.bat';
%CAL_OBJVALUE 
L=size(bestindividual,1);       % Number of chromosomes in the initial population
objvalue = zeros(1,L);
MAXIMUMSPCFORCES = zeros(1,L);
MAXIMUMDISPLACEMENTS = zeros(1,L);
MAXIMUMAPPLIEDLOADS = zeros(1,L);
for index=1:L 
SST = sequence(bestindividual(index,:),minlayer,difthick);
breaksign = 0;
% 打开 BDF 文件进行读取
fid = fopen(bdfFilePath, 'r');
if fid == -1
    error('Cannot open the BDF file.');
end

% 初始化部件名称数组和对应的行位置数组
partNames = {'botback0', 'botback9','botback1', 'botback2','botback3', 'botback4', 'botback5','botback6','botback7','botback8',...
            'botfront0','botfront9','botfront1','botfront2','botfront3','botfront4','botfront5','botfront6','botfront7','botfront8',...
            'topback0','topback9','topback1','topback2','topback3','topback4','topback5','topback6','topback7','topback8',...
            'topfront0','topfront9','topfront1','topfront2','topfront3','topfront4','topfront5','topfront6','topfront7','topfront8'};
lineNumbers = zeros(1, length(partNames));

% 按行读取文件内容
lineNumber = 0; % 初始化行计数器
while ~feof(fid)
    lineNumber = lineNumber + 1; % 更新行计数器
    line = fgetl(fid);
    
 % 遍历所有部件名称
    for i1 = 1:length(partNames)
        % 检查当前行是否包含特定部件名称
        if contains(line, ['Elements and Element Properties for region : ', partNames{i1}])
%             fprintf('Found region for part %s at line number: %d\n', partNames{i1}, lineNumber);
            lineNumbers(i1) = lineNumber; % 记录该部件的语句所在的行号
            break; % 找到后跳出当前循环，继续读取下一行
        end
    end
end

% 关闭文件
fclose(fid);

% 检查是否所有部件都已找到
unfoundParts = find(lineNumbers == 0);
if ~isempty(unfoundParts)
    fprintf('Warning: Some part(s) not found: ');
    disp(partNames(unfoundParts));
else
    disp('All parts found successfully.');
end


% 铺层数据生成
modtextbasic = [    
    "$ Elements and Element Properties for region : pshell.11"
    "$ Composite Property Reference Material: 100ceng"
    "$ Composite Material Description :"
    "PCOMP    11                                                      SYM"  % 保持不变
    "         2       .00183  0.      YES     2       .00183  0.      YES"
];

% 读取BDF文件内容
fileID = fopen(bdfFilePath, 'r');


bdfContent = {}; % 初始化 cell 数组
while ~feof(fileID)
    line = fgetl(fileID); % 逐行读取
    bdfContent{end + 1,1} = line; % 将行添加到 cell 数组
end
bdfContent = string(bdfContent);  % 将 bdfContent 转换为 string 数组

fclose(fileID);

for l = 40:-1:1  % 子结构数量
    thick = bestthick(index, l);
    positions = [];  % 用于存储长度为 thick 的元素索引
    angle = [];  % 用于存储长度为 thick 的元素
    
    for i = 1:length(SST)
        if length(SST{i}) == thick
            positions = [positions, i];  % 记录索引
            angle = SST{i};  % 存储匹配的元素
        end
    end

    % 输出结果
%     if isempty(positions)
%         disp('没有找到长度为 thick 的元素。');
%         continue;  % 跳过当前循环
%     else
%         disp('找到的长度为 thick 的元素索引：');
%         disp(positions);
%         disp('对应的元素：');
%         disp(angle);
%     end

    % 准备替换文本
    modtext = modtextbasic;
    modtext{1} = ['$ Elements and Element Properties for region : ', partNames{l}];
    modtext{2} = regexprep(modtextbasic{2}, '\d+', num2str(length(angle)));
    
    % 基本格式定义
    baseFormatSpec = '         %-8d%-8s%-8s%-8s%-8d%-8s%-8s%-8s';
    
    % 生成具体铺层角度
    newLines = strings(ceil(numel(angle) / 2), 1);  % 使用 strings 创建空字符串数组
    for k = 1:2:numel(angle)
        if k + 1 <= numel(angle)
            angleStr1 = sprintf('%d.', angle(k));
            angleStr2 = sprintf('%d.', angle(k + 1));
            newLines((k + 1) / 2) = sprintf(baseFormatSpec, ...
                2, ...
                '.00183', ... 
                angleStr1, ...
                'YES', ...
                2, ...
                '.00183', ... 
                angleStr2, ...
                'YES');       
        else
            angleStr1 = sprintf('%d.', angle(k));
            newLines((k + 1) / 2) = sprintf(baseFormatSpec, ...
                2, ...
                '.00183', ... 
                angleStr1, ...
                'YES');
        end
    end

    % 将新的变量内容替换后面几行
    modtext(5:4 + numel(newLines)) = newLines;

    % 替换bdf文件内容
    presentlineNumber = lineNumbers(l);  % 根据当前循环的索引获取行号

% 确保不重复插入内容
    if presentlineNumber > 0 && presentlineNumber <= length(bdfContent)
        % 找到所有相关行
        sectionStart = presentlineNumber;
        
        % 查找 $ Pset: 行
        sectionEnd = find(startsWith(bdfContent(sectionStart:end), '$ Pset:'), 1, 'first');
        
        % 确保 sectionEnd 不越界
        if ~isempty(sectionEnd)
            sectionEnd = sectionEnd + sectionStart - 1;  % 计算真实的 sectionEnd
        else
            sectionEnd = length(bdfContent);  % 如果没有找到，设为最后一行
        end

        % 将新生成的内容替换到bdfContent中，跳过PCOMP行
        bdfContent(sectionStart:sectionStart + 2) = modtext(1:3);  % 替换前三行
        bdfContent(sectionStart + 3) = bdfContent(sectionStart + 3);  % 保持PCOMP行不变
        
        % 删除旧的铺层信息
        startLine = sectionStart + 4;  % 第三行是铺层数据行
        numLinesToDelete = sectionEnd - (sectionStart + 3)-2;  % 计算要删除的行数
        if numLinesToDelete > 0
            bdfContent(startLine:startLine + numLinesToDelete) = [];  % 删除旧行
        end
        
        % 添加新的铺层信息
        bdfContent = [bdfContent(1:startLine - 1); newLines; bdfContent(startLine:end)];
    end
end

% 将修改后的内容写入新的BDF文件
fileID = fopen(modifiedBdfFilePath, 'w');
for k = 1:numel(bdfContent)
    fprintf(fileID, '%s\n', bdfContent(k));  % 使用 bdfContent(k) 代替 bdfContent{k}
end
fclose(fileID);




% 提供NASTRAN可执行文件的完整路径（如果未添加到系统路径中）
nastranPath = 'D:\Program Files\MSC.Software\MSC_Nastran\2020\bin\nastranw.exe';
% 创建运行NASTRAN的命令
nastranCommand = sprintf('"%s" "%s"', nastranPath, modifiedBdfFilePath);

% 将命令写入BAT文件
fid = fopen(batFilePath, 'w');
fprintf(fid, '%s\n', nastranCommand);
fclose(fid);

% 确保之前的F06文件不存在
if isfile(f06FilePath)
    delete(f06FilePath);
end

% 步骤3：从MATLAB中运行BAT文件并等待其完成

% 运行BAT文件
[status, cmdout] = system(sprintf('"%s"', batFilePath));

% 检查BAT文件是否成功执行
if status ~= 0
    error('NASTRAN执行失败: %s', cmdout);
end
pause(5);
% 步骤4：等待仿真完成并读取F06结果文件
% 仿真结束标志
isJobEnded = false;

% 循环检查，直到检测到 "END OF JOB"
while ~isJobEnded
    % 调用函数检查仿真是否结束，并获取最后十行
[isJobEnded, lastTenLines] = checkF06ForEnd(f06FilePath);
% 如果没有检测到 "END OF JOB"，等待一秒钟
    if ~isJobEnded
        pause(1);
    end
end

% 跳出循环后，说明检测到了 "END OF JOB"
disp('END OF JOB detected. The simulation has ended.');

% 调用函数并提取最大位移和应力
    [MAXIMUMSPCFORCES(index), SPCFORCESNO ,MAXIMUMDISPLACEMENTS(index), DISPLACEMENTSNO ,MAXIMUMAPPLIEDLOADS(index), MAXIMUMAPPLIEDLOADSNO] = extractdata(f06FilePath);
    MAXIMUMSPCFORCES(index)
    SPCFORCESNO
    MAXIMUMDISPLACEMENTS(index)
    DISPLACEMENTSNO
    MAXIMUMAPPLIEDLOADS(index)
    MAXIMUMAPPLIEDLOADSNO
    if MAXIMUMDISPLACEMENTS(index)>1.5e+04||MAXIMUMAPPLIEDLOADS(index)>500000000%MAXIMUMSPCFORCES>3.3772731e+06||
        objvalue(index) = 0
    else
        totalthick = sum(bestthick(index,:))
        objvalue(index) = (5000/sum(bestthick(index,:)))+(10000000/MAXIMUMSPCFORCES(index))+(10000/MAXIMUMDISPLACEMENTS(index))+(1000000/MAXIMUMAPPLIEDLOADS(index))
    end
    files_to_delete = {'latest.f04', 'latest.h5', 'latest.log'};

% 循环遍历每个文件名
for i = 1:length(files_to_delete)
    % 检查文件是否存在
    if exist(files_to_delete{i}, 'file')
        % 删除文件
        delete(files_to_delete{i});
    end
end
end
end