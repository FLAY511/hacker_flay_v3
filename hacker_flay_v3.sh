#!/usr/bin/env bash
# HACKER_FLAY v3 — Full toolkit (OSINT / JSO / Utilities / Dark Web)
# Banner: Cyber Skull + typing text once.
# Use only for legal/authorized testing & education.

set -euo pipefail
IFS=$'\n\t'

# Colors
R='\033[1;31m'; G='\033[1;32m'; Y='\033[1;33m'; B='\033[1;34m'; C='\033[1;36m'; N='\033[0m'

# ---------------- Banner: Cyber Skull ----------------
banner(){
  clear
  cat <<'EOF'
      ______
   .-'      `-.
  /            \
 |,  .-.  .-.  ,|
 | )(_o/  \o_)( |
 |/     /\     \|
 (_     ^^     _)
  \__|IIIIII|__/
   | \IIIIII/ |
   \          /
    `--------`
   HACKER FLAY v3
EOF
  # typing effect once
  msg=">>> TOOLS INI DIBUAT OLEH CYBER FLAY <<<"
  for ((i=0;i<${#msg};i++)); do
    printf "%s" "${C}${msg:$i:1}${N}"
    sleep 0.02
  done
  printf "\n\n"
}

# ---------------- Helpers ----------------
need(){ command -v "$1" >/dev/null 2>&1; }
maybe_install(){ if ! need "$1"; then
  if need pkg; then pkg install -y "$1" >/dev/null 2>&1 || true; fi; fi; }

# ---------------- OSINT (1..15) ----------------
osint_menu(){
  while true; do
    clear
    echo -e "${B}===== OSINT MENU =====${N}"
    echo "1) Whois Lookup"
    echo "2) IP Geolocation"
    echo "3) DNS Lookup"
    echo "4) Reverse IP Lookup"
    echo "5) Subdomain Finder (crt.sh)"
    echo "6) Port Scanner (hackertarget)"
    echo "7) HTTP Header Grabber"
    echo "8) Email Breach Check (link)"
    echo "9) Phone Number Lookup (link)"
    echo "10) Website Tech Detect (WhatCMS demo)"
    echo "11) SSL Certificate Info"
    echo "12) Screenshot Website (link)"
    echo "13) Search Leak Database (link)"
    echo "14) Metadata Extractor (file)"
    echo "15) Cek Username (50 situs + tampilkan URL bila ada)"
    echo "0) Kembali"
    read -rp "Pilih (0-15): " O
    case "$O" in
      1)
        read -rp "Domain: " d
        curl -s "https://api.hackertarget.com/whois/?q=$d" || echo "Gagal"
        ;;
      2)
        read -rp "IP: " ip
        curl -s "https://ipapi.co/$ip/json/" || echo "Gagal"
        ;;
      3)
        read -rp "Domain: " d
        curl -s "https://api.hackertarget.com/dnslookup/?q=$d" || echo "Gagal"
        ;;
      4)
        read -rp "IP / Host: " ip
        curl -s "https://api.hackertarget.com/reverseiplookup/?q=$ip" || echo "Gagal"
        ;;
      5)
        read -rp "Domain: " d
        echo "Mencari subdomain (crt.sh output)..."
        curl -s "https://crt.sh/?q=%25.$d&output=json" | sed 's/},{/\n/g' || echo "Gagal"
        ;;
      6)
        read -rp "Host/IP: " h
        echo "Port scan ringan via hackertarget:"
        curl -s "https://api.hackertarget.com/nmap/?q=$h" || echo "Gagal"
        ;;
      7)
        read -rp "Domain/URL (contoh: https://example.com): " d
        curl -Is "$d" 2>/dev/null || echo "Gagal ambil header"
        ;;
      8)
        read -rp "Email: " e
        echo "Buka di browser: https://haveibeenpwned.com/account/$e"
        ;;
      9)
        read -rp "Nomor (eg +628xx): " n
        echo "Referensi lookup: https://numverify.com  atau https://phoneinfoga.crvx.fr/"
        ;;
      10)
        read -rp "URL/Domain: " d
        echo "WhatCMS (demo):"
        curl -s "https://api.whatcms.org/?key=DEMO&url=$d" || echo "Gagal"
        ;;
      11)
        read -rp "Domain: " d
        echo | openssl s_client -connect "${d}:443" -servername "$d" 2>/dev/null | openssl x509 -noout -text || echo "Gagal"
        ;;
      12)
        read -rp "URL: " u
        echo "Gunakan layanan screenshot eksternal (contoh: https://www.screenshotmachine.com/)"
        ;;
      13)
        read -rp "Keyword/email: " k
        echo "Cek di dehashed.com atau weleakinfo.to (web) — contoh: $k"
        ;;
      14)
        read -rp "Path file (jpg/pdf/...): " f
        maybe_install exiftool
        if [[ -f "$f" ]]; then exiftool "$f"; else echo "File tidak ditemukan"; fi
        ;;
      15)
        read -rp "Username: " user
        echo "Memeriksa 50 situs untuk: $user"
        UA="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/115 Safari/537.36"
        sites=(
          "facebook.com" "instagram.com" "twitter.com" "tiktok.com/@" "github.com"
          "gitlab.com" "reddit.com/user" "pinterest.com" "medium.com/@" "stackoverflow.com/users"
          "quora.com/profile" "tumblr.com" "flickr.com/people" "vimeo.com" "soundcloud.com"
          "open.spotify.com/user" "steamcommunity.com/id" "discord.com/users" "t.me" "linkedin.com/in"
          "snapchat.com/add" "ok.ru/profile" "vk.com" "twitch.tv" "dailymotion.com"
          "about.me" "producthunt.com/@" "hackerone.com" "kaggle.com" "goodreads.com" "last.fm/user"
          "wattpad.com/user" "archive.org/details" "trello.com" "notion.so" "canva.com" "dribbble.com"
          "behance.net" "deviantart.com" "flipboard.com" "slideshare.net" "tripadvisor.com/Profile"
          "booking.com" "myanimelist.net/profile" "crunchyroll.com" "roblox.com/users" "patreon.com"
        )
        for s in "${sites[@]}"; do
          if [[ "$s" == *"/@"* || "$s" == *"/user" || "$s" == *"/users" || "$s" == *"/id" || "$s" == *"/in" || "$s" == *"/profile" || "$s" == *"/people" || "$s" == *"/add" || "$s" == *"/Profile" ]]; then
            url="https://${s}${user}"
          else
            url="https://${s}/${user}"
          fi
          code=$(curl -A "$UA" -m 8 -s -L -o /dev/null -w "%{http_code}" "$url" || echo "000")
          if [[ "$code" =~ ^(200|301|302)$ ]]; then
            echo -e "${G}[+] DITEMUKAN: ${url}${N}"
          else
            echo -e "${R}[-] TIDAK: ${url}${N}"
          fi
        done
        ;;
      0)
        break
        ;;
      *)
        echo "Pilihan tidak valid"
        ;;
    esac
    read -rp "Tekan Enter untuk kembali ke OSINT menu..." _
  done
}

