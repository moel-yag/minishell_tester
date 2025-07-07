#!/bin/bash

# Minishell Test Script
# Exit on any error
set -e

# Initialize
TMP_DIR="minishell_test_tmp"
mkdir -p $TMP_DIR
cd $TMP_DIR

# ------------------------------------------------------------------------------
# 1. COMPILATION CHECKS
# ------------------------------------------------------------------------------
echo -e "\n\033[1;36m[1. COMPILATION CHECKS]\033[0m"
echo "Testing Makefile rules..."
make -n > /dev/null
echo "Compiling minishell..."
make > /dev/null
[ -f minishell ] && echo "Compilation success" || { echo "Compilation failed"; exit 1; }

# ------------------------------------------------------------------------------
# 2. SIMPLE COMMANDS & GLOBAL VARIABLES
# ------------------------------------------------------------------------------
echo -e "\n\033[1;36m[2. SIMPLE COMMANDS & GLOBAL VARIABLES]\033[0m"
../minishell <<EOF
/bin/ls
EOF

../minishell <<EOF
  	 
EOF

# ------------------------------------------------------------------------------
# 3. ARGUMENTS HANDLING
# ------------------------------------------------------------------------------
echo -e "\n\033[1;36m[3. ARGUMENTS HANDLING]\033[0m"
../minishell <<EOF
/bin/ls -l
/bin/echo Hello World
EOF

# ------------------------------------------------------------------------------
# 4. BUILTINS
# ------------------------------------------------------------------------------
echo -e "\n\033[1;36m[4. BUILTINS]\033[0m"

# echo
../minishell <<EOF
echo
echo -n Hello
echo Hello World
EOF

# exit
../minishell <<EOF
exit 42
EOF
[ $? -eq 42 ] && echo "Exit status correct"

# env
../minishell <<EOF
env
EOF

# export/unset
../minishell <<EOF
export TEST_VAR=123
env | grep TEST_VAR
unset TEST_VAR
env | grep TEST_VAR
EOF

# cd/pwd
mkdir -p test_cd
../minishell <<EOF
cd test_cd
pwd
cd ..
pwd
cd non_existent_dir
EOF

# ------------------------------------------------------------------------------
# 5. EXIT STATUS
# ------------------------------------------------------------------------------
echo -e "\n\033[1;36m[5. EXIT STATUS]\033[0m"
../minishell <<EOF
/bin/ls non_existent
echo \$?
/bin/echo Success
echo \$?
EOF

# ------------------------------------------------------------------------------
# 6. SIGNALS (manual verification required)
# ------------------------------------------------------------------------------
echo -e "\n\033[1;36m[6. SIGNALS]\033[0m"
echo "--- MANUAL VERIFICATION REQUIRED ---"
echo "Test in terminal:"
echo "1. Ctrl-C: New prompt on new line"
echo "2. Ctrl-D: Exit shell"
echo "3. Ctrl-\\: No effect"
echo "4. Signals with blocking commands (cat | grep)"

# ------------------------------------------------------------------------------
# 7. QUOTES
# ------------------------------------------------------------------------------
echo -e "\n\033[1;36m[7. QUOTES]\033[0m"
../minishell <<'EOF'
echo "Hello   World"
echo 'Hello   World'
echo "$USER"
echo '$USER'
echo "cat | grep > file"
EOF

# ------------------------------------------------------------------------------
# 8. ENVIRONMENT VARIABLES
# ------------------------------------------------------------------------------
echo -e "\n\033[1;36m[8. ENVIRONMENT VARIABLES]\033[0m"
export TEST_VAR=123
../minishell <<'EOF'
echo $TEST_VAR
echo "$TEST_VAR"
echo $INVALID_VAR
EOF

# ------------------------------------------------------------------------------
# 9. REDIRECTIONS
# ------------------------------------------------------------------------------
echo -e "\n\033[1;36m[9. REDIRECTIONS]\033[0m"
../minishell <<EOF
echo Hello > out1
cat out1
echo World >> out1
cat out1
cat < out1
cat <<END
Multi-line
heredoc
END
EOF

# ------------------------------------------------------------------------------
# 10. PIPES
# ------------------------------------------------------------------------------
echo -e "\n\033[1;36m[10. PIPES]\033[0m"
../minishell <<EOF
ls -l | grep .c | wc -l
ls non_existent | grep .c
echo "Pipes Test" | cat -e
EOF

# ------------------------------------------------------------------------------
# 11. PATH HANDLING
# ------------------------------------------------------------------------------
echo -e "\n\033[1;36m[11. PATH HANDLING]\033[0m"
../minishell <<EOF
ls
unset PATH
ls
export PATH=/bin:/usr/bin
ls
EOF

# ------------------------------------------------------------------------------
# 12. ERROR HANDLING
# ------------------------------------------------------------------------------
echo -e "\n\033[1;36m[12. ERROR HANDLING]\033[0m"
../minishell <<EOF
invalid_command
ls non_existent
exit 999 | echo test
< non_existent_file
EOF

# Cleanup
cd ..
rm -rf $TMP_DIR
echo -e "\n\033[1;32mALL TESTS COMPLETED! Verify output above.\033[0m"
