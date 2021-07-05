# DVD-Auto-Copier
Auto DVD copying script designed for converting DVDs into MP4 files via HandbrakeCLI

Steps are as follow:

1. Waits for DVD to be loaded
2. Initializes DVD copy
3. Checks file size, determines if DVD is likely to be a movie
4. Using previous info, determines what threshold of filesize to keep and remove
5. Ejects DVD
6. Resets and waits for next DVD
