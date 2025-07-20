const express = require('express');
const path = require('path');
const app = express();
const PORT = process.env.PORT || 3000;

// Static dosyaları serve et
app.use(express.static(path.join(__dirname, '.')));

// Ana sayfa
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'index.html'));
});

// Tüm route'ları index.html'e yönlendir (SPA için)
app.get('*', (req, res) => {
    res.sendFile(path.join(__dirname, 'index.html'));
});

app.listen(PORT, () => {
    console.log(`🚀 Sunucu çalışıyor: http://localhost:${PORT}`);
    console.log(`📱 Mobil test: http://192.168.1.X:${PORT} (IP adresinizi değiştirin)`);
    console.log(`🌐 Dış erişim: http://sunucu-ip:${PORT}`);
});

// CORS ayarları (gerekirse)
app.use((req, res, next) => {
    res.header('Access-Control-Allow-Origin', '*');
    res.header('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept');
    next();
}); 
