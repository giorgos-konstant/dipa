function mask = zone_mask(percent)
    mask = zeros(32, 32);
    num_rows = round(32 * percent / 100);
    for i = 1:num_rows
        for j = 1:(num_rows - i + 1)
            mask(i, j) = 1;
        end
    end
end

