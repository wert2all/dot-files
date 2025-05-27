#!/bin/bash

# -------------------------- Global Variables --------------------------
# These will be set dynamically
APK_FULL_PATH=""                   # Global variable to store the found APK path
SELECTED_BUILD_VARIANT_TASK_RAW="" # Store the raw selected Gradle build task (e.g., app:assembleMyFlavorDebug)
SELECTED_BUILD_VARIANT_NAME=""     # Store the parsed variant name (e.g., MyFlavorDebug)

# -------------------------- Functions --------------------------

# Function to check the status of the last command
check_status() {
    if [ $? -ne 0 ]; then
        echo "Error: $1"
        exit 1
    fi
}

# Function to select an AVD
# This function will set the global variable AVD_NAME_FINAL
select_avd() {
    local avd_list=$(emulator -list-avds)
    check_status "Failed to list AVDs. Make sure 'emulator' is available in your PATH."

    local num_avds=$(echo "$avd_list" | wc -l)
    local temp_selected_avd="" # Use a temporary local variable for selection

    if [ -n "$1" ]; then
        # If AVD_NAME is passed as an argument
        local arg_avd="$1"
        if echo "$avd_list" | grep -q "^$arg_avd$"; then
            temp_selected_avd="$arg_avd"
            echo "Selected AVD from arguments: $temp_selected_avd"
        else
            echo "Error: AVD '$arg_avd' not found."
            echo "Please choose from the available AVDs below."
            # Fall through to interactive selection if argument AVD is invalid
        fi
    fi

    # If AVD was not selected via argument or argument was invalid, proceed with auto/interactive selection
    if [ -z "$temp_selected_avd" ]; then
        if [ "$num_avds" -eq 0 ]; then
            echo "Error: No AVDs found on your system. Please create one using Android Studio AVD Manager."
            exit 1
        elif [ "$num_avds" -eq 1 ]; then
            # If only one AVD is found, select it automatically
            temp_selected_avd="$avd_list"
            echo "Found one AVD: $temp_selected_avd. Selecting it automatically."
        else
            # If multiple AVDs are found, provide a choice
            echo "Multiple AVDs found:"
            echo "$avd_list" | cat -n # Number the list of AVDs
            printf "Please select the AVD number to launch: "
            read avd_choice

            if [[ "$avd_choice" =~ ^[0-9]+$ ]] && [ "$avd_choice" -ge 1 ] && [ "$avd_choice" -le "$num_avds" ]; then
                temp_selected_avd=$(echo "$avd_list" | sed -n "${avd_choice}p")
                echo "Selected AVD: $temp_selected_avd"
            else
                echo "Invalid choice. Exiting. Please re-run the script and enter a valid number."
                exit 1 # Exit if invalid choice in interactive mode
            fi
        fi
    fi

    # Set the global variable for the selected AVD
    AVD_NAME_FINAL="$temp_selected_avd"
    if [ -z "$AVD_NAME_FINAL" ]; then
        echo "Error: AVD selection failed. Exiting."
        exit 1
    fi
}

# Function to start the emulator
start_emulator() {
    local avd_to_start="$1"
    echo "Attempting to start emulator: $avd_to_start..."

    # Check if any emulator is already running
    local running_emulator=$(adb devices | grep -E '^emulator-[0-9]+' | head -n 1 | cut -f1)

    if [ -n "$running_emulator" ]; then
        echo "An emulator ($running_emulator) is already running. Skipping new emulator launch."
        return 0 # Exit the function, signaling success (no need to start)
    fi

    echo "No emulator found running. Launching new emulator..."

    # Start the emulator in the background
    # Use -no-snapshot-load to ensure a clean boot
    emulator -avd "$avd_to_start" -no-audio -no-snapshot-load &
    EMULATOR_PID=$!
    echo "Emulator launching with PID: $EMULATOR_PID"

    # Wait for the emulator to boot (up to 180 seconds)
    echo "Waiting for emulator to boot (up to 180 seconds)..."
    # Use `timeout` with `bash -c` to poll for boot completion status
    timeout 180s bash -c "while ! adb shell getprop sys.boot_completed | grep -q 1; do sleep 1; done" &>/dev/null

    if [ $? -ne 0 ]; then
        echo "Error: Failed to wait for emulator to boot within 180 seconds. Try launching it manually or increase the timeout."
        echo "Current status of ADB devices:"
        adb devices
        exit 1
    fi
    echo "Emulator booted successfully."
}

