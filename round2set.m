function rounded_values = round2set(values,set)

    rounded_values = zeros(size(values));
    for j = 1:length(values)
        closest = 1;
        for i = 2:length(set)
            if abs(values(j)-set(i)) < abs(values(j)-set(closest))
                closest = i;
                rounded_values(j) = set(i);
            end
        end
    end
end

