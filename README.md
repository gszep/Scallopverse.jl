# Scallopverse

[![Build Status](https://github.com/gszep/Scallopverse.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/gszep/Scallopverse.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![codecov](https://codecov.io/gh/gszep/Scallopverse.jl/graph/badge.svg?token=WcZxKKZZcO)](https://codecov.io/gh/gszep/Scallopverse.jl)

## Theoretical Background
Let's begin with the Navier–Stokes and continuity equations for a two-dimensional velocity field $\mathbf{u}=\hat{\mathbf{x}}u+\hat{\mathbf{y}}v$ of an incompressible homogenous non-Newtonian fluid with viscosity law $\eta(\dot\gamma)$ that is only a function of a scalar shear rate $\dot\gamma$
$$
\rho\left(\frac{\partial\mathbf{u}}{\partial t}+\left(\mathbf{u}\cdot\nabla\right)\mathbf{u}\right)
-\nabla\cdot\left(2\eta\mathbf{D}\right)+\nabla p=0\\
\mathrm{where}\quad
\nabla\cdot\mathbf{u}=0\\
\quad\\
\mathbf{D}:=
\frac{1}{2}\begin{pmatrix}
2\frac{\partial u}{\partial x} & 
\frac{\partial v}{\partial x}+\frac{\partial u}{\partial y} \\
\frac{\partial v}{\partial x}+\frac{\partial u}{\partial y} &
2\frac{\partial v}{\partial y}
\end{pmatrix}\\
\quad\\
\dot\gamma:=\sqrt{
 \left(\frac{\partial u}{\partial x}\right)^2
+\frac{1}{2}\left(\frac{\partial v}{\partial x}+\frac{\partial u}{\partial y}\right)^2
+\left(\frac{\partial v}{\partial y}\right)^2
}
$$
Taking the curl of this vector equation to obtain a scalar equation for the vorticity $\omega$ allows us to eliminate the pressure term $\nabla p$ and vortex stretching term $\left(\boldsymbol{\omega}\cdot\nabla\right)\mathbf{u}$ since partial derivatives with respect to $z$ vanish
$$
\rho\left(\frac{\partial}{\partial t}+u\frac{\partial}{\partial x}+v\frac{\partial}{\partial y}\right)\omega=\nabla\times\nabla\cdot\left(2\eta\mathbf{D}\right)
\quad\mathrm{where}\quad \omega=\frac{\partial v}{\partial x}-\frac{\partial u}{\partial y}
$$
Without loss of generality we can let the divergence-free velocity field be defined by a stream function $\psi$
$$
u=\frac{\partial\psi}{\partial y}
\qquad
v=-\frac{\partial\psi}{\partial x}
$$
yielding scalar non-linear equations in the vorticity $\omega$ and stream function $\psi$
$$
\omega=-\left(\frac{\partial^2}{\partial x^2}+\frac{\partial^2}{\partial y^2}\right)\psi\\
\rho\left(\frac{\partial}{\partial t}+\frac{\partial\psi}{\partial y}\frac{\partial}{\partial x}-\frac{\partial\psi}{\partial x}\frac{\partial}{\partial y}\right)\omega=\nabla\times\nabla\cdot\left(2\eta\mathbf{D}\right)
\quad\\\quad\\
\mathbf{D}:=
\frac{1}{2}\begin{pmatrix}
2\frac{\partial^2}{\partial x \partial y} & 
\frac{\partial^2}{\partial y^2}-\frac{\partial^2}{\partial x^2} \\
\frac{\partial^2}{\partial y^2}-\frac{\partial^2}{\partial x^2} &
-2\frac{\partial^2}{\partial x \partial y} 
\end{pmatrix}\psi\\
\quad\\
\dot\gamma:=\sqrt{
 2\left(\frac{\partial^2\psi}{\partial x \partial y}\right)^2
+\frac{1}{2}\left(\frac{\partial^2\psi}{\partial y^2}-\frac{\partial^2\psi}{\partial x^2}\right)^2
}
$$
Let's try to simplify the ghastly viscosity term
$$
\nabla\times\nabla\cdot\left(2\eta\mathbf{D}\right)=
\frac{\partial}{\partial x}\left(
 \frac{\partial(2\eta[\mathbf{D}]_{xy})}{\partial x}
+\frac{\partial(2\eta[\mathbf{D}]_{yy})}{\partial y}
\right)-
\frac{\partial}{\partial y}\left(
 \frac{\partial(2\eta[\mathbf{D}]_{xx})}{\partial x}
+\frac{\partial(2\eta[\mathbf{D}]_{yx})}{\partial y}
\right)\\
=
\left(
 \frac{\partial^2}{\partial x^2}
-\frac{\partial^2}{\partial y^2}\right)\left(2\eta[\mathbf{D}]_{xy}\right)
+
2\frac{\partial^2}{\partial x \partial y}\left(
\eta[\mathbf{D}]_{yy}
-\eta[\mathbf{D}]_{xx}
\right)\\
\quad\qquad=
-\left(
 \frac{\partial^2}{\partial x^2}
-\frac{\partial^2}{\partial y^2}\right)\left(
 \eta\left(
 \frac{\partial^2}{\partial x^2}
-\frac{\partial^2}{\partial y^2}\right)\psi
\right)
-4\frac{\partial^2}{\partial x \partial y}\left(
 \eta\frac{\partial^2 \psi}{\partial x \partial y }
\right)\\
\qquad\qquad\quad
=\left(\frac{\partial^2}{\partial x^2}+\frac{\partial^2}{\partial y^2}\right)\left(\eta\omega\right)
+2\left(
  \frac{\partial^2\psi}{\partial^2 x}\frac{\partial^2\eta}{\partial^2 y}
-2\frac{\partial^2\psi}{\partial x\partial y}\frac{\partial^2\eta}{\partial x\partial y}
+ \frac{\partial^2\psi}{\partial^2 y}\frac{\partial^2\eta}{\partial^2 x}
\right)
$$
## Numerical Integration
We begin with the two dimensional velocity field $(u,v)$ at the start time $t$ and grid points $(x,y)$. Lets assume a uniform discretization over the grid with spacing $\Delta$
#### 1. Compute the vorticity $\omega$ from velocity field
This can be done with a central finite-difference stencil on the grid
$$
\omega=\frac{v_{x+\Delta}-v_{x-\Delta}-u_{y+\Delta}+u_{y-\Delta}}{2\Delta}
$$
#### 2. Solve poisson equation for $\psi$ starting with initial guess $\psi'$
This can be done with iterative methods
$$
\nabla^2\psi=-\omega
$$
#### 3. Perform time step for vorticity $\omega$ and store previous $\psi$
$$
\omega\leftarrow\omega+
\left(\nabla^2\left(\eta\omega\right)
+
2\frac{\psi_x\eta_y-2\psi_{xy}\eta_{xy}+\eta_x\psi_y}{\Delta^4}
-\rho\frac{\omega_{xy}}{2\Delta }\right)\frac{\Delta t}{\rho}
\qquad
\psi'\leftarrow\psi
\\\quad\\
\mathrm{where}\quad \omega_{xy}:=\omega_{x+\Delta}u-\omega_{x-\Delta}u+\omega_{y+\Delta}v-\omega_{y-\Delta}v
$$
#### 4. Repeat step 2.