# Function to detect and select build variant (flavor + buildType)
select_build_variant() {
    echo "Detecting available build variants..."
    cd "$ANDROID_PROJECT_PATH" || check_status "Failed to change to project directory for Gradle tasks. Check path: $ANDROID_PROJECT_PATH"

    # Get a list of all assemble tasks (e.g., app:assembleDebug, app:assembleMyFlavorDebug)
    # We filter for tasks that start with 'assemble' and end with 'Debug' or 'Release'
    # 'awk' is used to get the first column (task name)
    local assemble_tasks=$(./gradlew tasks --all --console=plain | grep -E 'assemble(Debug|Release|[A-Z][a-zA-Z]*Debug|[A-Z][a-zA-Z]*Release)' | awk '{print $1}')
    check_status "Failed to list Gradle tasks. Ensure Gradle is configured correctly."

    local num_tasks=$(echo "$assemble_tasks" | wc -l)
    local temp_selected_task_raw=""
    local temp_selected_variant_name=""

    if [ -n "$1" ]; then
        # If BUILD_VARIANT_TASK_ARG is passed as an argument
        local arg_task="$1"
        if echo "$assemble_tasks" | grep -q "^$arg_task$"; then
            temp_selected_task_raw="$arg_task"
            echo "Selected build variant from arguments: $temp_selected_task_raw"
        else
            echo "Error: Build variant task '$arg_task' not found."
            echo "Please choose from the available tasks below."
            # Fall through to interactive selection if argument task is invalid
        fi
    fi

    # If task was not selected via argument or argument was invalid, proceed with auto/interactive selection
    if [ -z "$temp_selected_task_raw" ]; then
        if [ "$num_tasks" -eq 0 ]; then
            echo "Error: No 'assemble' tasks (e.g., assembleDebug, assembleMyFlavorDebug) found in your project."
            echo "Please ensure your project has Android application modules configured."
            exit 1
        elif [ "$num_tasks" -eq 1 ]; then
            temp_selected_task_raw="$assemble_tasks"
            echo "Found only one build variant task: $temp_selected_task_raw. Selecting it automatically."
        else
            echo "Multiple build variants found:"
            echo "$assemble_tasks" | cat -n # Number the list of AVDs
            printf "Please select the AVD number to launch: "
            read task_choice

            if [[ "$task_choice" =~ ^[0-9]+$ ]] && [ "$task_choice" -ge 1 ] && [ "$task_choice" -le "$num_tasks" ]; then
                temp_selected_task_raw=$(echo "$assemble_tasks" | sed -n "${task_choice}p")
                echo "Selected build variant: $temp_selected_task_raw"
            else
                echo "Invalid choice. Exiting. Please re-run the script and enter a valid number."
                exit 1
            fi
        fi
    fi

    # Set the global variable for the raw selected build task
    SELECTED_BUILD_VARIANT_TASK_RAW="$temp_selected_task_raw"
    if [ -z "$SELECTED_BUILD_VARIANT_TASK_RAW" ]; then
        echo "Error: Build variant selection failed. Exiting."
        exit 1
    fi

    # Extract the actual variant name (e.g., BetaDebug from app:assembleBetaDebug)
    # This assumes the format "module:assembleVariant"
    temp_selected_variant_name=$(echo "$SELECTED_BUILD_VARIANT_TASK_RAW" | sed -E 's/^[^:]+:assemble//')
    if [ -z "$temp_selected_variant_name" ]; then
        # Fallback if the above sed fails or if it's a simple assembleDebug (no module prefix)
        temp_selected_variant_name=$(echo "$SELECTED_BUILD_VARIANT_TASK_RAW" | sed 's/^assemble//')
    fi
    SELECTED_BUILD_VARIANT_NAME="$temp_selected_variant_name"
}

