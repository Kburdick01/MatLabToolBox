function truncate_csv_robust()
    % --- Configuration ---
    SOURCE_DIRECTORY = 'C:\Users\kyleb\Desktop\large_csvs';
    DESTINATION_DIRECTORY = 'C:\Users\kyleb\Desktop\medium_csvs';
    NUM_EVENTS_TO_KEEP = 70000000;

    % --- Main Script ---
    fprintf('--- Starting Robust CSV Truncation Script ---\n');

    if ~exist(SOURCE_DIRECTORY, 'dir'), fprintf('ERROR: Source folder not found.\n'); return; end
    if ~exist(DESTINATION_DIRECTORY, 'dir'), fprintf('Creating destination folder.\n'); mkdir(DESTINATION_DIRECTORY); end

    csvFiles = dir(fullfile(SOURCE_DIRECTORY, '*.csv'));
    if isempty(csvFiles), fprintf('\nERROR: No .csv files were found.\n'); return; end
    
    fprintf('Found %d file(s) to process.\n\n', length(csvFiles));

    for i = 1:length(csvFiles)
        filename = csvFiles(i).name;
        source_path = fullfile(SOURCE_DIRECTORY, filename);
        dest_path = fullfile(DESTINATION_DIRECTORY, filename);
        
        fprintf('Processing %s...\n', filename);

        % --- This section is now the ENTIRE process ---
        % It reads and writes line-by-line to use minimal memory.
        try
            % Open the source file for reading
            source_fid = fopen(source_path, 'r');
            if source_fid == -1, error('Could not open source file.'); end
            
            % Open the destination file for writing
            dest_fid = fopen(dest_path, 'w');
            if dest_fid == -1, error('Could not create destination file.'); end

            % 1. Copy the header (comment lines and column names)
            while ~feof(source_fid)
                line = fgetl(source_fid);
                if startsWith(strtrim(line), '#')
                    fprintf(dest_fid, '%s\n', line);
                else
                    fprintf(dest_fid, '%s\n', line); % Write column header line
                    break;
                end
            end

            % 2. Copy the specified number of data lines
            for line_num = 1:NUM_EVENTS_TO_KEEP
                if feof(source_fid)
                    fprintf('  -> Reached end of file before reaching %d events.\n', NUM_EVENTS_TO_KEEP);
                    break; % Exit loop if source file runs out of lines
                end
                line = fgetl(source_fid);
                fprintf(dest_fid, '%s\n', line);
            end

            % Close both files
            fclose(source_fid);
            fclose(dest_fid);
            
            fprintf('  -> Successfully saved truncated file.\n');

        catch ME
            % Clean up and display any errors
            if exist('source_fid', 'var') && source_fid ~= -1, fclose(source_fid); end
            if exist('dest_fid', 'var') && dest_fid ~= -1, fclose(dest_fid); end
            fprintf('  -> AN ERROR OCCURRED: %s\n', ME.message);
        end
    end
    
    fprintf('\n--- All files processed. ---\n');
end