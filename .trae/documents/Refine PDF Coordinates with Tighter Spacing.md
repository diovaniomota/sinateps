I will update `firebase/functions/index.js` with tighter line spacing (13pts) and adjusted starting coordinates to match the dense layout of the new PDF.

**New Coordinates Strategy:**
1.  **Contratante Section:**
    - `yStart` = 752 (Unchanged, seems correct for Line 1).
    - `lineHeight` = 13 (Reduced from 16 to match the visual gap).
    - This will effectively raise the lower lines (Address, City, etc.) which were "falling" onto the lines below them.

2.  **Aluno Section:**
    - Raise `yAlunoStart` to **618** (was 605) to clear the "CPF ou RG" line.

3.  **Curso Section:**
    - Raise `yOpcaoStart` to **553** (was 538).

4.  **Payment/Footer:**
    - The "X" marks in the table seemed okay, but I'll nudge them up slightly (5pts) to be safe, as the whole document seems to have shifted up.
    - I will check the `primeiraParcela` and `descontoRS` coordinates to ensure they don't overlap the table borders.

I will apply these changes and deploy.