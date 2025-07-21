#!/bin/bash

###################################
# THIS CODE IS TO RUN ON BREVENT  #
# FOR UNROOTED DEVICES AND OR     #
# SIMPLY RUN IT ON A TERMINAL     # 
# EMULATOR FOR ROOTED DEVICES IT  #
# WILL AUTODETECT ROOT PRIVILAGES #
###################################

clear

echo "       .                    ##    ,.,
     .d#b.                  ##  .d###b.
    .d###b.                 ##  ##' '##
   .d#' '#b.  ##,###,  ,###.##  ##   ##  ##,###,
   #########  ##’  ##  ##   ##  ##   ##  ##'  ##
   ###   ###  ##   ##  ##  ,##  ##   ##  ##   ##
   ###   ###  ##   ##  '###'##  'q###p'  ##'##'  
                                         ##
                                         ##
                                         ##   V1
Professional free and opensearch Android optimizer"
echo ""
echo ""

checkups

checkrun () {
    if [ -n "$TERMUX_VERSION" ];
    then
        echo "Termux"
    else
        echo "Unknown emulator"
    fi
}

echo "[*] Getting infos..."
echo -n "    Running on: "
checkrun
echo "    Vendor: $(getprop ro.product.vendor_dlkm.manufacturer)"
echo "    Model: $(getprop ro.product.vendor.model)"
echo "    OS: $(uname -o) $(getprop ro.build.version.release)"
echo "    Kernel Version: $(uname -r)"
echo "    CPU: $(getprop ro.hardware)"
echo ""
echo ""

