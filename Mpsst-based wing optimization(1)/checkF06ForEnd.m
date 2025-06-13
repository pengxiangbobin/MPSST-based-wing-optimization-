function [isJobEnded, lastTenLines] = checkF06ForEnd(f06FilePath)
    % 初始化仿真结束标志为 false
    isJobEnded = false;
    
    % 初始化用于存储最后十行的 cell 数组
    lastTenLines = cell(1, 10);
    
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
        
        % 定位到文件末尾
        fseek(fid, 0, 'eof');
        fileEndPos = ftell(fid);
        
        % 从文件末尾开始读取最后几千字节（根据需要调整此值）
        bytesToRead = min(5000, fileEndPos); % 假设最后5000字节足够
        fseek(fid, -bytesToRead, 'eof');
        fileContent = fread(fid, bytesToRead, '*char')';
        
        % 关闭文件
        fclose(fid);
        
        % 按行分割读取的内容
        lines = strsplit(fileContent, '\n');
        
        % 获取最后十行
        numLines = length(lines);
        if numLines > 10
            lastTenLines = lines(numLines-9:numLines);
        else
            lastTenLines = lines;
        end
        
        % 检查最后十行是否包含 "END OF JOB"
        isJobEnded = any(cellfun(@(l) contains(l, 'END OF JOB'), lastTenLines));
        
        % 反转 cell 数组以获得正确的顺序
        lastTenLines = lastTenLines(end:-1:1);
        
    catch ME
        % 捕获错误并输出警告信息
        warning(ME.message);
        
        % 如果需要，可以设置默认值
        lastTenLines = {'Error occurred, file not processed.'};
    end
end