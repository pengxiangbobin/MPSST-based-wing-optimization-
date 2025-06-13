function [objvalue,MAXIMUMDISPLACEMENTS,MAXIMUMVONMISES,mass,failureCriteria,maxTau12] = cal_objvalue_ins(pop_0,pop_1,pop_2, pop_thick, minlayer, difthick, partNames,popsize)
global bdfFilePath modifiedBdfFilePath f06FilePath batFilePath allpartNames displacementsconstraint stressconstraint nastranPath;

L = popsize;  % 初始种群数量
objvalue = zeros(1, L);
MAXIMUMDISPLACEMENTS = zeros(1, L);
MAXIMUMVONMISES = zeros(1, L);
mass = zeros(1, L);
maxTau12 = zeros(1, L);
failureCriteria = ones(1, L);
array0 = [2,4,8,9,10,12,14,18,19,20,22,24,28,29,30,32,34,38,39,40];
array1 = [1,3,11,13,21,23,31,33];
array2 = [5,6,7,15,16,17,25,26,27,35,36,37];
% 铺层数据生成
modtextbasic = [
    "$ Elements and Element Properties for region : pshell.11"
    "$ Composite Property Reference Material: 100ceng"
    "$ Composite Material Description :"
    "PCOMP    11                                                         "  % 保持不变
    "         2       .0072  0.      YES     2       .0072  0.      YES"
    ];
