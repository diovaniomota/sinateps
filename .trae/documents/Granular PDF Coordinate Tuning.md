I will perform a granular adjustment of the PDF coordinates based on the latest screenshot to fix the overlaps and misalignments.

**Detailed Analysis of the Screenshot:**

1.  **Contratante (Line 1):** The name "Dio" is printing ON the line, but maybe slightly too high or low depending on baseline. It looks *okay* but could be nudged.
2.  **CPF (Line 2):** "649.446..." is overlapping the "Filiacao" label. It is **TOO LOW**.
    - *Correction:* Move UP by ~8-10 points.
3.  **Filiacao (Line 3):** Overlapping "Sexo". **TOO LOW**.
    - *Correction:* Move UP.
4.  **Telefones (Line 8):** "Tubarao" (City?) and "+55" are overlapping.
    - *Observation:* The field "Cidade" seems to be printing "Monte Castelo" correctly, but "Tubarao" is in the "Telefones" slot? No, "Tubarao" is in the "Cidade" slot in the screenshot?
    - Wait, the screenshot shows:
        - Line 7 (Cidade/CEP/UF): "Monte Castelo" | "88702-503" | "SC". This line looks aligned horizontally but vertically it's overlapping the line below.
        - Line 8 (Telefones): "+55...". It is overlapping the "2. USUÁRIO" label. **TOO LOW**.

**Root Cause:**
The `lineHeight` of 13 might be correct for *spacing between lines*, but the **Starting Y (`yStart`) is still too low for the subsequent lines**, or the accumulation of `lineHeight` isn't matching the document's grid.

**New Strategy - Absolute Coordinates (Safety First):**
Instead of relying on `yStart - lineHeight`, I will define **absolute Y coordinates** for each visual line to ensure they land exactly where they should.

**Estimated Coordinates (from bottom 0 to top 842):**
- **1. Contratante:** Y = 754 (Nudge up 2pt)
- **2. CPF/RG:** Y = 740 (Gap 14) -> Needs to clear "Filiacao".
- **3. Filiacao:** Y = 726 (Gap 14) -> Needs to clear "Sexo".
- **4. Sexo:** Y = 712
- **5. Endereco:** Y = 698
- **6. Bairro:** Y = 684
- **7. Cidade:** Y = 670
- **8. Telefones:** Y = 656

**2. Usuário (Aluno):**
- **Nome:** Y = 615
- **CPF/RG:** Y = 600
- **Telefone:** Y = 585

**Opção de Curso:**
- **Checkbox/Nome:** Y = 550
- **Outro/Qual:** Y = 535
- **Indicação:** Y = 520

**Table X Marks:**
- The "X" in the payment table is landing on the text below.
- Need to Shift Y UP by ~10 points.

**Action:**
I will rewrite the coordinate logic in `index.js` to use these explicit, manually tuned values.