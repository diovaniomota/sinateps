I will completely overhaul the Y-coordinates in `firebase/functions/index.js` to fix the massive misalignment.

**Diagnosis:**
1.  **Top Section (Contratante):** The text is printing **too high** and with **insufficient spacing** between lines. The CPF is printing on top of the Name line.
    - **Fix:** I will lower the starting Y slightly and significantly increase the gap between lines (from 13pt to ~18-20pt).
2.  **Bottom Section (Clauses/Payment):** The text is printing **WAY too high**, overwriting the contract text body.
    - **Fix:** I will revert the bottom section coordinates closer to their original values (around Y=390 instead of 475), moving them down by ~85 points.

**New Coordinate Map (Targeting "Sit on the Line"):**
- **Contratante:** Y=745 (Down from 754)
- **CPF:** Y=725 (Gap 20)
- **Filiacao:** Y=705 (Gap 20)
- **Sexo:** Y=687 (Gap 18)
- **Endereço:** Y=669 (Gap 18)
- **Bairro:** Y=651 (Gap 18)
- **Cidade:** Y=633 (Gap 18)
- **Telefone:** Y=615 (Gap 18)
- **Aluno Name:** Y=575 (Section Gap)
- **Aluno CPF:** Y=557
- **Aluno Tel:** Y=539
- **Curso:** Y=505
- **Disposições (Bottom):** Y=390 (Reverting huge upward shift)

I will apply these changes and deploy immediately.