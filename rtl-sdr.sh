#!/usr/bin/env bash
# taken from https://www.rtl-sdr.com/rtl-sdr-quick-start-guide/
# this script setups the rtlsdr drivers on debian

set -e

echo "=== RTL-SDR Clean Install Script ==="

# Ensure running on Debian/Ubuntu with apt
if ! command -v apt-get >/dev/null 2>&1; then
    echo "This script requires apt-get (Debian/Ubuntu)."
    exit 1
fi

# Required commands
REQUIRED_CMDS=("git" "cmake" "make" "gcc" "pkg-config")

for cmd in "${REQUIRED_CMDS[@]}"; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "Missing dependency: $cmd"
        echo "Installing required build dependencies..."
        sudo apt-get update
        sudo apt-get install -y libusb-1.0-0-dev git cmake pkg-config build-essential
        break
    fi
done

echo "Removing existing librtlsdr packages and files..."

sudo apt purge -y '^librtlsdr' || true

sudo rm -rf /usr/lib/librtlsdr* \
            /usr/include/rtl-sdr* \
            /usr/local/lib/librtlsdr* \
            /usr/local/include/rtl-sdr* \
            /usr/local/include/rtl_* \
            /usr/local/bin/rtl_*

echo "Cloning rtl-sdr repository..."

cd ~
rm -rf rtl-sdr
git clone https://github.com/osmocom/rtl-sdr
cd rtl-sdr

mkdir build
cd build

echo "Building rtl-sdr..."

cmake ../ -DINSTALL_UDEV_RULES=ON
make -j"$(nproc)"

echo "Installing rtl-sdr..."

sudo make install
sudo cp ../rtl-sdr.rules /etc/udev/rules.d/
sudo ldconfig

echo "Reloading udev rules..."
sudo udevadm control --reload-rules
sudo udevadm trigger

echo "Blacklisting dvb_usb_rtl28xxu driver..."
echo 'blacklist dvb_usb_rtl28xxu' | sudo tee --append /etc/modprobe.d/blacklist-dvb_usb_rtl28xxu.conf

echo "=== RTL-SDR installation complete ==="
echo "You may need to reboot your device"
