I will perform a precise coordinate adjustment based on the latest screenshot to fix the "messy" layout immediately.

**Analysis of the Screenshot vs. Current Code:**
1.  **Contratante (Line 1):** The name "Diovanio Mota" is printing WAY below the line "1. CONTRATANTE : ______". It needs to go UP significantly.
2.  **CPF/RG (Line 2):** "46.464..." is printing over the "Filiacao" label. It needs to go UP.
3.  **General Trend:** Everything is printing roughly 2-3 lines (approx 30-50 points) too low relative to its label. The previous adjustment of `yStart = 730` was likely in the right direction but the spacing (`lineHeight`) or the initial anchor is still off, or the previous deploy didn't fully take effect/cache issues (though logs showed success).

**Action Plan:**
1.  **Drastic Y Adjustment:** I will increase the `yStart` further. The visual gap suggests the text is landing on the line *below* where it should be.
    - Current `yStart` (Contratante Name) = 730.
    - Visually, "Diovanio Mota" is on the "Filiacao" line. It needs to jump up one full line height + margin.
    - New Estimate: `yStart = 745` (Moving up).
    - **CRITICAL:** The screenshot shows "Diovanio Mota" (Name) appearing near "Filiacao" label.
    - Wait, if "Diovanio Mota" is near "Filiacao", and "Filiacao" is logically below "Contratante", then the text is printing TOO LOW.
    - My previous change set `yStart = 730`. If it's still too low, I need to increase Y (in PDF coordinates, 0 is bottom, higher is top).
    - I will bump `yStart` to **752**.

2.  **Line Height Tuning:** The gap between lines seems slightly tighter in the new doc. I'll reduce `lineHeight` from 18 to **16**.

3.  **Specific Section Tweaks:**
    - **Aluno:** The "Nome do Aluno" fill is landing on "CPF ou RG". Needs to go UP.
    - **Payment:** The "X" marks are landing correctly inside the boxes? No, "X" for payment is landing on the text below it. Needs to go UP.

**Revised Coordinates (Estimates):**
- **Contratante Name:** Y = 752 (was 730)
- **CPF/RG:** Y = 736 (was 712)
- **Filiacao:** Y = 720 (was 694)
- ... and so on, cascading this ~20pt shift upwards.

I will apply these changes to `firebase/functions/index.js` and deploy immediately.