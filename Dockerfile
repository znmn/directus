# Menggunakan base image jc21/nginx-proxy-manager
FROM jc21/nginx-proxy-manager:latest

# Menetapkan variabel lingkungan opsional
# ENV DB_SQLITE_FILE="/data/database.sqlite"
ENV DISABLE_IPV6="true"

# Membuka port yang diperlukan
EXPOSE 80 443 81

# Menyalin direktori data dan Let's Encrypt dari host ke dalam container
VOLUME ["/data", "/etc/letsencrypt"]

# Menentukan perintah default untuk container
CMD ["/init"]
