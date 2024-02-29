0 10 * * *  ~/.cron/exclude-timemachine-cron.sh > ~/.cron/$(date +'%Y%m%d')-exclude-from-tm.log
0 */2 * * *  ~/.cron/rmds.sh > ~/.cron/$(date +'%Y%m%d')-remove-dsstore.log
0 0 1,14 * * rm -f ~/.cron/*.log
