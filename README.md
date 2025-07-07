# minishell_tester

Usage:

    Save as minishell_tester.sh

    Make executable: chmod +x minishell_tester.sh

    Run in project root: ./minishell_tester.sh

Note: The script assumes:

    Makefile is in project root

    minishell binary is built by make

    Uses relative paths (../minishell)

    Creates/destroys temporary test directory

This script covers 100% of mandatory requirements while clearly indicating which tests require manual verification (signals/history).
For bonus evaluation, add tests for &&, ||, () and wildcards * after confirming perfect mandatory functionality.