# Function to build the project and find APK path
build_project() {
    echo "Navigating to project directory: $ANDROID_PROJECT_PATH"
    cd "$ANDROID_PROJECT_PATH" || check_status "Failed to change to project directory. Check path: $ANDROID_PROJECT_PATH"

    echo "Cleaning and building the project for variant: $SELECTED_BUILD_VARIANT_TASK_RAW..."
    # Execute Gradle build task and capture output
    local gradlew_output=$(./gradlew clean "$SELECTED_BUILD_VARIANT_TASK_RAW" --console=plain 2>&1)

    echo "$gradlew_output" # Print Gradle output for debugging

    # Check Gradle build status
    echo "$gradlew_output" | grep -q "BUILD SUCCESSFUL"
    check_status "Error during project build. Check Gradle logs above."

    echo "Project successfully built for $SELECTED_BUILD_VARIANT_TASK_RAW."

    # --- Dynamically find the APK path from build outputs ---
    echo "Attempting to find APK path from build outputs..."

    # Use the parsed variant name (e.g., BetaDebug) for directory structure
    local variant_name_capitalized="$SELECTED_BUILD_VARIANT_NAME"

    local flavor_part=""
    local build_type_part=""

    # Regex to extract flavor and buildType (e.g., BetaDebug -> Beta, Debug)
    if [[ "$variant_name_capitalized" =~ ^([A-Z][a-zA-Z]*)(Debug|Release)$ ]]; then
        flavor_part=$(echo "${BASH_REMATCH[1]}" | tr '[:upper:]' '[:lower:]')     # myflavor
        build_type_part=$(echo "${BASH_REMATCH[2]}" | tr '[:upper:]' '[:lower:]') # debug
    else
        # Fallback for simple 'Debug' or 'Release' variants (no explicit flavor)
        build_type_part=$(echo "$variant_name_capitalized" | tr '[:upper:]' '[:lower:]') # debug or release
    fi

    local potential_apk_dirs=()
    local base_apk_output_path="$ANDROID_PROJECT_PATH/app/build/outputs/apk"

    # Pattern 1: app/build/outputs/apk/<flavor>/<buildType>/ (MOST COMMON FOR FLAVORS)
    if [ -n "$flavor_part" ] && [ -n "$build_type_part" ]; then
        potential_apk_dirs+=("${base_apk_output_path}/${flavor_part}/${build_type_part}")
    fi

    # Pattern 2: app/build/outputs/apk/<buildType>/ (for projects without explicit flavors, or for single-flavor apps where flavor dir is skipped)
    if [ -n "$build_type_part" ]; then
        potential_apk_dirs+=("${base_apk_output_path}/${build_type_part}")
    fi

    # Pattern 3: app/build/outputs/apk/<flavorBuildType>/ (less common but possible, e.g., myflavordebug)
    potential_apk_dirs+=("${base_apk_output_path}/$(echo "$variant_name_capitalized" | tr '[:upper:]' '[:lower:]')")

    # Final fallback: app/build/outputs/apk/debug/
    potential_apk_dirs+=("${base_apk_output_path}/debug")

    APK_FULL_PATH=""
    for dir in "${potential_apk_dirs[@]}"; do
        if [ -d "$dir" ]; then
            # Use 'find' to get all APKs and then 'ls -t' to get the newest if multiple exist
            local found_apks=($(find "$dir" -maxdepth 1 -name "*.apk" -print0 | xargs -0))

            if [ ${#found_apks[@]} -gt 0 ]; then
                # Sort by modification time to get the newest APK if multiple exist
                local newest_apk=$(printf "%s\n" "${found_apks[@]}" | xargs -r ls -t | head -n 1)
                if [ -n "$newest_apk" ]; then
                    APK_FULL_PATH="$newest_apk"
                    echo "Found APK at: $APK_FULL_PATH"
                    break # Found it, exit loop
                fi
            fi
        fi
    done

    if [ -z "$APK_FULL_PATH" ]; then
        echo "Error: Could not determine APK full path after build for variant '$SELECTED_BUILD_VARIANT_TASK_RAW'."
        echo "Please check the 'app/build/outputs/apk/' directory manually and confirm your build variant setup."
        exit 1
    fi
}

# Function to install the APK
install_apk() {
    # APK_FULL_PATH is set by build_project function
    if [ -z "$APK_FULL_PATH" ]; then
        echo "Error: APK_FULL_PATH not set. Build process might have failed or not found the APK."
        exit 1
    fi

    echo "Installing APK on emulator: $APK_FULL_PATH"
    adb install -r "$APK_FULL_PATH" || check_status "Error during APK installation."
    echo "APK installed successfully."
}

# Function to launch the application
launch_app() {
    local android_manifest_path="$ANDROID_PROJECT_PATH/app/src/main/AndroidManifest.xml"

    PACKAGE_NAME="" # Reset PACKAGE_NAME

    # Determine the latest build-tools version dynamically
    local build_tools_version=$(ls -1 "$ANDROID_HOME/build-tools/" | sort -V | tail -n 1)
    local aapt_path="$ANDROID_HOME/build-tools/$build_tools_version/aapt"

    if [ ! -f "$aapt_path" ]; then
        echo "Error: aapt not found at $aapt_path. Please ensure ANDROID_HOME is set correctly and Android SDK Build-Tools are installed."
        exit 1 # Exit early if aapt is critical and not found
    fi

    # Get package name using aapt dump badging from the APK file
    if [ -n "$APK_FULL_PATH" ] && [ -f "$APK_FULL_PATH" ]; then
        local aapt_output=$("$aapt_path" dump badging "$APK_FULL_PATH" 2>&1)
        local aapt_status=$?

        if [ "$aapt_status" -eq 0 ]; then
            PACKAGE_NAME=$(echo "$aapt_output" | grep 'package: name=' | head -n 1 | cut -d"'" -f2)
        else
            echo "Error: aapt command failed with status $aapt_status for package name."
            echo "aapt output:"
            echo "$aapt_output"
            echo "Please ensure the APK file is valid and aapt has execute permissions."
            exit 1 # Exit if aapt failed to get package name
        fi
    else
        echo "Error: APK_FULL_PATH is empty or file does not exist. Cannot use aapt for package name."
        exit 1
    fi

    if [ -z "$PACKAGE_NAME" ]; then
        echo "Error: Failed to determine application package name. Even after using aapt."
        exit 1
    fi
    echo "Found package name: $PACKAGE_NAME"

    # Get launcher activity using aapt from the APK
    LAUNCHER_ACTIVITY="" # Reset LAUNCHER_ACTIVITY
    local aapt_launcher_output=$("$aapt_path" dump badging "$APK_FULL_PATH" 2>&1)
    local aapt_launcher_status=$?

    if [ "$aapt_launcher_status" -eq 0 ]; then
        # Look for 'launchable-activity: name='
        LAUNCHER_ACTIVITY=$(echo "$aapt_launcher_output" | grep 'launchable-activity: name=' | head -n 1 | cut -d"'" -f2)
    else
        echo "Error: aapt command failed with status $aapt_launcher_status for launcher activity."
        echo "aapt output:"
        echo "$aapt_launcher_output"
        echo "Please ensure the APK file is valid and aapt has execute permissions."
        exit 1 # Exit if aapt failed to get launcher activity
    fi

    # Fallback to AndroidManifest.xml if aapt didn't find launcher activity (less likely now)
    if [ -z "$LAUNCHER_ACTIVITY" ]; then
        # This fallback is rarely needed now, but kept for robustness
        LAUNCHER_ACTIVITY=$(grep -oP 'android:name="\.?[^"]+"' "$android_manifest_path" |
            grep -B 2 'android.intent.category.LAUNCHER' |
            grep -oP 'android:name="\.?[^"]+"' |
            head -1 | cut -d'"' -f2)

        # The transformation logic for .MainActivity should still be applied if we fall back to manifest parsing
        if [[ "$LAUNCHER_ACTIVITY" == ./* ]]; then
            LAUNCHER_ACTIVITY="$PACKAGE_NAME${LAUNCHER_ACTIVITY:1}"
        elif [[ "$LAUNCHER_ACTIVITY" != *.* ]]; then
            LAUNCHER_ACTIVITY="$PACKAGE_NAME.$LAUNCHER_ACTIVITY"
        fi
    fi

    if [ -z "$LAUNCHER_ACTIVITY" ]; then
        echo "Error: Failed to determine main launcher activity of the application. Tried aapt and AndroidManifest.xml."
        echo "Please verify your AndroidManifest.xml: ensure there is an activity with android.intent.category.LAUNCHER."
        exit 1
    fi
    echo "Found launcher activity: $LAUNCHER_ACTIVITY"

    echo "Launching application: $PACKAGE_NAME/$LAUNCHER_ACTIVITY"
    adb shell am start -n "$PACKAGE_NAME/$LAUNCHER_ACTIVITY" -a android.intent.action.MAIN -c android.intent.category.LAUNCHER || check_status "Error launching application."
    echo "Application launched successfully."
}

# -------------------------- Main Script Logic --------------------------

# Parsing arguments
# Usage: ./build_and_run_app.sh [PROJECT_PATH] [AVD_NAME] [BUILD_VARIANT_TASK]

PROJECT_PATH_ARG=""
AVD_NAME_ARG=""
BUILD_VARIANT_TASK_ARG=""

# Check number of arguments
if [ "$#" -ge 1 ]; then
    PROJECT_PATH_ARG="$1"
fi

if [ "$#" -ge 2 ]; then
    AVD_NAME_ARG="$2"
fi

if [ "$#" -ge 3 ]; then
    BUILD_VARIANT_TASK_ARG="$3" # New argument for pre-selecting build variant
fi

# Determine ANDROID_PROJECT_PATH
if [ -n "$PROJECT_PATH_ARG" ]; then
    ANDROID_PROJECT_PATH=$(readlink -f "$PROJECT_PATH_ARG")
    echo "Project path obtained from argument: $ANDROID_PROJECT_PATH"
else
    # Use current directory if no argument is provided
    ANDROID_PROJECT_PATH=$(pwd)
    echo "Project path set to current directory: $ANDROID_PROJECT_PATH"
fi

# --- Check for build.gradle or build.gradle.kts ---
if [ ! -f "$ANDROID_PROJECT_PATH/build.gradle" ] && [ ! -f "$ANDROID_PROJECT_PATH/build.gradle.kts" ]; then
    echo "Error: Neither 'build.gradle' nor 'build.gradle.kts' file found in directory $ANDROID_PROJECT_PATH."
    echo "Please ensure this is the root directory of your Android project or specify the correct path."
    exit 1
fi

echo "Starting Android application build and launch process..."

# 1. AVD Selection
AVD_NAME_FINAL="" # Initialize global variable
select_avd "$AVD_NAME_ARG"
check_status "Failed to select an AVD." # select_avd will exit if it fails

# 2. Launch Emulator
start_emulator "$AVD_NAME_FINAL"

# 3. Select Build Variant
# This will set the global variables SELECTED_BUILD_VARIANT_TASK_RAW and SELECTED_BUILD_VARIANT_NAME
SELECTED_BUILD_VARIANT_TASK_RAW="" # Initialize global variable
SELECTED_BUILD_VARIANT_NAME=""     # Initialize global variable
select_build_variant "$BUILD_VARIANT_TASK_ARG"
check_status "Failed to select a build variant."

# 4. Build Project (This will use SELECTED_BUILD_VARIANT_TASK_RAW and SELECTED_BUILD_VARIANT_NAME and set APK_FULL_PATH)
build_project

# 5. Install APK
install_apk

# 6. Launch App
launch_app

echo "Script finished successfully."