oproot () {
    sleep 1
    
    echo "[*] Optimizing via root..."
    echo
    
    su
    
    ############################
    echo "[*] Optimizing system... "
    echo -n "    Cleaning system cache... "
    rm -rf "/data/dalvik-cache" 2>&1
    rm -rf "/cache/dalvik-cache" 2>&1
    echo "DONE"
    echo -n "    Cleaning apps cache... "
    for pkg in $(su -c ls "/data/user/0/"); do
        rm -rf "/data/user/0/$pkg/cache/*" 2>&1
    done
    echo "DONE"
    echo -n "    Reducing transparency... "
    settings put global accessibility_reduce_transparency 1
    echo "DONE"
    echo -n "    Disabling blurs... "
    settings put global disable_window_blurs 1
    echo "DONE"
    echo -n "    Speeduping window animations... "
    settings put global window_animation_scale 0.5
    echo "DONE"
    echo -n "    Speeduping transitions... "
    settings put global transition_animation_scale 0.5
    echo "DONE"
    echo -n "    Speeduping animations... "
    settings put global animator_duration_scale 0.5
    echo "DONE"
    echo -n "    Adjusting brightness... "
    settings put system screen_auto_brightness_adj 1.0
    echo "DONE"
    
    echo
    ##########################
    echo "[*] Boosting internet... "
    echo -n "    Enabling low latency mode... "
    cmd wifi force-low-latency-mode enabled
    echo "DONE"

    echo "    Waiting initialization... "
    sleep 10

    echo -n "    Setting download sizes... "
    sysctl -w net.ipv4.tcp_rmem='16777216 87380 4194304'
    sysctl -w net.ipv4.tcp_wmem='16777216 87380 4194304'
    sysctl -w net.ipv4.tcp_mem='16777216 87380 4194304'
    echo "DONE"

    echo -n "    Cleaning DNS cache... "
    ndc resolver clearnetdns
    echo "DONE"
    
    #echo -n "    Testing DNS servers... "
    #REDIRECT_DNS=testdns()
    REDIRECT_DNS="8.8.8.8"
    #echo "DONE"
    
    echo -n "    Redireting DNS server... "
    iptables -t nat -A OUTPUT -p udp --dport 53 -j DNAT --to-destination $REDIRECT_DNS:53
    iptables -t nat -A PREROUTING -p udp --dport 53 -j DNAT --to-destination $REDIRECT_DNS:53

    # Redirect TCP DNS traffic (less common for standard DNS queries, but good to include)
    iptables -t nat -A OUTPUT -p tcp --dport 53 -j DNAT --to-destination $REDIRECT_DNS:53
    iptables -t nat -A PREROUTING -p tcp --dport 53 -j DNAT --to-destination $REDIRECT_DNS:53
    echo "DONE"

    echo -n "    Disabling network raccomandations... "
    settings put global network_recommendations_enabled 0
    echo "DONE"
    echo -n "    Ignoring network scoring... "
    settings put global network_scoring_ui_enabled 0
    echo "DONE"
    echo -n "    Boosting tethering... "
    settings put global tether_offload_disabled 0
    echo "DONE"
    echo -n "    Disabling power save on WIFI..."
    settings put global wifi_power_save 0
    echo "DONE"
    echo -n "    Disabling mobile data always on... "
    settings put global mobile_data_always_on 0
    echo "DONE"
    echo -n "    Disabling BLE scan... "
    settings put global ble_scan_always_enabled 0
    echo "DONE"
    echo -n "    Boosting download speed... "
    settings put secure download_manager_max_bytes_over_mobile 21390950
    settings put secure download_manager_recommended_max_bytes_over_mobile 21390950
    echo "DONE"
    echo -n "    Boosting mobile network speed... "
    settings put system network_engine_tools true
    settings put system mobile_download_manager 1
    settings put global preferred_network_mode 9,9
    echo "DONE"
    echo -n "    Setting WiFi params... "
    settings put --user 0 global wifi_score_params rssi2=-95:-85:-73:-60,rssi5=-85:-82:-70:-57
    echo "DONE"
    echo -n '    Connecting to "ADGuard DNS"... '
    settings put global private_dns_specifier family.adguard-dns.com
    echo "DONE"
    echo -n "    Disabling useless features... "
    settings put --user 0 global wifi_coverage_extend_feature_enabled 0
    settings put --user 0 global wifi_networks_available_notification_on 0
    settings put --user 0 global wifi_poor_connection_warning 0
    settings put --user 0 global wifi_scan_always_enabled 0
    settings put --user 0 global wifi_scan_throttle_enabled 0
    settings put --user 0 global wifi_verbose_logging_enabled 0
    settings put --user 0 global wifi_suspend_optimizations_enabled 1
    settings put --user 0 global wifi_wakeup_enabled 0
    settings put system POWER_PERFORMANCE_MODE_OPEN 1
    settings put --user 0 global sysui_powerui_enabled 1
    settings put --user 0 global ble_scan_always_enabled 0
    echo "DONE"
    echo -n "    Setting Network propieties... "
    setprop debug.set_network_idle_ms 0
    setprop debug.connect.running 1
    setprop debug.vilte.enable 3
    setprop debug.wifienhancelog 0
    setprop debug.vendor.viwifi_support 1
    setprop debug.operator.tools 1
    dumpsys deviceidle whitelist +com.android.overlay.gmssettings
    cmd wifi force-low-latency-mode enabled
    echo "DONE"
    
    echo
    #########################
    echo "[*] Boosting hardware power..."
    echo -n "    Boosting CPU responce... "
    cmd power set-fixed-performance-mode-enabled true
    settings put global sem_enhanced_cpu_responsiveness 0
    settings put global enhanced_processing 0
    echo "DONE"
    echo -n "    Disabling app standby... "
    settings put global app_standby_enabled 0
    echo "DONE"
    echo -n "    Disabling adaptive battery... "
    settings put global adaptive_battery_management_enabled 0
    echo "DONE"
    echo -n "    Enabling app restriction... "
    settings put global app_restriction_enabled true
    echo "DONE"
    echo -n "    Disabling power savers... "
    settings put system intelligent_sleep_mode 0
    settings put secure adaptive_sleep 0
    settings put global automatic_power_save_mode 0
    settings put global dynamic_power_savings_disable_threshold 20
    settings put global dynamic_power_savings_enabled 0
    settings put global low_power 0
    echo "DONE"
    echo -n "    Overclocking CPU... "
    for cpucode in $(ls /sys/devices/system/cpu/ | grep "cpu")
    do
        echo performance > /sys/devices/system/cpu/$cpucode/cpufreq/scaling_governor 2>&1
        echo 1600000 > /sys/devices/system/cpu/$cpucode/cpufreq/scaling_max_freq 2>&1
        echo 1600000 > /sys/devices/system/cpu/$cpucode/cpufreq/scaling_min_freq 2>&1
    done
    echo "DONE"
    echo -n "    General overclocking options... "
    setprop debug.hwui.renderer opengl
    setprop debug.force-opengl 1
    setprop debug.hwc.force_gpu_vsync 1
    settings put global ram_expand_size 0 default
    settings put system multicore_packet_scheduler 1
    echo "DONE"
    
    echo
        ########################
    echo "[*] Rising FPS... "
    echo -n "    Setting screen FPS... "
    settings put system peak_refresh_rate 144
    settings put system min_refresh_rate 144
    echo "DONE"
    echo -n "    Setting by game pkg name... "
    # DELTA FORCE
    device_config put game_overlay com.proxima.dfm mode=2,fps=144:mode=3,fps=144
    device_config put game_overlay com.garena.game.df mode=2,fps=144:mode=3,fps=144
    cmd game mode performance com.proxima.dfm > /dev/null
    cmd game mode performance com.garena.game.df > /dev/null
    # CODM
    device_config put game_overlay com.activision.callofduty.shooter mode=2,fps=144:mode=3,fps=144
    device_config put game_overlay com.garena.game.codm mode=2,fps=144:mode=3,fps=144
    cmd game mode performance com.activision.callofduty.shooter > /dev/null
    cmd game mode performance com.garena.game.codm > /dev/null
    # PUBG
    device_config put game_overlay com.tencent.ig mode=2,fps=144:mode=3,fps=144
    device_config put game_overlay com.pubg.krmobile mode=2,fps=144:mode=3,fps=144
    device_config put game_overlay com.vng.pubgmobile mode=2,fps=144:mode=3,fps=144
    device_config put game_overlay com.rekoo.pubgm mode=2,fps=144:mode=3,fps=144
    device_config put game_overlay com.tencent.tmgp.pubgmhd mode=2,fps=144:mode=3,fps=144
    device_config put game_overlay com.tencent.iglitece mode=2,fps=144:mode=3,fps=144
    cmd game mode performance com.tencent.ig > /dev/null
    cmd game mode performance com.pubg.krmobile > /dev/null
    cmd game mode performance com.vng.pubgmobile > /dev/null
    cmd game mode performance com.tencent.tmgp.pubgmhd > /dev/null
    cmd game mode performance com.tencent.iglitece > /dev/null
    # FREE FIRE
    device_config put game_overlay com.dts.freefireth mode=2,fps=144:mode=3,fps=144
    device_config put game_overlay com.dts.freefiremax mode=2,fps=144:mode=3,fps=144
    cmd game mode performance com.dts.freefireth > /dev/null
    cmd game mode performance com.dts.freefiremax > /dev/null
    # WARZONE MOBILE
    device_config put game_overlay com.activision.callofduty.warzone mode=2,fps=144:mode=3,fps=144
    cmd game mode performance com.activision.callofduty.warzone > /dev/null

    echo "DONE"

    echo "[*] Closing program..."
    exit 0
}

