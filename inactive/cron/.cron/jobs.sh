0 10 * * *  ~/.cron/exclude-timemachine-cron.sh > ~/.cron/$(date +'%Y%m%d')-exclude-from-tm.log
0 */2 * * *  find ~/Code -depth 8 -name '*.DS_Store' -type f -delete > ~/.cron/$(date +'%Y%m%d')-remove-dsstore.log
0 0 1,14 * * rm -f ~/.cron/*.log

