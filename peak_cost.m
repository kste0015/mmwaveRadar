function cost = peak_cost(peak, possible_values)
    cost = min((peak - possible_values).^6);
end
