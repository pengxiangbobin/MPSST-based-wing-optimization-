function dataGroups = extractDataGroups(bdfContent, lineNumbers)
    % 将bdfContent按行分割
    lines = strsplit(bdfContent, '\n');
    
    % 初始化存储特定数据组的cell数组
    dataGroups = cell(length(lineNumbers), 1);
    
    % 遍历每个起始行号
    for i = 1:length(lineNumbers)
        startLine = lineNumbers(i);
        dataGroup = {};
        
        % 从起始行开始读取数据，直到遇到以$ Pset开头的下一行
        for j = startLine:length(lines)
            line = strtrim(lines{j});
            if startsWith(line, '$ Pset', 'IgnoreCase', true)
                break;
            end
            dataGroup{end+1} = line; %#ok<AGROW>
        end
        
        % 将读取到的数据组存储到dataGroups中
        dataGroups{i} = dataGroup;
    end
end