# ---------------- JSO (menu 2) ----------------
jso_menu(){
  clear
  echo -e "${Y}=== PEMBUATAN JSO ===${N}"
  read -rp "Tekan ENTER untuk buka haxor.my.id..." _
  if command -v termux-open-url >/dev/null 2>&1; then
    termux-open-url "https://haxor.my.id"
  else
    # fallback to xdg-open or print link
    if command -v xdg-open >/dev/null 2>&1; then
      xdg-open "https://haxor.my.id"
    else
      echo "Buka manual: https://haxor.my.id"
    fi
  fi
  read -rp "Setelah selesai, ketik 'lanjutkan' untuk paste HTML (atau Enter batal): " L
  if [[ "$L" != "lanjutkan" ]]; then
    echo "Dibatalkan"
    return
  fi
  echo "Tempel HTML (akhiri CTRL+D):"
  tmp="$(mktemp)"
  cat > "$tmp"
  read -rp "Nama output (tanpa ekstensi) [hasil]: " out
  if [[ -z "$out" ]]; then
    out="hasil"
  fi
  mv "$tmp" "${out}.jso"
  echo "[+] File dibuat: $(pwd)/${out}.jso"
  read -rp "Tekan Enter untuk lanjut..." _
}

# ---------------- Menu Lain ----------------
menu_lain(){
  while true; do
    clear
    echo -e "${B}===== MENU LAIN =====${N}"
    echo "1) Cek Cuaca"
    echo "2) Kalkulator (bc)"
    echo "3) Nama Hacker Random"
    echo "4) Chat AI (web)"
    echo "5) Base64 Encode/Decode"
    echo "6) Hash (MD5/SHA256)"
    echo "7) Password Generator"
    echo "8) IP Public"
    echo "9) Speedtest (jika terpasang)"
    echo "10) Kalender"
    echo "0) Kembali"
    read -rp "Pilih: " U
    case "$U" in
      1)
        read -rp "Kota: " k
        curl -s "wttr.in/${k}?format=3"
        ;;
      2)
        echo "Ketik 'quit' untuk keluar"
        while read -rp "expr> " e; do
          if [[ "$e" == "quit" ]]; then
            break
          fi
          echo "$e" | bc
        done
        ;;
      3)
        arr=("DarkGhost" "CyberNinja" "ShadowX" "NullByte" "RootKing")
        echo "Nama: ${arr[$RANDOM % ${#arr[@]}]}"
        ;;
      4)
        if command -v termux-open-url >/dev/null 2>&1; then
          termux-open-url "https://chat.openai.com"
        else
          echo "Buka: https://chat.openai.com"
        fi
        ;;
      5)
        read -rp "Teks: " t
        echo "Encode: $(echo -n "$t" | base64)"
        echo "Decode: $(echo -n "$t" | base64 -d 2>/dev/null)"
        ;;
      6)
        read -rp "Teks: " t
        echo "MD5: $(echo -n "$t" | md5sum | awk '{print $1}')"
        echo "SHA256: $(echo -n "$t" | sha256sum | awk '{print $1}')"
        ;;
      7)
        openssl rand -base64 12
        ;;
      8)
        curl -s ifconfig.me || echo "Gagal ambil IP publik"
        ;;
      9)
        if command -v speedtest-cli >/dev/null 2>&1; then
          speedtest-cli
        elif command -v speedtest >/dev/null 2>&1; then
          speedtest
        else
          echo "Install speedtest via pkg install speedtest"
        fi
        ;;
      10)
        cal
        ;;
      0)
        break
        ;;
      *)
        echo "Pilihan tidak valid"
        ;;
    esac
    read -rp "Tekan Enter untuk kembali ke Menu Lain..." _
  done
}

