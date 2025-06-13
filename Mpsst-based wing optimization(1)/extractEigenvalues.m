function [modeNo, extractionOrder, eigenvalue, radians, cycles, generalizedMass, generalizedStiffness] = extractEigenvalues(f06FilePath)
    % 检查输入的文件路径是否有效
try   
    if nargin < 1 || isempty(f06FilePath) || ~exist(f06FilePath, 'file')
        error('Invalid F06 file path provided.');
    end
    
    % 初始化变量
    modeNo = [];
    extractionOrder = [];
    eigenvalue = [];
    radians = [];
    cycles = [];
    generalizedMass = [];
    generalizedStiffness = [];

    % 尝试打开文件
    fid = fopen(f06FilePath, 'r');
    if fid == -1
        error('Cannot open the F06 file.');
    end
    
    % 读取文件内容，逐行查找目标字符串
    lineIndex = 0;
    targetLineIndex = -1;
    while ~feof(fid)
        line = fgetl(fid);
        lineIndex = lineIndex + 1;
        if contains(line, 'R E A L   E I G E N V A L U E S')
            targetLineIndex = lineIndex;
            break;
        end
    end
    
    % 检查是否找到目标字符串
    if targetLineIndex == -1
        fclose(fid);
        error('The keyword "R E A L   E I G E N V A L U E S" was not found in the file.');
    end
    
    % 定位到目标行的第3行
    for i = 1:2
        line = fgetl(fid);
        lineIndex = lineIndex + 1;
    end
    
    % 读取目标行的数据（第4行到第13行，共10行）
    data = zeros(10, 7);
    for i = 1:10
        line = fgetl(fid);
        if ischar(line)
            % 将这一行的数据解析为数字
            data(i, :) = sscanf(line, '%f');
        else
            fclose(fid);
            error('Unexpected end of file while reading data lines.');
        end
    end
catch ME
    fclose(fid); % 确保在异常情况下关闭文件
    rethrow(ME); % 重新抛出异常以便上层处理
end    
    % 关闭文件
    fclose(fid);
    
    % 将数据分配到各个变量中
    modeNo = data(:, 1);
    extractionOrder = data(:, 2);
    eigenvalue = data(:, 3);
    radians = data(:, 4);
    cycles = data(:, 5);
    generalizedMass = data(:, 6);
    generalizedStiffness = data(:, 7);
end