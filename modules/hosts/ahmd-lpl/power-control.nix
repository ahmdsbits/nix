{
  flake.modules.nixos.ahmd-lpl = { pkgs, ... }: {
    services.tuned.enable = true;
    systemd.services.asus-power-control = {
      description = "ASUS Custom Power Control Loop";
      after = [ "multi-user.target" ];
      wantedBy = [ "multi-user.target" ];

      path = with pkgs; [ coreutils findutils gawk tuned ];

      serviceConfig = {
        Type = "simple";
        User = "root";
        Restart = "always";
        RestartSec = 3;
      };

      script = ''
        #!/usr/bin/env bash

        # --- CONFIGURATION ---
        EXTREME_TEMP=95000    # 95°C: Immediate Max Speed
        SUSTAINED_TEMP=87500  # 87.5°C: Triggers Max Speed if sustained
        COOL_TEMP=75000       # 75°C: Returns to Auto
        POLL_INTERVAL=2.5     # Check every 2.5 seconds

        # --- DEBOUNCE SETTINGS ---
        SUSTAINED_TICKS=6     # Needs 15 seconds continuously at 87.5°C
        COOL_TICKS=4          # Needs 10 seconds continuously cool

        RAPL_BASE="/sys/class/powercap/intel-rapl/intel-rapl:0"
        FAN_PATH=$(find /sys/devices/platform/asus-nb-wmi/hwmon/hwmon*/pwm1_enable | head -n 1)
        TEMP_SENSOR="/sys/class/thermal/thermal_zone0/temp"

        if [ -z "$FAN_PATH" ]; then
            echo "Error: ASUS fan control path not found."
            exit 1
        fi

        # --- SAFETY TRAP ---
        trap "echo 2 > $FAN_PATH; exit" SIGINT SIGTERM

        current_fan_mode="AUTO"
        hot_counter=0
        cool_counter=0

        # --- MAIN LOOP ---
        while true; do
            # 1. THERMAL MONITOR WITH DUAL-THRESHOLD DEBOUNCE
            CURRENT_TEMP=$(cat "$TEMP_SENSOR")

            # Evaluate temperature zones
            if [ "$CURRENT_TEMP" -ge "$EXTREME_TEMP" ]; then
                hot_counter=$SUSTAINED_TICKS # Instant trigger
                cool_counter=0
            elif [ "$CURRENT_TEMP" -ge "$SUSTAINED_TEMP" ]; then
                hot_counter=$((hot_counter + 1))
                cool_counter=0
            elif [ "$CURRENT_TEMP" -le "$COOL_TEMP" ]; then
                cool_counter=$((cool_counter + 1))
                hot_counter=0
            else
                # Middle zone resets counters to prevent gradual creep
                hot_counter=0
                cool_counter=0
            fi

            # Apply fan mode based on counters
            if [ "$hot_counter" -ge "$SUSTAINED_TICKS" ]; then
                if [ "$current_fan_mode" != "MAX" ]; then
                    echo 0 > "$FAN_PATH"
                    current_fan_mode="MAX"
                fi
                hot_counter=$SUSTAINED_TICKS # Prevent variable overflow
            elif [ "$cool_counter" -ge "$COOL_TICKS" ]; then
                if [ "$current_fan_mode" != "AUTO" ]; then
                    echo 2 > "$FAN_PATH"
                    current_fan_mode="AUTO"
                fi
                cool_counter=$COOL_TICKS # Prevent variable overflow
            fi

            # 2. TUNED SYNC & POWER LIMIT ENFORCEMENT
            PROFILE=$(tuned-adm active | awk '{print $NF}')

            if [ "$PROFILE" == "powersave" ]; then
                TARGET_PL1=28000000
                TARGET_PL2=28000000
            elif [ "$PROFILE" == "throughput-performance" ]; then
                TARGET_PL1=30000000
                TARGET_PL2=65000000
            else
                TARGET_PL1=28000000
                TARGET_PL2=60000000
            fi

            if [ -f "$RAPL_BASE/constraint_0_power_limit_uw" ]; then
                CURRENT_PL1=$(cat "$RAPL_BASE/constraint_0_power_limit_uw")

                if [ "$CURRENT_PL1" != "$TARGET_PL1" ]; then
                    echo "$TARGET_PL1" > "$RAPL_BASE/constraint_0_power_limit_uw"
                    echo "$TARGET_PL2" > "$RAPL_BASE/constraint_1_power_limit_uw"
                    echo 20000 > "$RAPL_BASE/constraint_1_time_window_us"
                    echo 1 > "$RAPL_BASE/enabled"
                fi
            fi

            sleep "$POLL_INTERVAL"
        done        
      '';
    };
  };
}
