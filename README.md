# NACA0012_Data_Generator
Generates 2560 .geo NACA0012 variants and correspondingly their background (.bac) and mesh files (.dat) for batch input to IMPACT HPC (Swansea University HPC)

# **Predictions using Geometric Parameters**

## **Overview**
This project involves generating **morphed configurations** of the NACA0012 aerofoil profile, referred to as the **baseline (undeformed) configuration**. The objective is to perturb the aerofoil geometry by varying control points using **Non-Uniform Rational B-Splines (NURBS)** and compute surface integral quantities. Sampling of the design space is carried out using a **low-discrepancy sampling technique (Halton sequence)** to ensure uniform sampling across the space.

The **IGES-to-FLITE2D integration framework**, developed by Prof. R. Sevilla, enables the conversion of `.iges` files to `.geo` files for the **IMPACT HPC** platform.

---

## **Methodology**

### **1. Geometry Generation**

#### **Geometrical Representation of the Baseline Profile**
The geometry of the baseline NACA0012 profile is represented using **NURBS curves**. A NURBS curve is defined parametrically as:

![equation](https://latex.codecogs.com/svg.image?\color{White}\mathbf{C}(u)=\frac{\sum_{i=0}^{n}\mathcal{N}_{i,p}(u)\mathbf{P}_iw_i}{\sum_{i=0}^{n}\mathcal{N}_{i,p}(u)w_i})

where:
- \( \mathcal{N}_{i,p}(u) \) are B-spline basis functions of degree \( p \).
- \( \mathbf{P}_i \) are the control points.
- \( w_i \) are the weights corresponding to each control point.

---

### **B-Spline Basis Function Definition**
The B-spline basis functions \( \mathcal{N}_{i,p}(u) \) are recursively defined as:

1. **For \( p = 0 \)** (piecewise constant basis functions):
   ![equation](https://latex.codecogs.com/svg.image?\color{White}\mathcal{N}_{i,0}(u)=\begin{cases}1,&\lambda_i\leq%20u<\lambda_{i+1}\\0,&\text{otherwise}\end{cases})

2. **For \( p > 0 \)** (higher-degree basis functions):
   ![equation](https://latex.codecogs.com/svg.image?\color{White}\mathcal{N}_{i,p}(u)=\frac{u-\lambda_i}{\lambda_{i+p}-\lambda_i}\mathcal{N}_{i,p-1}(u)+\frac{\lambda_{i+p+1}-u}{\lambda_{i+p+1}-\lambda_{i+1}}\mathcal{N}_{i+1,p-1}(u))

where \( \{ \lambda_0, \lambda_1, \ldots, \lambda_m \} \) is the **knot vector**.

---

### **2. Control Points for the Baseline NACA0012 Profile**
The baseline NACA0012 profile is defined by 8 control points. Curves 4 and 5 represent the **upper and lower surfaces** of the aerofoil.

#### **Baseline Control Point Coordinates:**

| **Control Pt** | **X-Coordinate (+)** | **Y-Coordinate (+)** | **X-Coordinate (-)** | **Y-Coordinate (-)** |
|----------------|----------------------|----------------------|---------------------|---------------------|
| 1              | 0.5000                | 0.0000               | 0.5000              | 0.0000              |
| 2              | 0.4326                | 0.0100               | 0.4326              | -0.0100             |
| 3              | 0.1806                | 0.0404               | 0.1806              | -0.0404             |
| 4              | -0.0425               | 0.0571               | -0.0425             | -0.0571             |
| 5              | -0.2484               | 0.0627               | -0.2484             | -0.0627             |
| 6              | -0.4397               | 0.0474               | -0.4397             | -0.0474             |
| 7              | -0.5000               | 0.0175               | -0.5000             | -0.0175             |
| 8              | -0.5000               | 0.0000               | -0.5000             | 0.0000              |

---

### **3. Control Point Perturbation Limits**
To generate morphed aerofoil profiles, control points are perturbed within predefined bounds along the **x** and **y** axes. The leading and trailing edge points are kept fixed to ensure the aerofoil remains non-dimensional.

#### **Perturbation Limits Table**

| **Control Pt** | **ΔX (upper surface)** | **ΔY (upper surface)** | **ΔX (lower surface)** | **ΔY (lower surface)** |
|----------------|------------------------|------------------------|-----------------------|-----------------------|
| 2              | ![equation](https://latex.codecogs.com/svg.image?\color{White}4.3%20\times%2010^{-2}) | ![equation](https://latex.codecogs.com/svg.image?\color{White}2.2%20\times%2010^{-2}) | N/A | N/A |
| 3              | ![equation](https://latex.codecogs.com/svg.image?\color{White}4.3%20\times%2010^{-2}) | ![equation](https://latex.codecogs.com/svg.image?\color{White}2.2%20\times%2010^{-2}) | ![equation](https://latex.codecogs.com/svg.image?\color{White}4.3%20\times%2010^{-2}) | ![equation](https://latex.codecogs.com/svg.image?\color{White}2.2%20\times%2010^{-2}) |
| 4              | ![equation](https://latex.codecogs.com/svg.image?\color{White}3.1%20\times%2010^{-2}) | ![equation](https://latex.codecogs.com/svg.image?\color{White}1.5%20\times%2010^{-2}) | ![equation](https://latex.codecogs.com/svg.image?\color{White}4.5%20\times%2010^{-2}) | ![equation](https://latex.codecogs.com/svg.image?\color{White}2.3%20\times%2010^{-2}) |
| 5              | ![equation](https://latex.codecogs.com/svg.image?\color{White}2.5%20\times%2010^{-2}) | ![equation](https://latex.codecogs.com/svg.image?\color{White}1.2%20\times%2010^{-2}) | ![equation](https://latex.codecogs.com/svg.image?\color{White}3.9%20\times%2010^{-5}) | ![equation](https://latex.codecogs.com/svg.image?\color{White}1.9%20\times%2010^{-5}) |
| 6              | ![equation](https://latex.codecogs.com/svg.image?\color{White}1.5%20\times%2010^{-2}) | ![equation](https://latex.codecogs.com/svg.image?\color{White}7.4%20\times%2010^{-3}) | ![equation](https://latex.codecogs.com/svg.image?\color{White}3.2%20\times%2010^{-2}) | ![equation](https://latex.codecogs.com/svg.image?\color{White}1.6%20\times%2010^{-2}) |
| 7              | ![equation](https://latex.codecogs.com/svg.image?\color{White}5.3%20\times%2010^{-3}) | ![equation](https://latex.codecogs.com/svg.image?\color{White}2.7%20\times%2010^{-3}) | ![equation](https://latex.codecogs.com/svg.image?\color{White}1.9%20\times%2010^{-2}) | ![equation](https://latex.codecogs.com/svg.image?\color{White}9.6%20\times%2010^{-3}) |

---

## **4. Sampling the Design Space**
- The **Halton sequence** is used to generate uniformly distributed samples for perturbations of the control points.
- The sampling process ensures that the perturbations cover the design space evenly for each control point.

---

## **Key Insights**
1. **Baseline Geometry Representation:**  
   The baseline geometry is accurately defined using **NURBS curves**, enabling smooth and flexible control over the aerofoil shape.
2. **Perturbation Methodology:**  
   Control points are perturbed within the specified bounds along both **x** and **y** directions. This variation results in a wide range of morphed aerofoil profiles.
3. **Halton Sampling:**  
   The **Halton sequence** ensures low-discrepancy sampling, providing an even distribution across the design space.
