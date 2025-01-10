# NACA0012_Data_Generator
Generates 2560 .geo NACA0012 variants and correspondingly their background (.bac) and mesh files (.dat) for batch input to IMPACT HPC (Swansea University HPC)

# **Predictions using Geometric Parameters**

## **Overview**
This project involves generating **morphed configurations** of the NACA0012 aerofoil profile, referred to as the **baseline (undeformed) configuration**. The objective is to perturb the aerofoil geometry by varying control points using **Non-Uniform Rational B-Splines (NURBS)** and then compute surface integral quantities. Sampling of the design space is carried out using a **low-discrepancy sampling technique (Halton sequence)** to ensure uniform sampling across the space.

The **IGES-to-FLITE2D integration framework**, developed by Prof. R. Sevilla, enables the conversion of `.iges` files to `.geo` files for the **IMPACT HPC** platform.

---

## **Methodology**

### **1. Geometry Generation**

#### **Geometrical Representation of the Baseline Profile**
The geometry of the baseline NACA0012 profile is represented using **NURBS curves**. A NURBS curve is defined parametrically as:

\[
\mathbf{C}(u) = \frac{\sum_{i=0}^{n} \mathcal{N}_{i,p}(u) \mathbf{P}_i w_i}{\sum_{i=0}^{n} \mathcal{N}_{i,p}(u) w_i}
\]

where:
- \( \mathcal{N}_{i,p}(u) \) are B-spline basis functions of degree \( p \).
- \( \mathbf{P}_i \) are the control points.
- \( w_i \) are the weights corresponding to each control point.

---

### **B-Spline Basis Function Definition**
The B-spline basis functions \( \mathcal{N}_{i,p}(u) \) are recursively defined as:

1. **For \( p = 0 \)** (piecewise constant basis functions):
\[
\mathcal{N}_{i,0}(u) =
\begin{cases}
1, & \text{if } \lambda_i \leq u < \lambda_{i+1} \\
0, & \text{otherwise}
\end{cases}
\]

2. **For \( p > 0 \)** (higher-degree basis functions):
\[
\mathcal{N}_{i,p}(u) = \frac{u - \lambda_i}{\lambda_{i+p} - \lambda_i} \mathcal{N}_{i,p-1}(u) + \frac{\lambda_{i+p+1} - u}{\lambda_{i+p+1} - \lambda_{i+1}} \mathcal{N}_{i+1,p-1}(u)
\]

where \( \{\lambda_0, \lambda_1, \ldots, \lambda_m\} \) is the **knot vector** that defines how the curve interpolates or approximates the control points.

---

### **Control Points for the Baseline NACA0012 Profile**
The baseline NACA0012 profile is defined by 8 control points. Curves 4 and 5 represent the **upper and lower surfaces** of the aerofoil, respectively.

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

### **2. Control Point Perturbation Limits**
To generate morphed aerofoil profiles, the control points are perturbed within predefined bounds along the **x** and **y** axes. The leading and trailing edge points are kept fixed to ensure the aerofoil remains non-dimensional.

#### **Perturbation Limits:**

| **Control Pt** | **ΔX (upper surface)** | **ΔY (upper surface)** | **ΔX (lower surface)** | **ΔY (lower surface)** |
|----------------|------------------------|------------------------|-----------------------|-----------------------|
| 2              | \(4.3 \times 10^{-2}\)  | \(2.2 \times 10^{-2}\)  | N/A                   | N/A                   |
| 3              | \(4.3 \times 10^{-2}\)  | \(2.2 \times 10^{-2}\)  | \(4.3 \times 10^{-2}\)| \(2.2 \times 10^{-2}\) |
| 4              | \(3.1 \times 10^{-2}\)  | \(1.5 \times 10^{-2}\)  | \(4.5 \times 10^{-2}\)| \(2.3 \times 10^{-2}\) |
| 5              | \(2.5 \times 10^{-2}\)  | \(1.2 \times 10^{-2}\)  | \(3.9 \times 10^{-5}\)| \(1.9 \times 10^{-5}\) |
| 6              | \(1.5 \times 10^{-2}\)  | \(7.4 \times 10^{-3}\)  | \(3.2 \times 10^{-2}\)| \(1.6 \times 10^{-2}\) |
| 7              | \(5.3 \times 10^{-3}\)  | \(2.7 \times 10^{-3}\)  | \(1.9 \times 10^{-2}\)| \(9.6 \times 10^{-3}\) |

---

### **3. Sampling the Design Space**
The **Halton sequence** is used to generate uniformly distributed samples for perturbations of the control points. This ensures that the perturbations cover the design space evenly.

---

## **Project Structure**

```plaintext
/geometry-prediction
│   README.md                    # Documentation
│   geometry_generation.ipynb     # Notebook for geometry generation
│
├── data/
│   └── baseline_profile.iges     # Baseline IGES file
│   └── morphed_profiles.geo      # Morphed geometry output files
├── images/
│   └── baseline_geometry.png     # Image of baseline NACA0012 geometry
│   └── perturbed_geometry.png    # Image of perturbed geometry
└── utils/
    └── sampling_functions.py     # Halton sequence implementation
```
