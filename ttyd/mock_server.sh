#!/bin/bash

echo "Starting mock servers on ports 3000, 5000, 8000, and 8080..."

# Jalankan server HTTP sederhana di setiap port
python3 -m http.server 3000 &
PYTHON_PID_3000=$!

python3 -m http.server 5000 &
PYTHON_PID_5000=$!

python3 -m http.server 8000 &
PYTHON_PID_8000=$!

python3 -m http.server 8080 &
PYTHON_PID_8080=$!

# Simpan PID ke file agar bisa dihentikan nanti
echo "$PYTHON_PID_3000 $PYTHON_PID_5000 $PYTHON_PID_8000 $PYTHON_PID_8080" > /tmp/mock_server_pids

echo "Mock servers are running. Use 'stop_mock_servers' to stop them."

# Fungsi untuk menghentikan server
stop_mock_servers() {
    echo "Stopping mock servers..."
    kill $(cat /tmp/mock_server_pids)
    rm /tmp/mock_server_pids
}

# Tangkap SIGTERM dan hentikan server saat container dimatikan
trap stop_mock_servers SIGTERM

# Tunggu agar script tetap berjalan
wait
