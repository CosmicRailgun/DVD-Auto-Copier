# DVD-Auto-Copier
Auto DVD copying script designed for converting DVDs into MP4 files via HandbrakeCLI

Steps are as follow:

1. Waits for DVD to be loaded
2. Initializes DVD copy
3. Checks file size, determines if DVD is likely to be a movie
4. Using previous info, determines what threshold of filesize to keep and remove
  - ideally this would not be required, but HandbrakeCLI doesn't like to list to the titling flags so ahhhhhhhhhhhhhhhhhhhhhhhhhhh
5. Ejects DVD
6. Resets and waits for next DVD
