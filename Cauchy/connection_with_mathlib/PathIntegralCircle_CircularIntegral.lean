import Mathlib.Analysis.Analytic.Basic
import Mathlib.Topology.Basic
import Mathlib.Topology.Connected.Basic
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.Complex.ReImTopology
import Mathlib.Data.Complex.Basic
import Mathlib.MeasureTheory.Integral.CircleIntegral
import Cauchy.definitions.triangle
import Cauchy.definitions.subtriangle
import Cauchy.definitions.path_integrals
import Cauchy.definitions.domain
import Cauchy.helpers.triangle
import Cauchy.lemmas.zero_le_of_gt_zero
import Cauchy.connection_with_mathlib.circularPaths

open definitions unitInterval intervalIntegral

--This file is also some extra work not originally part of the project

--What we aim to do is make a connection between our code and Mathlib's code.
--For this we have already defined circular paths as C¹ paths as we have defined them.

--Now, what we do is show that circleIntegral (which is the only kind of complex path integral that has
--already been defined in Mathlib) is equivalent to PathIntegral1' when the path is a circle.

--This seems like an important result to have in order for our code to be more useful in the long run

theorem equivalentDefinitions (c:ℂ) (R:ℝ) (f : ℂ→ℂ ): pathIntegral1' f (circlePath c R) = circleIntegral f c R := by
unfold pathIntegral1'
unfold aux
unfold circlePath
unfold circleIntegral
unfold circleMap
simp[deriv_const_add', deriv_const_mul_field', Pi.mul_apply, Function.comp_apply, differentiableAt_const,smul_eq_mul]
have h1 : ∫ (θ : ℝ) in (0)..(2 * Real.pi),
    ↑R * deriv (fun x => Complex.exp (↑x * Complex.I)) θ * f (c + ↑R * Complex.exp (↑θ * Complex.I)) = ∫ (θ : ℝ) in (0*(2*Real.pi))..(1*(2 * Real.pi)),
    ↑R * deriv (fun x => Complex.exp (↑x * Complex.I)) θ * f (c + ↑R * Complex.exp (↑θ * Complex.I)) := by simp
rw[h1]
rw[← intervalIntegral.smul_integral_comp_mul_right]
rw[←intervalIntegral.integral_smul]
have congr : ∀ x ∈ (Set.uIcc (0:ℝ) (1)), f (c + ↑R * Complex.exp (↑x * Complex.I * 2 * ↑Real.pi)) *
      (↑R * deriv (fun t => Complex.exp (↑t * Complex.I * 2 * ↑Real.pi)) x) =  (2 * Real.pi) •
      (↑R * deriv (fun x:ℝ => Complex.exp (↑x * Complex.I)) (x * (2 * Real.pi)) *
        f (c + ↑R * Complex.exp (↑(x * (2 * Real.pi)) * Complex.I))) := by
        intro t th
        simp_all only [zero_mul, one_mul, ge_iff_le, zero_le_one, Set.uIcc_of_le, not_true, gt_iff_lt, Set.mem_Icc,
          Complex.ofReal_mul, Complex.ofReal_ofNat, Complex.real_smul]
        unhygienic with_reducible aesop_destruct_products
        have h11 : deriv (fun t => Complex.exp (↑t * Complex.I * 2 * ↑Real.pi)) t = (fun (θ:ℝ) =>(Complex.I*2*Real.pi)*  Complex.exp (↑θ * Complex.I*2*Real.pi)) t :=by
          have h1 : (fun θ:ℝ => Complex.exp (↑θ * Complex.I*2*Real.pi)) = (Complex.exp ∘ funct1) := by
            unfold funct1
            aesop
          rw[h1]
          rw[deriv.comp]
          rw[Complex.deriv_exp]
          have h2: deriv funct1 t = Complex.I*2*Real.pi := by
            unfold funct1
            repeat rw[deriv_mul_const]
            rw[Complex.deriv_coe]
            ring_nf
            norm_num
            apply Complex.differentiable_coe
            apply Differentiable.mul
            apply Complex.differentiable_coe
            exact differentiable_const Complex.I
            repeat apply Differentiable.mul
            apply Complex.differentiable_coe
            any_goals apply differentiable_const
          rw[h2]
          unfold funct1
          field_simp
          rw[mul_comm]
          unfold funct1
          apply  Differentiable.differentiableAt
          exact Complex.differentiable_exp
          unfold funct1
          repeat apply DifferentiableAt.mul
          apply  Differentiable.differentiableAt
          exact Complex.differentiable_coe
          any_goals apply differentiableAt_const
        rw[h11]
        rw[auxCircle''' (↑t * (2 * ↑Real.pi))]
        have aux1 : Complex.exp (↑t * (2 * ↑Real.pi) * Complex.I) = Complex.exp (↑t * Complex.I * 2 * ↑Real.pi) := by
          have aux11 : ↑t * (2 * ↑Real.pi) * Complex.I = ↑t * Complex.I * 2 * ↑Real.pi := by
            rw[mul_assoc]
            simp [mul_comm]
            ring
          rw[aux11]
        simp[aux1]
        simp [mul_comm]
        ring

have congr' :  Set.EqOn (fun x:ℝ => f (c + ↑R * Complex.exp (↑x * Complex.I * 2 * ↑Real.pi)) *
      (↑R * deriv (fun t => Complex.exp (↑t * Complex.I * 2 * ↑Real.pi)) x)) (fun x:ℝ => (2 * Real.pi) •
      (↑R * deriv (fun x:ℝ=> Complex.exp (↑x * Complex.I)) (↑x * (2 * Real.pi)) *
        f (c + ↑R * Complex.exp (↑(x * (2 * Real.pi)) * Complex.I)))) (Set.uIcc (0:ℝ) (1:ℝ)) := by
        unfold Set.EqOn
        intro x
        apply congr
exact (integral_congr congr')
