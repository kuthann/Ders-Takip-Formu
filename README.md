# Öğrenci Takip Sistemi - Supabase Entegrasyonu

Bu proje, öğrencilerin derslerini, sınavlarını ve akademik gelişimlerini takip etmeleri için geliştirilmiş bir web uygulamasıdır. Supabase backend servisi ile entegre edilmiştir.

## 🚀 Özellikler

- **📊 Sınav Takibi**: Yazılı ve deneme sınavlarını ayrı ayrı takip etme
- **📈 Gelişim Grafikleri**: Deneme sınavları için görsel gelişim grafikleri
- **📝 Not Alma**: Önemli notları kaydetme ve kategorize etme
- **📋 Ödev Yönetimi**: Ödev takibi ve teslim tarihleri
- **👁️ Gözlem Kayıtları**: Öğretmen gözlemlerini kaydetme
- **💬 Mesajlaşma**: Öğretmenler ve arkadaşlarla iletişim
- **⏰ Çalışma Takibi**: Çalışma süreleri ve verimlilik analizi
- **📅 Ajanda**: Etkinlik ve plan yönetimi
- **❌ Devamsızlık Takibi**: Devamsızlık kayıtları ve mazeretler

## 🛠️ Kurulum

### 1. Supabase Projesi Oluşturma

1. [Supabase](https://supabase.com) hesabı oluşturun
2. Yeni proje oluşturun
3. Proje URL'sini ve anonim anahtarını not edin

### 2. Veritabanı Kurulumu

1. Supabase Dashboard'da **SQL Editor**'a gidin
2. `supabase-setup.sql` dosyasının içeriğini kopyalayın
3. SQL Editor'da çalıştırın

### 3. Uygulama Konfigürasyonu

1. `index.html` dosyasında aşağıdaki satırları bulun:
```javascript
const supabaseUrl = 'YOUR_SUPABASE_URL';
const supabaseKey = 'YOUR_SUPABASE_ANON_KEY';
```

2. Bu değerleri Supabase projenizden aldığınız gerçek değerlerle değiştirin:
   - **Project URL**: Settings > API > Project URL
   - **Anon Key**: Settings > API > Project API keys > anon public

### 4. Test Kullanıcısı

Sistem şu test kullanıcısı ile çalışır:
- **Kullanıcı Adı**: `k1`
- **Şifre**: `k2`

## 📊 Veritabanı Yapısı

### Ana Tablolar

1. **profiles**: Kullanıcı profilleri
2. **sinavlar**: Sınav kayıtları
3. **dersler**: Ders bilgileri
4. **notlar**: Not kayıtları
5. **odevler**: Ödev takibi
6. **gozlemler**: Öğretmen gözlemleri
7. **mesajlar**: Mesajlaşma sistemi
8. **calisma_oturumlari**: Çalışma oturumları
9. **ajanda_etkinlikleri**: Ajanda etkinlikleri
10. **devamsizlik**: Devamsızlık kayıtları

### Güvenlik

- **Row Level Security (RLS)** etkinleştirilmiştir
- Her kullanıcı sadece kendi verilerine erişebilir
- Otomatik kullanıcı profil oluşturma

## 🔧 Kullanım

### Giriş Yapma
1. Uygulamayı açın
2. Test kullanıcısı ile giriş yapın (k1/k2)
3. Dashboard'a yönlendirileceksiniz

### Sınav Ekleme
1. **Sınavlar** sayfasına gidin
2. Sınav türünü seçin (Yazılı/Deneme)
3. Sınav bilgilerini doldurun
4. **Kaydet** butonuna tıklayın

### Deneme Gelişim Grafiği
1. **Deneme Sınavları** seçeneğini seçin
2. Grafik otomatik olarak görünecektir
3. Yeni deneme ekledikçe grafik güncellenir

### Sayfa Geçişleri
Alt menüdeki dairesel butonlara tıklayarak farklı sayfalara geçebilirsiniz:
- 📊 Konular
- 🏆 Başarılarım
- 📚 Kütüphane
- 🏀 Kulüpler
- ❤️ Sağlık
- 🚌 Öğrenci Servisi
- 💻 Online Sınavlar
- 🖱️ Online Hizmetler

## 🔄 Veri Senkronizasyonu

### Supabase Entegrasyonu
- Tüm veriler Supabase veritabanında saklanır
- Gerçek zamanlı senkronizasyon
- Otomatik yedekleme

### Fallback Sistemi
- İnternet bağlantısı yoksa localStorage kullanılır
- Bağlantı geri geldiğinde veriler senkronize edilir

## 🎨 Özelleştirme

### Renk Temaları
Her sayfa için farklı gradient renkler kullanılmıştır:
- Konular: Mavi gradient
- Başarılarım: Pembe gradient
- Kütüphane: Mavi gradient
- Kulüpler: Turuncu gradient
- Sağlık: Pembe gradient
- Öğrenci Servisi: Yeşil gradient
- Online Sınavlar: Mor gradient
- Online Hizmetler: Gri gradient

### Animasyonlar
- Hover efektleri
- Smooth geçişler
- Modal animasyonları
- Shimmer efektleri

## 🚀 Deployment

### Statik Hosting
Uygulamayı şu platformlarda yayınlayabilirsiniz:
- Netlify
- Vercel
- GitHub Pages
- Firebase Hosting

### Environment Variables
Production'da environment variables kullanın:
```javascript
const supabaseUrl = process.env.SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_ANON_KEY;
```

## 🔒 Güvenlik

- Supabase RLS politikaları
- Kullanıcı bazlı veri izolasyonu
- Güvenli API anahtarları
- HTTPS zorunluluğu

## 📱 Responsive Tasarım

- Mobil uyumlu
- Tablet desteği
- Desktop optimizasyonu
- Touch-friendly butonlar

## 🐛 Sorun Giderme

### Yaygın Sorunlar

1. **Supabase bağlantı hatası**
   - URL ve API anahtarını kontrol edin
   - CORS ayarlarını kontrol edin

2. **Veri yüklenmiyor**
   - RLS politikalarını kontrol edin
   - Kullanıcı oturumunu kontrol edin

3. **Grafik görünmüyor**
   - Chart.js CDN'ini kontrol edin
   - Console hatalarını kontrol edin

### Debug Modu
Console'da debug bilgilerini görmek için:
```javascript
localStorage.setItem('debug', 'true');
```

## 📞 Destek

Sorunlarınız için:
1. Console hatalarını kontrol edin
2. Supabase Dashboard'da logları inceleyin
3. Network sekmesinde API çağrılarını kontrol edin

## 🔄 Güncellemeler

### v1.0.0
- Temel sınav takip sistemi
- Supabase entegrasyonu
- Responsive tasarım
- Deneme gelişim grafikleri

### Gelecek Özellikler
- [ ] Gerçek zamanlı mesajlaşma
- [ ] Dosya yükleme
- [ ] Push bildirimleri
- [ ] Offline mod
- [ ] Çoklu dil desteği

## 📄 Lisans

Bu proje MIT lisansı altında lisanslanmıştır.

---

**Not**: Bu uygulama eğitim amaçlı geliştirilmiştir. Production kullanımı için ek güvenlik önlemleri alınmalıdır.
