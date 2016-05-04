function result = bestparams(asl_data,params, t) 

Y = calculate_M0_tissue_Hrabe_no_dispersion_model_fit(params, t);

result = asl_data-Y;
end
