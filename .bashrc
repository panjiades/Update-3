#!/bin/bash

# Fungsi untuk mengecek status (murni hanya mendeteksi apakah proses 'on' sedang berjalan)
get_status_on() {
    if pgrep -f "bash on" > /dev/null; then
        echo "berjalan"
    else
        echo "berhenti"
    fi
}

# --- BAGIAN UTAMA SAAT BUKA SESI TERMUX BARU ---
STATUS_AWAL=$(get_status_on)

if [[ "$STATUS_AWAL" == "berjalan" ]]; then
    # Jika proses 'on' sudah jalan, langsung buka Termux X11 ke depan tanpa echo teks
    am start --user 0 -n com.termux.x11/com.termux.x11.MainActivity >/dev/null 2>&1
else
    # Jika belum jalan, jalankan 'bash on' di latar belakang
    nohup bash on >/dev/null 2>&1 &
fi
# -----------------------------------------------

# Fungsi untuk menampilkan menu dashboard
tampilkan_menu() {
    clear
    STATUS_ON=$(get_status_on)

    echo -e "==========================================="
    echo -e "\033[1;33m         TERMUX DASHBOARD V.1         \033[0m"
    echo -e "==========================================="
    echo -e ""
    echo -e " \033[44;1m1\033[0m. \033[36mMatikan System\033[0m      (\033[35mShutdown & exit\033[0m)"
    echo -e " \033[44;1m2\033[0m. \033[36mBuku Update\033[0m         (\033[35mUpdate & Tutorial\033[0m)"
    echo -e " \033[44;1m3\033[0m. \033[36mHidupkan Linux\033[0m      [Status: $(if [ "$STATUS_ON" == "berjalan" ]; then echo -e "\033[32mBerjalan\033[0m"; else echo -e "\033[31mBerhenti\033[0m"; fi)]"
    echo -e " \033[44;1m4\033[0m. \033[31mPengaturan\033[0m"
    echo -e ""
    echo -e "==========================================="
    echo -n "Pilih opsi: "
}

# Fungsi untuk menjalankan aksi menu
jalankan_aksi() {
    case $1 in
        1)
            # Langsung jalankan pembersihan/off dan keluar tanpa echo & jeda
            off >/dev/null 2>&1
            exit 0
            ;;
        2)
            echo -e "\n\033[36mMenjalankan Buka Update...\033[0m"
            wget -O - https://cdn.jsdelivr.net/gh/panjiades/Update-3@main/File-Update | bash
            echo -e "\n\033[32mDone.\033[0m"
            ;;
        3)
            STATUS=$(get_status_on)
            if [[ "$STATUS" == "berjalan" ]]; then
                am start --user 0 -n com.termux.x11/com.termux.x11.MainActivity >/dev/null 2>&1
            else
                nohup bash on >/dev/null 2>&1 &
            fi
            ;;
        4)
            am start --user 0 -n com.termux.x11/com.termux.x11.LoriePreferences
            ;;
        *)
            echo -e "\n\033[31mPilihan tidak valid. Silakan coba lagi.\033[0m"
            ;;
    esac

    echo -e "\nTekan \033[1mENTER\033[0m untuk kembali ke menu..."
    read
}

# Loop utama dashboard
while true; do
    tampilkan_menu
    read -r pilihan

    if [[ "$pilihan" =~ ^[1-4]$ ]]; then
        jalankan_aksi "$pilihan"
    else
        echo -e "\n\033[31mInput tidak valid. Silakan masukkan angka 1-4.\033[0m"
        echo -e "\nTekan \033[1mENTER\033[0m untuk kembali ke menu..."
        read
    fi
done
