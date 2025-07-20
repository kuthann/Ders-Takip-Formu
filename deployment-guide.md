# 🚀 Sunucu Kurulumu ve Deployment Rehberi

## 📋 İçindekiler
1. [Local Sunucu](#local-sunucu)
2. [Ücretsiz Hosting](#ücretsiz-hosting)
3. [VPS Sunucu](#vps-sunucu)
4. [Domain Bağlama](#domain-bağlama)
5. [SSL Sertifikası](#ssl-sertifikası)

---

## 🖥️ Local Sunucu

### Node.js ile Çalıştırma

1. **Node.js Kurulumu**
   ```bash
   # Windows: https://nodejs.org adresinden indirin
   # Linux/Mac:
   curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
   sudo apt-get install -y nodejs
   ```

2. **Proje Kurulumu**
   ```bash
   # Proje klasörüne gidin
   cd ogrenci-takip-sistemi
   
   # Bağımlılıkları yükleyin
   npm install
   
   # Sunucuyu başlatın
   npm start
   ```

3. **Erişim**
   - Local: http://localhost:3000
   - Mobil: http://192.168.1.X:3000 (IP adresinizi değiştirin)

### Python ile Çalıştırma (Alternatif)

```bash
# Python 3 ile
python -m http.server 8000

# Python 2 ile
python -m SimpleHTTPServer 8000
```

---

## 🌐 Ücretsiz Hosting

### 1. Netlify (Önerilen)

1. **GitHub'a Yükleme**
   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   git remote add origin https://github.com/kullaniciadi/proje-adi.git
   git push -u origin main
   ```

2. **Netlify Deployment**
   - [netlify.com](https://netlify.com) hesabı oluşturun
   - "New site from Git" tıklayın
   - GitHub'ı seçin ve projenizi seçin
   - Build settings:
     - Build command: `npm run build`
     - Publish directory: `.`
   - Deploy'e tıklayın

3. **Özel Domain (İsteğe Bağlı)**
   - Site settings > Domain management
   - "Add custom domain" tıklayın
   - Domain adınızı girin

### 2. Vercel

1. **Vercel CLI Kurulumu**
   ```bash
   npm i -g vercel
   ```

2. **Deployment**
   ```bash
   vercel
   # Sorulara cevap verin
   # Otomatik deploy olur
   ```

### 3. GitHub Pages

1. **Repository Ayarları**
   - Settings > Pages
   - Source: Deploy from a branch
   - Branch: main, folder: / (root)
   - Save

2. **Erişim**
   - https://kullaniciadi.github.io/repo-adi

---

## 🖥️ VPS Sunucu

### Ubuntu/Debian Sunucu

1. **Sunucu Hazırlığı**
   ```bash
   # Sistem güncellemesi
   sudo apt update && sudo apt upgrade -y
   
   # Node.js kurulumu
   curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
   sudo apt-get install -y nodejs
   
   # Nginx kurulumu
   sudo apt install nginx -y
   ```

2. **Proje Kurulumu**
   ```bash
   # Proje klasörü oluştur
   mkdir /var/www/ogrenci-takip
   cd /var/www/ogrenci-takip
   
   # Dosyaları yükle
   # (FTP, SCP veya Git ile)
   
   # Bağımlılıkları yükle
   npm install --production
   ```

3. **PM2 ile Process Yönetimi**
   ```bash
   # PM2 kurulumu
   sudo npm install -g pm2
   
   # Uygulamayı başlat
   pm2 start server.js --name "ogrenci-takip"
   
   # Otomatik başlatma
   pm2 startup
   pm2 save
   ```

4. **Nginx Konfigürasyonu**
   ```bash
   sudo nano /etc/nginx/sites-available/ogrenci-takip
   ```

   ```nginx
   server {
       listen 80;
       server_name your-domain.com www.your-domain.com;
       
       location / {
           proxy_pass http://localhost:3000;
           proxy_http_version 1.1;
           proxy_set_header Upgrade $http_upgrade;
           proxy_set_header Connection 'upgrade';
           proxy_set_header Host $host;
           proxy_cache_bypass $http_upgrade;
       }
   }
   ```

   ```bash
   # Site'ı etkinleştir
   sudo ln -s /etc/nginx/sites-available/ogrenci-takip /etc/nginx/sites-enabled/
   sudo nginx -t
   sudo systemctl reload nginx
   ```

---

## 🔗 Domain Bağlama

### DNS Ayarları

1. **A Record**
   ```
   Type: A
   Name: @
   Value: [Sunucu IP Adresi]
   TTL: 3600
   ```

2. **CNAME Record**
   ```
   Type: CNAME
   Name: www
   Value: your-domain.com
   TTL: 3600
   ```

### Domain Sağlayıcıları
- **Godaddy**: DNS Management > A Record ekle
- **Namecheap**: Domain List > Manage > Advanced DNS
- **Cloudflare**: DNS > A Record ekle

---

## 🔒 SSL Sertifikası

### Let's Encrypt (Ücretsiz)

1. **Certbot Kurulumu**
   ```bash
   sudo apt install certbot python3-certbot-nginx -y
   ```

2. **SSL Sertifikası Alma**
   ```bash
   sudo certbot --nginx -d your-domain.com -d www.your-domain.com
   ```

3. **Otomatik Yenileme**
   ```bash
   sudo crontab -e
   # Bu satırı ekleyin:
   0 12 * * * /usr/bin/certbot renew --quiet
   ```

---

## 📱 Mobil Erişim

### Local Network

1. **IP Adresi Bulma**
   ```bash
   # Windows
   ipconfig
   
   # Linux/Mac
   ifconfig
   # veya
   ip addr show
   ```

2. **Firewall Ayarları**
   ```bash
   # Windows
   netsh advfirewall firewall add rule name="Node.js" dir=in action=allow protocol=TCP localport=3000
   
   # Linux
   sudo ufw allow 3000
   ```

3. **Erişim**
   - Mobil: http://192.168.1.X:3000
   - Tablet: http://192.168.1.X:3000

---

## 🔧 Environment Variables

### Production Ayarları

```bash
# .env dosyası oluşturun
NODE_ENV=production
PORT=3000
SUPABASE_URL=https://xblcsqbzpauodxxprrhf.supabase.co
SUPABASE_ANON_KEY=your-anon-key
```

### PM2 ile Environment Variables

```bash
pm2 start server.js --name "ogrenci-takip" --env production
```

---

## 📊 Monitoring

### PM2 Monitoring

```bash
# Uygulama durumu
pm2 status

# Logları görüntüle
pm2 logs ogrenci-takip

# Performans
pm2 monit
```

### Nginx Logları

```bash
# Access log
sudo tail -f /var/log/nginx/access.log

# Error log
sudo tail -f /var/log/nginx/error.log
```

---

## 🚨 Güvenlik

### Firewall Ayarları

```bash
# Sadece gerekli portları aç
sudo ufw allow 22    # SSH
sudo ufw allow 80    # HTTP
sudo ufw allow 443   # HTTPS
sudo ufw enable
```

### Fail2ban Kurulumu

```bash
sudo apt install fail2ban -y
sudo systemctl enable fail2ban
sudo systemctl start fail2ban
```

---

## 🔄 Backup

### Otomatik Backup Script

```bash
#!/bin/bash
# backup.sh

DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/backup/ogrenci-takip"
SOURCE_DIR="/var/www/ogrenci-takip"

mkdir -p $BACKUP_DIR
tar -czf $BACKUP_DIR/backup_$DATE.tar.gz $SOURCE_DIR

# 30 günden eski backup'ları sil
find $BACKUP_DIR -name "backup_*.tar.gz" -mtime +30 -delete
```

### Cron Job

```bash
# Günlük backup
0 2 * * * /path/to/backup.sh
```

---

## 📞 Destek

### Yaygın Sorunlar

1. **Port 3000 Kapalı**
   ```bash
   sudo netstat -tlnp | grep :3000
   sudo lsof -i :3000
   ```

2. **Nginx 502 Error**
   ```bash
   sudo systemctl status nginx
   sudo journalctl -u nginx
   ```

3. **SSL Sertifikası Sorunu**
   ```bash
   sudo certbot certificates
   sudo certbot renew --dry-run
   ```

### Log Dosyaları

- **PM2**: `~/.pm2/logs/`
- **Nginx**: `/var/log/nginx/`
- **System**: `/var/log/syslog`

---

## 🎯 Önerilen Yol

1. **Başlangıç**: Netlify ile ücretsiz hosting
2. **Gelişme**: VPS sunucu + domain
3. **Production**: Load balancer + CDN

**En kolay yol**: Netlify kullanın! 🚀 