# ---------------- Dark Web (menu 4) ----------------
darkweb_menu(){
  clear
  echo -e "${R}== DARK WEB ACCESS (EDUKASI) ==${N}"
  echo "- Saat memilih, browser akan dibuka ke Hidden Wiki (mirror)."
  echo "- Untuk akses .onion yang sebenarnya gunakan Tor Browser / Orbot."
  read -rp "Tekan Enter untuk buka di browser..." _
  if command -v termux-open-url >/dev/null 2>&1; then
    termux-open-url "https://thehiddenwiki.org/"
  else
    if command -v xdg-open >/dev/null 2>&1; then
      xdg-open "https://thehiddenwiki.org/"
    else
      echo "Buka manual: https://thehiddenwiki.org/"
    fi
  fi
  read -rp "Tekan Enter untuk kembali..." _
}

# ---------------- Main loop ----------------
main_loop(){
  while true; do
    banner
    echo "[1] OSINT"
    echo "[2] Pembuatan JSO"
    echo "[3] Menu Lain"
    echo "[4] Masuk Dark Web"
    echo "[0] Keluar"
    read -rp "Pilih menu: " M
    case "$M" in
      1)
        osint_menu
        ;;
      2)
        jso_menu
        ;;
      3)
        menu_lain
        ;;
      4)
        darkweb_menu
        ;;
      0)
        echo "Terima kasih!"
        exit 0
        ;;
      *)
        echo "Pilihan tidak valid"
        ;;
    esac
  done
}

main_loop
