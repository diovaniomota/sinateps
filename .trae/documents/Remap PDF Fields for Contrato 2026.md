I will update the `firebase/functions/index.js` file to remap the PDF fields to the new "Contrato 2026.pdf" layout.

Based on the screenshot, the current text is printing too low. I will shift all Y coordinates up by approximately 60-70 points and adjust the line spacing to match the new document structure.

**New Coordinate Estimates:**
- **Contratante Section:** Start Y around 730 (was 666).
- **Aluno Section:** Start Y around 574 (was 554).
- **Course Options:** Start Y around 508 (was 497).
- **Financial/Dates:** Shifted up similarly.

I will also refine the X coordinates where labels seem to have shifted (e.g., CPF, RG).