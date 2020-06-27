module JuliaTestPackage

using CmdStan

export main_run

function main_run(N::Int=100)

    CmdStanModel = """

    data {
        int<lower=0> N;
        vector[N] y;
    }

    parameters{
        real mu;
        real<lower=0> sigma;
    }

    model{
        mu ~ normal(0,1);
        sigma ~ cauchy(0,5);
        y ~ normal(mu,sigma);
    }
    """

    input = Dict("N"=>N,"y"=>rand(N));
    method = Variational(; iter = 100, output_samples = 500)
    stan_model = Stanmodel(method;
        name = "test_model",
        model = CmdStanModel,
        nchains = 1,
        pdir = pwd(),
        output_format = :array,
    )
    rc, samples_by_chain, cnames = stan(stan_model, input, summary = false)

end

end # module
