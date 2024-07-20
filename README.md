# Scallopverse

[![Build Status](https://github.com/gszep/Scallopverse.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/gszep/Scallopverse.jl/actions/workflows/CI.yml?query=branch%3Amain)

Let's begin with the Navier–Stokes and continuity equations for the velocity field $\mathbf{u}$ of an incompressible homogenous fluid

$$
\rho\left(\frac{\partial}{\partial t}+\mathbf{u}\cdot\nabla-\nu\nabla^2\right)\mathbf{u}+\nabla p=0
\qquad \nabla\cdot\mathbf{u}=0
$$

Considering a two dimensional flow $\mathbf{u}=(u,v,0)$ the pressure term $\nabla p$ and density $\rho$ can be eliminated by differentiating the equation for $u$ with respect to $y$ and $v$ with respect to $x$ and subtracting them from each other, yielding

$$
\left(\frac{\partial}{\partial t}+\mathbf{u}\cdot\nabla-\nu\nabla^2\right)\left(\frac{\partial u}{\partial y}-\frac{\partial v}{\partial x}\right)=0
$$
Without loss of generality we can let the divergence-free velocity field be defined by a stream function $\psi$

$$
\mathbf{u}=\nabla\times(\hat{\mathbf{z}}\psi)\\
\quad\\
u=\frac{\partial\psi}{\partial y}
\qquad
v=-\frac{\partial\psi}{\partial x}
$$

Substitution of $\psi$ into the two-dimensional Navier-Stokes equation yields

$$
\left(\frac{\partial}{\partial t}+\left(\nabla\times\left(\hat{\mathbf{z}}\psi\right)\right)\cdot\nabla-\nu\nabla^2\right)\nabla^2\psi=0
$$