for index = 1:L
    errorCount = 0;  % 初始化错误计数器
    maxRetries = 5;  % 最大重试次数
    thick_0 = pop_thick(index,array0);
    thick_1 = pop_thick(index,array1);
    thick_2 = pop_thick(index,array2);
    while errorCount < maxRetries
        try
            %                 SST = sequence(pop(index, :), minlayer, difthick);
            %                 if exist('new_MPST0', 'var') && iscell(new_MPST0)
            %                     SST = [new_MPST0, SST];
            %                 end
            MPST0 = sequence(pop_0(index,:),minlayer,difthick);
            tranlayerthick = max(thick_0);
            if mod(tranlayerthick,2) == 1
                tranlayerthick = tranlayerthick+1;
            end
            for i = 1:length(MPST0)
                if length(MPST0{i}) == tranlayerthick
                    tranlayer = MPST0{i}; % 将符合条件的 cell 添加到结果中
                    tranlayer = tranlayer(1:floor(end/2));
                end
            end
            MPST1 = sequence(pop_1(index,:),tranlayer,difthick);
            MPST2 = sequence(pop_2(index,:),tranlayer,difthick);

            % 打开 BDF 文件进行读取
            fid = fopen(bdfFilePath, 'r');
            if fid == -1
                error('Cannot open the BDF file.');
            end

            % 初始化部件名称数组和对应的行位置数组
            lineNumbers = zeros(1, length(partNames));

            % 按行读取文件内容
            lineNumber = 0;  % 初始化行计数器
            while ~feof(fid)
                lineNumber = lineNumber + 1;  % 更新行计数器
                line = fgetl(fid);

                % 遍历所有部件名称
                for i1 = 1:length(partNames)
                    if contains(line, ['Elements and Element Properties for region : ', partNames{i1}])
                        lineNumbers(i1) = lineNumber;  % 记录该部件的语句所在的行号
                        break;  % 找到后跳出当前循环，继续读取下一行
                    end
                end
            end

            fclose(fid);

            % 检查是否所有部件都已找到
            unfoundParts = find(lineNumbers == 0);
            if ~isempty(unfoundParts)
                fprintf('Warning: Some part(s) not found: ');
                disp(partNames(unfoundParts));
            else
                disp('All parts found successfully.');
            end
            % 读取BDF文件内容
            fileID = fopen(bdfFilePath, 'r');


            bdfContent = {}; % 初始化 cell 数组
            while ~feof(fileID)
                line = fgetl(fileID); % 逐行读取
                bdfContent{end + 1,1} = line; % 将行添加到 cell 数组
            end
            bdfContent = string(bdfContent);  % 将 bdfContent 转换为 string 数组

            fclose(fileID);

            for l = length(partNames):-1:1
                thick = pop_thick(index, l);
                angle = [];  % 用于存储长度为 thick 的元素
                if ismember(l,array0)
                    for i = 1:length(MPST0)
                        if length(MPST0{i}) == thick
                            angle = MPST0{i};  % 存储匹配的元素
                        end
                    end
                elseif ismember(l,array1)
                    if thick <= tranlayerthick
                        tranlayerfl = fliplr(tranlayer);
                        angle = [tranlayer tranlayerfl];
                    else
                        for i = 1:length(MPST1)
                            if length(MPST1{i}) == thick
                                angle = MPST1{i};  % 存储匹配的元素
                            end
                        end
                    end
                else
                    if thick <= tranlayerthick
                        tranlayerfl = fliplr(tranlayer);
                        angle = [tranlayer tranlayerfl];
                    else
                        for i = 1:length(MPST2)
                            if length(MPST2{i}) == thick
                                angle = MPST2{i};  % 存储匹配的元素
                            end
                        end
                    end
                end

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
                            '.0072', ...
                            angleStr1, ...
                            'YES', ...
                            2, ...
                            '.0072', ...
                            angleStr2, ...
                            'YES');
                    else
                        angleStr1 = sprintf('%d.', angle(k));
                        newLines((k + 1) / 2) = sprintf(baseFormatSpec, ...
                            2, ...
                            '.0072', ...
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


            % 提供 NASTRAN 可执行文件的完整路径
            %nastranPath = 'D:\Program Files\MSC.Software\MSC_Nastran\2020\bin\nastranw.exe';
            nastranCommand = sprintf('"%s" "%s"', nastranPath, modifiedBdfFilePath);

            % 将命令写入 BAT 文件
            fid = fopen(batFilePath, 'w');
            fprintf(fid, '%s\n', nastranCommand);
            fclose(fid);

            % 确保之前的 F06 文件不存在
            if isfile(f06FilePath)
                delete(f06FilePath);
            end

            % 运行 BAT 文件
            [status, cmdout] = system(sprintf('"%s"', batFilePath));

            if status ~= 0
                error('NASTRAN执行失败: %s', cmdout);
            end
            pause(3);

            % 循环检查仿真是否结束
            isJobEnded = false;
            while ~isJobEnded
                [isJobEnded, lastTenLines] = checkF06ForEnd(f06FilePath);
                if ~isJobEnded
                    pause(1);
                end
            end

            disp('END OF JOB detected. The simulation has ended.');

            % 提取最大位移和应力
            [ MAXIMUMDISPLACEMENTS(index), DISPLACEMENTSNO,MAXIMUMVONMISES(index),mass(index),failureCriteria(index),maxTau12(index)] = extractdata(f06FilePath);
            % 清理临时文件
            files_to_delete = {'latest.f04', 'latest.h5', 'latest.log', 'latest.f04.1', 'latest.h5.1', 'latest.log.1'};
            for i = 1:length(files_to_delete)
                if exist(files_to_delete{i}, 'file')
                    delete(files_to_delete{i});
                end
            end
            % 计算目标值

            MAXIMUMDISPLACEMENTS(index)
            MAXIMUMVONMISES(index)
            %maxTau12(index)
            mass(index)
            %failureCriteria(index)
            objvalue(index) = (10000000 / (mass(index)-10000));
            if objvalue(index) == Inf
                objvalue(index) = 0
            else
                if MAXIMUMDISPLACEMENTS(index)>displacementsconstraint
                    objvalue(index) =  objvalue(index) - (MAXIMUMDISPLACEMENTS(index));
                end
                if MAXIMUMVONMISES(index)>stressconstraint
                    objvalue(index) =  objvalue(index) - (( MAXIMUMVONMISES(index)-20000)/200);
                end
%                 if maxTau12(index)>7500
%                     objvalue(index) =  objvalue(index) -((maxTau12(index)-4000)/80);
%                 end
%                 if failureCriteria(index) == 1
%                     objvalue(index) =  objvalue(index) - 50*failureCriteria(index)
                    if objvalue(index) < 0
                        objvalue(index) = 0
                    end
%                 end
            end

            % 结束重试循环
            break;  % 成功执行，跳出重试循环

        catch ME
            errorCount = errorCount + 1;  % 增加错误计数
            warning('Error occurred: %s', getReport(ME, 'basic'));  % 使用 getReport 获取错误信息

            if errorCount >= maxRetries
                objvalue(index) = 0;  % 将当前 objvalue 设为 0
                fprintf('连续出现错误 %d 次，设置 objvalue(%d) 为 0，跳过到下一个索引。\n', maxRetries, index);
                break;  % 结束当前循环，继续下一个 index
            else
                fprintf('尝试重新运行... 当前重试次数: %d\n', errorCount);
            end
        end
    end


end
end