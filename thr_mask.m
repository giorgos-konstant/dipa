function mask = thr_mask(percent,cell)
    mask = zeros(32,32);
    max_thr = 0;
    for i = 1:numel(cell)
        matrix = cell{i};
        thr = prctile(abs(matrix(:)),100-percent);
        max_thr = max(max_thr,thr);
    end
    mask = abs(matrix) >= max_thr;
end

