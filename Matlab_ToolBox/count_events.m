function count_events()
    % --- Configuration ---
    % Paste the full path to ONE of your 15-minute CSV files here
    csv_file_path = 'C:\Users\kyleb\Desktop\large_csvs\burst-200mV-1hz-15min-30deg.csv';

    % --- Main Script ---
    fprintf('Processing file: %s\n', csv_file_path);

    % Check if the file exists
    if ~exist(csv_file_path, 'file')
        fprintf('ERROR: File not found. Please check the path.\n');
        return;
    end

    % Open the file for reading
    fid = fopen(csv_file_path, 'r');
    if fid == -1
        fprintf('ERROR: Could not open the file.\n');
        return;
    end

    event_count = 0;
    isFirstDataLine = true;

    % Read the file line by line
    while ~feof(fid)
        line = fgetl(fid);
        % Skip empty lines or comment lines
        if isempty(line) || startsWith(strtrim(line), '#')
            continue;
        end
        
        % The first line that is not a comment is the header, skip it
        if isFirstDataLine
            isFirstDataLine = false;
            continue;
        end
        
        % If it's a data line, increment the counter
        event_count = event_count + 1;
    end

    % Close the file
    fclose(fid);

    % --- Display Results ---
    fprintf('\n--- Results ---\n');
    fprintf('Total events in 15 minutes: %s\n', num2str(event_count, '%d'));
    
    % Calculate the number of events for 5 minutes (1/3 of the total)
    five_min_events = floor(event_count / 3);
    fprintf('Approximate events in 5 minutes: %s\n', num2str(five_min_events, '%d'));

end
