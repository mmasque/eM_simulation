function [kl_divergence, kl_uncertainty] = kl_divergence(P, Q, uncertainty)
    %compute kl divergence of 2 probability distributions: P, Q
    %computing kl divergence of Q from P.
    if length(P) ~= length(Q)
        error("Probability distributions have different number of elements");
    end
    
    % compute divergence
    kl_divergence_matrix = P.*(log(P) - log(Q));
    kl_divergence = sum(kl_divergence_matrix);
    
    % uncertainty calculations
    rel_uncertainty_P = uncertainty./P;
    uncertainty_logP = uncertainty./P;
    uncertainty_logQ = uncertainty./Q;
    log_uncertainty = uncertainty_logP + uncertainty_logQ;
    rel_log_uncertainty = abs(log_uncertainty./(log(P) - log(Q)));
    overall_rel_uncertainty = rel_uncertainty_P + rel_log_uncertainty;
    overall_abs_uncertainty = overall_rel_uncertainty .* kl_divergence;
    kl_uncertainty = sum(overall_abs_uncertainty);
end