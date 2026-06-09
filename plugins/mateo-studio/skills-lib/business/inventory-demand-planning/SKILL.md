---
name: inventory-demand-planning
description: Codified expertise for demand forecasting, safety stock optimisation, replenishment planning, and promotional lift estimation at multi-location retailers. Use when forecasting product demand, calculating optimal safety stock, planning inventory replenishment, or conducting ABC/XYZ segmentation.
risk: safe
source: https://github.com/ai-evos/agent-skills
date_added: "2026-02-27"
---

# Inventory Demand Planning

## Role and Context

Senior demand planner expertise for multi-location retail operations. Covers forecasting, safety stock, reorder logic, promotional planning, and ABC/XYZ inventory segmentation.

## When to Use

- Selecting and tuning forecasting methods for different demand patterns
- Calculating safety stock and service level targets
- Planning promotions, seasonal transitions, markdowns, and end-of-life strategies
- Investigating chronic stockouts, excess inventory, or forecast bias

---

## Forecasting Methods

| Demand Pattern | Primary Method | Use When |
|---------------|----------------|----------|
| Stable, high-volume | Weighted moving average (4-8 weeks) | Commodity staples |
| Trending (growth/decline) | Holt's double exponential smoothing | Consistent growth/decline items |
| Seasonal, repeating | Holt-Winters (multiplicative) | 52-week seasonal cycles |
| Intermittent / lumpy (>30% zeros) | Croston's method | Erratic demand items |
| Promotion-driven | Causal regression (baseline + lift layer) | Promo-heavy categories |
| New product (0-12 weeks) | Analogous item profile + lifecycle curve | No historical data |

---

## Safety Stock Formula

```
SS = Z × σ_d × √(LT + RP)
```
- Z = service level z-score
- σ_d = standard deviation of demand per period
- LT = lead time in periods
- RP = review period in periods

### Service Level Targets

| Segment | Target SL | Z-Score |
|---------|-----------|---------|
| AX (high-value, predictable) | 97.5% | 1.96 |
| AY (high-value, moderate variability) | 95% | 1.65 |
| AZ (high-value, erratic) | 92-95% | 1.41-1.65 |
| BX/BY | 95% | 1.65 |
| CX/CY | 90-92% | 1.28-1.41 |
| CZ | 85% | 1.04 |

---

## ABC/XYZ Classification

- **ABC** (Value): A = top 20% SKUs driving 80% revenue · B = next 30% driving 15% · C = bottom 50% driving 5%
- **XYZ** (Predictability): X = CV < 0.5 · Y = CV 0.5-1.0 · Z = CV > 1.0

**Policy Matrix:**
- AX → Automated replenishment, tight SS
- AZ → Human review every cycle (high-value but erratic)
- CX → Automated, generous review periods
- CZ → Candidates for discontinuation

---

## Key Performance Indicators

| Metric | Target | Red Flag |
|--------|--------|----------|
| WMAPE | < 25% | > 35% |
| Forecast bias | ±5% | > ±10% for 4+ weeks |
| In-stock rate (A-items) | > 97% | < 94% |
| Weeks of supply (aggregate) | 4-8 weeks | > 12 or < 3 |
| Excess inventory (>26 weeks supply) | < 5% of SKUs | > 10% of SKUs |

---

## Markdown Timing Decision

| Sell-Through at Season Midpoint | Action | Margin Recovery |
|---------------------------------|--------|-----------------|
| ≥ 80% of plan | Hold price | Full margin |
| 60-79% of plan | Take 20-25% markdown | 70-80% |
| 40-59% of plan | Take 30-40% markdown, cancel POs | 50-65% |
| < 40% of plan | Take 50%+ markdown, explore liquidation | 30-45% |

---

## Relevant for Maranatha

This skill is directly applicable to Suplidora Maranatha SRL for:
- Forecasting demand for pizza boxes and gastable materials
- Optimizing safety stock across product lines
- Planning replenishment cycles with suppliers
- ABC segmentation of the product catalog
