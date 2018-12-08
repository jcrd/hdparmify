#!/bin/sh

test_description='Test hdparmify'

. ./sharness/sharness.sh

# abort if `iniq` dependency is not found
command -v iniq > /dev/null || exit 1

export PATH="$SHARNESS_TEST_DIRECTORY/bin:$PATH"

export HDPARMIFY_RUNDIR="$SHARNESS_TRASH_DIRECTORY"

CONF="$SHARNESS_TEST_DIRECTORY"/test.conf

test_expect_success 'Ensure hdparmify reset works' '
touch "$HDPARMIFY_RUNDIR"/dev-sda &&
hdparmify reset &&
test ! -e "$HDPARMIFY_RUNDIR"/dev-sda
'

test_expect_success 'Apply to all (now)' '
test "$(hdparmify -nc $CONF apply)" = "-B 1 -M 128 -S 4 -y /dev/sda
-S 1 -Y /dev/sdb" &&
test "$(cat "$HDPARMIFY_RUNDIR"/dev-sda)" = "[/dev/sda]
power_management=1
acoustic_management=128
standby_timeout=4
power_mode=standby" &&
test "$(cat "$HDPARMIFY_RUNDIR"/dev-sdb)" = "[/dev/sdb]
standby_timeout=1
power_mode=sleep" &&
hdparmify reset
'

# sleeps before printing sda's options, which should now be second
test_expect_success 'Apply to all (with delays)' '
test "$(hdparmify -c $CONF apply)" = "-S 1 -Y /dev/sdb
-B 1 -M 128 -S 4 -y /dev/sda" &&
hdparmify reset
'

test_expect_success 'Reapply to all' '
hdparmify -nc $CONF apply &&
test "$(hdparmify -nc $CONF reapply)" = "-B 1 -M 128 -S 4 -y /dev/sda
-S 1 -Y /dev/sdb" &&
hdparmify reset
'

# expect reset to return 1 since restore should remove state
test_expect_success 'Restore all' '
hdparmify -nc $CONF apply &&
test "$(hdparmify -c $CONF restore)" = "-S 0 /dev/sda
-S 0 /dev/sdb" &&
test_expect_code 1 hdparmify reset
'

test_expect_success 'Apply to device not in config' '
test_expect_code 1 hdparmify -c $CONF -d /dev/sdc apply
'

test_expect_success 'Try applying to device not in config' '
hdparmify -t -c $CONF -d /dev/sdc apply
'

test_expect_success 'Reset single device' '
hdparmify -nc $CONF apply &&
hdparmify -d /dev/sda reset &&
test ! -e "$HDPARMIFY_RUNDIR"/dev-sda &&
test -e "$HDPARMIFY_RUNDIR"/dev-sdb &&
hdparmify reset
'

test_done

# vim: ft=sh
