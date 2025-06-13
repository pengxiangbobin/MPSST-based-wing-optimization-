function [ MAXIMUMDISPLACEMENTS, DISPLACEMENTSNO,MAXIMUMVONMISES,Mass,failureCriteria,maxTau12] = extractdata(f06FilePath)
    % 初始化变量
    stressData = [];
    MAXIMUMDISPLACEMENTS = [0];
    DISPLACEMENTSNO = [0];
    MAXIMUMVONMISES = 0;  % 初始化 VON MISES 应力最大值
    Mass = [0];  % 初始化质量变量
    maxTau12 = 0 ;
    Noindex = {'T1', 'T2', 'T3', 'R1', 'R2', 'R3'};
    stressLineFound = false; % 初始化应力行查找标志
    fiberStressLineFound = false;
    failureCriteria = 1;
    fid = -1;
    try
        % 检查输入的文件路径是否有效
        if nargin < 1 || isempty(f06FilePath) || ~exist(f06FilePath, 'file')
            error('Invalid F06 file path provided.');
        end

        % 尝试打开文件
        fid = fopen(f06FilePath, 'r');
        if fid == -1
            error('Cannot open the F06 file.');
        end

        % 逐行查找目标字符串
        lineIndex = 0;
        targetLineIndex = -1;
        while ~feof(fid)
            line = fgetl(fid);
            lineIndex = lineIndex + 1;
            if contains(line, 'MAXIMUM  DISPLACEMENTS')
                targetLineIndex = lineIndex;
                break;
            end
        end

        % 检查是否找到目标字符串
        if targetLineIndex == -1
            fclose(fid);
            warning('The keyword "MAXIMUM  DISPLACEMENTS" was not found in the file.');
            return; % 返回，使用默认值
        end

        % 跳过目标行后的无效行
        for i = 1:2
            fgetl(fid); % 跳过无效数据行
        end

        % 读取 DISPLACEMENTS 数据
        line = fgetl(fid);

        if ischar(line)
            displacementsData = sscanf(line, '%*f %*f %f %f %f %f %f %f');
        else
            fclose(fid);
            warning('Unexpected end of file while reading DISPLACEMENTS data.');
            return; % 返回，使用默认值
        end

        % 检查是否读取到有效数据
        if isempty(displacementsData)
            warning('未能读取到位移数据，请检查文件格式。');
            return; % 返回，使用默认值
        end

        [MAXIMUMDISPLACEMENTS, maxDispIndex] = max(displacementsData);
        DISPLACEMENTSNO = Noindex{maxDispIndex};

        

% while ~feof(fid)
%     line = fgetl(fid);
%     
%     % 查找目标字符串
%     if contains(line, 'S T R E S S E S   I N   L A Y E R E D   C O M P O S I T E   E L E M E N T S   ( Q U A D 4 )')
%         fiberStressLineFound = true;  % 找到目标字符串
%         continue;  % 跳过这一行，继续读取下一行
%     elseif contains(line, 'S T R E S S E S   I N   Q U A D R I L A T E R A L   E L E M E N T S   ( Q U A D 4 )')
%         break;  % 遇到结束字符串，退出循环
%     end
% 
%     % 读取应力数据
%     if fiberStressLineFound && ischar(line) && ~isempty(line)
%         % 使用正则表达式提取所有数字
%         numbers = regexp(line, '([-+]?[0-9]*\.?[0-9]+[eE]?[-+]?[0-9]*)', 'tokens');
%         if ~isempty(numbers)
%             % 提取第 4、5、6 个数字，确保索引有效
%             if length(numbers) >= 6
%                 sigma1 = str2double(numbers{4}{1});  % σ1
%                 sigma2 = str2double(numbers{5}{1});  % σ2
%                 tau12 = str2double(numbers{6}{1});   % τ12
% 
%                 % 更新最大 tau12 的绝对值
%                 maxTau12 = max(maxTau12, abs(tau12));
%                 
%                 % 调用 Tsai-Wu 准则函数
%                 [failureCriteria,failure_index] = tsai_wu_failure(sigma1, sigma2, tau12);
%                 %stressData = [stressData; sigma1, sigma2, tau12];  % 增加一行
%                 % 如果 failureCriteria 计算得出为 1，则跳出循环
%                 if failureCriteria == 1
%                     break;  % 跳出循环
%                 end
%             end
%         end
%     end
% end



% 读取 VON MISES 应力数据
        while ~feof(fid)
            line = fgetl(fid);
            if contains(line, 'S T R E S S E S   I N   Q U A D R I L A T E R A L   E L E M E N T S   ( Q U A D 4 )        OPTION = BILIN')
                stressLineFound = true;  % 找到目标字符串
                continue;  % 跳过这一行，继续读取下一行
            elseif contains(line, 'S T R E S S E S   I N   T R I A N G U L A R   E L E M E N T S   ( T R I A 3 )')
                break;  % 遇到结束字符串，退出循环
            end

            % 读取应力数据
            if stressLineFound && ischar(line) && ~isempty(line)
                % 查找以数字结尾的行并提取数字
                 numbers = regexp(line, '([-+]?[0-9]*\.?[0-9]+[eE]?[-+]?[0-9]*)$', 'tokens');
                if ~isempty(numbers)
                    stressValue = str2double(numbers{1}{1});  % 提取最后的数字
                    if stressValue > MAXIMUMVONMISES
                        MAXIMUMVONMISES = stressValue;  % 更新最大值
                    end
                end
            end
        end

      





        % 重新打开文件以提取质量数据
        fclose(fid); % 关闭之前的文件
        fid = fopen(f06FilePath, 'r'); % 重新打开文件
        if fid == -1
            error('Cannot open the F06 file.');
        end

        % 重置行计数并查找质量数据
        massTargetLineIndex = -1; % 初始化行索引
        lineIndex = 0; % 初始化行计数
        while ~feof(fid)
            line = fgetl(fid);
            lineIndex = lineIndex + 1; % 更新行计数
            if contains(line, 'MASS AXIS SYSTEM (S)')
                massTargetLineIndex = lineIndex; % 记录行号
                break; % 找到后退出
            end
        end

        % 检查是否找到质量数据的目标字符串
        if massTargetLineIndex == -1
            fclose(fid);
            warning('The keyword "MASS AXIS SYSTEM (S)" was not found in the file.');
            return; % 返回，使用默认值
        end

        % 跳过标题行
        fgetl(fid); % 跳过标题行

        % 读取第一个方向的质量数据
        line = fgetl(fid);
        if ischar(line)
    % 使用适合格式的 sscanf 来提取多个浮点数
    massData = sscanf(line, '%*s %f %*f %*f %*f'); % 跳过第一个字符串，读取第一个浮点数
    if ~isempty(massData)
        Mass = massData(1); % 只使用第一个浮点数
    else
        warning('未能读取到有效的质量数据。');
    end
else
            fclose(fid);
            warning('Unexpected end of file while reading MASS data.');
            return; % 返回，使用默认值
        end

      
    catch ME
        warning(ME.message); % 输出捕获的错误信息
        % 确保文件关闭
    if fid > -1
        fclose(fid);
    end
    end

    % 确保文件关闭
    if fid > -1
        fclose(fid);
    end
end