opadb () {
    sleep 1
    
    echo "[*] Optimizing via ADB..."
    echo
    
    ############################
    echo "[*] Optimizing system... "
    echo -n "    Disabling useless Google servs... "
    settings put system gearhead:driving_mode_settings_enabled 0
    settings put secure assistant 0
    settings put secure smartspace 0
    settings put global google_core_control 0
    settings put secure adaptive_connectivity_enabled 0
    settings put secure systemui.google.opa_enabled 0
    echo "DONE"
    echo -n "    Disabling some sensors... "
    settings put system master_motion 0
    settings put system motion_engine 0
    settings put system air_motion_engine 0
    settings put system air_motion_wake_up 0
    settings put system intelligent_sleep_mode 0
    settings put secure adaptive_sleep 0
    echo "DONE"
    echo -n "    Improving audio quality... "
    settings put system tube_amp_effect 1
    settings put system k2hd_effect 1
    echo "DONE"
    echo -n "    Reducing transparency... "
    settings put global accessibility_reduce_transparency 1
    echo "DONE"
    echo -n "    Disabling blurs... "
    settings put global disable_window_blurs 1
    echo "DONE"
    echo -n "    Speeduping window animations... "
    settings put global window_animation_scale 0.5
    echo "DONE"
    echo -n "    Speeduping transitions... "
    settings put global transition_animation_scale 0.5
    echo "DONE"
    echo -n "    Speeduping animations... "
    settings put global animator_duration_scale 0.5
    echo "DONE"
    echo -n "    Adjusting brightness... "
    settings put system screen_auto_brightness_adj 1.0
    echo "DONE"
    
    echo
    ##########################
    echo "[*] Boosting internet... "
    echo -n "    Cleaning DNS cache... "
    ndc resolver clearnetdns
    echo "DONE"
    echo -n "    Disabling network raccomandations... "
    settings put global network_recommendations_enabled 0
    echo "DONE"
    echo -n "    Ignoring network scoring... "
    settings put global network_scoring_ui_enabled 0
    echo "DONE"
    echo -n "    Boosting tethering... "
    settings put global tether_offload_disabled 0
    echo "DONE"
    echo -n "    Disabling power save on WIFI..."
    settings put global wifi_power_save 0
    echo "DONE"
    echo -n "    Disabling mobile data always on... "
    settings put global mobile_data_always_on 0
    echo "DONE"
    echo -n "    Disabling BLE scan... "
    settings put global ble_scan_always_enabled 0
    echo "DONE"
    echo -n "    Boosting download speed... "
    settings put secure download_manager_max_bytes_over_mobile 21390950
    settings put secure download_manager_recommended_max_bytes_over_mobile 21390950
    echo "DONE"
    echo -n "    Boosting mobile network speed... "
    settings put system network_engine_tools true
    settings put system mobile_download_manager 1
    settings put global preferred_network_mode 9,9
    echo "DONE"
    echo -n "    Setting WiFi params... "
    settings put --user 0 global wifi_score_params rssi2=-95:-85:-73:-60,rssi5=-85:-82:-70:-57
    echo "DONE"
    echo -n '    Connecting to "ADGuard DNS"... '
    settings put global private_dns_specifier family.adguard-dns.com
    echo "DONE"
    echo -n "    Disabling useless features... "
    settings put --user 0 global wifi_coverage_extend_feature_enabled 0
    settings put --user 0 global wifi_networks_available_notification_on 0
    settings put --user 0 global wifi_poor_connection_warning 0
    settings put --user 0 global wifi_scan_always_enabled 0
    settings put --user 0 global wifi_scan_throttle_enabled 0
    settings put --user 0 global wifi_verbose_logging_enabled 0
    settings put --user 0 global wifi_suspend_optimizations_enabled 1
    settings put --user 0 global wifi_wakeup_enabled 0
    settings put system POWER_PERFORMANCE_MODE_OPEN 1
    settings put --user 0 global sysui_powerui_enabled 1
    settings put --user 0 global ble_scan_always_enabled 0
    echo "DONE"
    echo -n "    Setting Network propieties... "
    setprop debug.set_network_idle_ms 0
    setprop debug.connect.running 1
    setprop debug.vilte.enable 3
    setprop debug.wifienhancelog 0
    setprop debug.vendor.viwifi_support 1
    setprop debug.operator.tools 1
    echo "DONE"
    #dumpsys deviceidle whitelist +com.android.overlay.gmssettings
    #cmd wifi force-low-latency-mode enabled
    
    echo
    #########################
    echo "[*] Boosting hardware power..."
    echo -n "    Boosting CPU responce... "
    cmd power set-fixed-performance-mode-enabled true
    settings put global sem_enhanced_cpu_responsiveness 0
    settings put global enhanced_processing 0
    echo "DONE"
    echo -n "    Disabling app standby... "
    settings put global app_standby_enabled 0
    echo "DONE"
    echo -n "    Disabling adaptive battery... "
    settings put global adaptive_battery_management_enabled 0
    echo "DONE"
    echo -n "    Enabling app restriction... "
    settings put global app_restriction_enabled true
    echo "DONE"
    echo -n "    Disabling power savers... "
    settings put system intelligent_sleep_mode 0
    settings put secure adaptive_sleep 0
    settings put global automatic_power_save_mode 0
    settings put global dynamic_power_savings_disable_threshold 20
    settings put global dynamic_power_savings_enabled 0
    settings put global low_power 0
    echo "DONE"
    echo -n "    Overclocking CPU... "
    for cpucode in $(ls /sys/devices/system/cpu/ | grep "cpu")
    do
        echo userspace > /sys/devices/system/cpu/$cpucode/cpufreq/scaling_governor > /dev/null
        echo 1600000 > /sys/devices/system/cpu/$cpucode/cpufreq/scaling_max_freq > /dev/null
        echo 1600000 > /sys/devices/system/cpu/$cpucode/cpufreq/scaling_min_freq > /dev/null
    done
    echo "DONE"
    echo -n "    General overclocking options... "
    setprop debug.hwui.renderer skiavk
    setprop debug.force-opengl 1
    setprop debug.hwc.force_gpu_vsync 1
    settings put global ram_expand_size 0 default
    settings put system multicore_packet_scheduler 1
    echo "DONE"
    
    echo
    ########################
    echo "[*] Rising FPS... "
    echo -n "    Setting screen FPS... "
    settings put system peak_refresh_rate 144
    settings put system min_refresh_rate 144
    echo "DONE"
    echo -n "    Setting by game pkg name... "
    # DELTA FORCE
    device_config put game_overlay com.proxima.dfm mode=2,fps=144:mode=3,fps=144
    device_config put game_overlay com.garena.game.df mode=2,fps=144:mode=3,fps=144
    cmd game mode performance com.proxima.dfm > /dev/null
    cmd game mode performance com.garena.game.df > /dev/null
    # CODM
    device_config put game_overlay com.activision.callofduty.shooter mode=2,fps=144:mode=3,fps=144
    device_config put game_overlay com.garena.game.codm mode=2,fps=144:mode=3,fps=144
    cmd game mode performance com.activision.callofduty.shooter > /dev/null
    cmd game mode performance com.garena.game.codm > /dev/null
    # PUBG
    device_config put game_overlay com.tencent.ig mode=2,fps=144:mode=3,fps=144
    device_config put game_overlay com.pubg.krmobile mode=2,fps=144:mode=3,fps=144
    device_config put game_overlay com.vng.pubgmobile mode=2,fps=144:mode=3,fps=144
    device_config put game_overlay com.rekoo.pubgm mode=2,fps=144:mode=3,fps=144
    device_config put game_overlay com.tencent.tmgp.pubgmhd mode=2,fps=144:mode=3,fps=144
    device_config put game_overlay com.tencent.iglitece mode=2,fps=144:mode=3,fps=144
    cmd game mode performance com.tencent.ig > /dev/null
    cmd game mode performance com.pubg.krmobile > /dev/null
    cmd game mode performance com.vng.pubgmobile > /dev/null
    cmd game mode performance com.tencent.tmgp.pubgmhd > /dev/null
    cmd game mode performance com.tencent.iglitece > /dev/null
    # FREE FIRE
    device_config put game_overlay com.dts.freefireth mode=2,fps=144:mode=3,fps=144
    device_config put game_overlay com.dts.freefiremax mode=2,fps=144:mode=3,fps=144
    cmd game mode performance com.dts.freefireth > /dev/null
    cmd game mode performance com.dts.freefiremax > /dev/null
    # WARZONE MOBILE
    device_config put game_overlay com.activision.callofduty.warzone mode=2,fps=144:mode=3,fps=144
    cmd game mode performance com.activision.callofduty.warzone > /dev/null

    echo "DONE"
    
    echo
    echo "[*] Closing program..."
    exit 0
}

echo "[*] Begining of the optimization..."
sleep 1
echo -n "    Testing root... "
if [ "$(id -u)" != "0" ]; then
    echo "FAILED"
    echo -n "    Testing ADB... "
    if ls / > /dev/null 2>&1 ;then
        echo "SUCCESS"
        sleep 1
        echo ""

        opadb
    else
        echo "NEED ACTIVATION"
        echo "[*] Execute in another device:"
        echo "    adb shell sh $0"
        echo
        echo "[*] Closing program..."
        exit 1
    fi
else
    echo "SUCCESS"
    sleep 1
    echo ""
    
    oproot
fi
