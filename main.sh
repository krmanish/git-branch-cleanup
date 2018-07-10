#!/usr/bin/env bash

CUR_DIR=$PWD
source $CUR_DIR/config.conf
LOG_FILE_NAME=$CUR_DIR/$LOG_FILE_NAME
PREFIX_LENGTH=$CUR_DIR/$PREFIX_LENGTH
FEATURE_BRANCH_PREFIX=$CUR_DIR/$FEATURE_BRANCH_PREFIX

# Create log file if does not exists
if [ ! -f $LOG_FILE_NAME ]; then
    touch $LOG_FILE_NAME
fi

args=$@
error=true
message="\n\n--- GIT Branch Clean-up started at $cur_dt ----"
cur_dt=$(date '+%Y-%m-%d %H:%M:%S')

# Must have Dirname
if [ $# -eq 0 ]; then
    message="$message\n\tError: First argument must be a git root dir"
elif [ ! -d "$1" ]; then
    message="$message\n\tError: Invalid dir $1"
else
    message="$message\n\tPerform Git Branch Clean up on GIT DIR $1"
    
    # Switch to dir
    cd "$1"

    # If its a git repo
    if [ -d .git ]; then
        error=false
    else
        message="$message\n\tError: Not a Git repo"
    fi
fi

if [ "$error" = true ]; then
    message="$message\n\n--- GIT Branch Clean-up End With Error at $cur_dt ---"
    echo -e $message >> $LOG_FILE_NAME
    exit
fi

# Call git cleanup script
script_file=$CUR_DIR/git-branch-cleanup
if [ ! -x "$script_file" ]; then
    echo "File is not executable.. make it so"
    chmod +x $script_file
fi

. $CUR_DIR/git-branch-cleanup

cur_dt=$(date '+%Y-%m-%d %H:%M:%S')
message="$message\n--- GIT Branch Clean-up End at $cur_dt ---"
echo -e $message >> $LOG_FILE_NAME

