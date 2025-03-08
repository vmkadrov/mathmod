using DifferentialEquations, Plots

k = 16.4

r0 = k/5.2
r0_2 = k/3.2
theta0 = (0.0, 2*pi) 
theta0_2 = (-pi, pi)

fi = 3*pi/4;
t = (0, 50);

x(t) = tan(fi)*t;

f(r, p, t) = r/sqrt(16.64)

prob = ODEProblem(f, r0, theta0)

sol = solve(prob, saveat = 0.01)    

plot(sol.t, sol.u, proj=:polar, lims=(0, 15), label = "Траектория движения катера")


ugol = [fi for i in range(0,15)]

x_lims = [x(i) for i in range(0,15)]

plot!(ugol, x_lims, proj=:polar, lims=(0, 15), label = "Траектория движения лодки")

# 2 случай

prob_2 = ODEProblem(f, r0_2, theta0_2)

sol_2 = solve(prob_2, saveat = 0.01)

plot(sol_2.t, sol_2.u, proj=:polar, lims=(0,15), label = "Траектория движения катера")

plot!(ugol, x_lims, proj=:polar, lims=(0, 15), label = "Траекория движения лодки")


y(x)=(r0*exp(x/sqrt(16.64)))

y(fi + pi)

y2(x)=(r0_2*exp((x/sqrt(16.64))+(pi/sqrt(16.64))))

y2(fi - pi)
