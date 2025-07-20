-- Supabase Veritabanı Kurulumu
-- Bu dosyayı Supabase SQL Editor'da çalıştırın

-- Kullanıcılar tablosu (auth.users ile genişletilmiş)
CREATE TABLE IF NOT EXISTS public.profiles (
    id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
    username TEXT UNIQUE NOT NULL,
    full_name TEXT,
    avatar_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Sınavlar tablosu
CREATE TABLE IF NOT EXISTS public.sinavlar (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
    tur TEXT NOT NULL CHECK (tur IN ('yazili', 'deneme')),
    ad TEXT NOT NULL,
    tarih DATE NOT NULL,
    sonuc INTEGER NOT NULL,
    max_puan INTEGER NOT NULL,
    notlar TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Dersler tablosu
CREATE TABLE IF NOT EXISTS public.dersler (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
    ad TEXT NOT NULL,
    aciklama TEXT,
    renk TEXT DEFAULT '#4a90e2',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Notlar tablosu
CREATE TABLE IF NOT EXISTS public.notlar (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
    baslik TEXT NOT NULL,
    icerik TEXT,
    kategori TEXT,
    onemli BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Ödevler tablosu
CREATE TABLE IF NOT EXISTS public.odevler (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
    baslik TEXT NOT NULL,
    aciklama TEXT,
    ders_id UUID REFERENCES public.dersler(id) ON DELETE SET NULL,
    teslim_tarihi DATE,
    tamamlandi BOOLEAN DEFAULT FALSE,
    oncelik TEXT DEFAULT 'normal' CHECK (oncelik IN ('dusuk', 'normal', 'yuksek')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Gözlemler tablosu
CREATE TABLE IF NOT EXISTS public.gozlemler (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
    ogretmen_adi TEXT,
    ders TEXT,
    gozlem TEXT NOT NULL,
    tarih DATE DEFAULT CURRENT_DATE,
    onemli BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Mesajlar tablosu
CREATE TABLE IF NOT EXISTS public.mesajlar (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    gonderen_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
    alici_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
    mesaj TEXT NOT NULL,
    okundu BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Çalışma oturumları tablosu
CREATE TABLE IF NOT EXISTS public.calisma_oturumlari (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
    baslik TEXT NOT NULL,
    baslangic TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    bitis TIMESTAMP WITH TIME ZONE,
    sure_dakika INTEGER,
    verimlilik INTEGER CHECK (verimlilik >= 1 AND verimlilik <= 10),
    notlar TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Ajanda etkinlikleri tablosu
CREATE TABLE IF NOT EXISTS public.ajanda_etkinlikleri (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
    baslik TEXT NOT NULL,
    aciklama TEXT,
    baslangic TIMESTAMP WITH TIME ZONE NOT NULL,
    bitis TIMESTAMP WITH TIME ZONE,
    tam_gun BOOLEAN DEFAULT FALSE,
    renk TEXT DEFAULT '#4a90e2',
    hatirlatma TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Devamsızlık kayıtları tablosu
CREATE TABLE IF NOT EXISTS public.devamsizlik (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
    tarih DATE NOT NULL,
    sebep TEXT,
    mazeretli BOOLEAN DEFAULT FALSE,
    mazeret_belgesi TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- İndeksler
CREATE INDEX IF NOT EXISTS idx_sinavlar_user_id ON public.sinavlar(user_id);
CREATE INDEX IF NOT EXISTS idx_sinavlar_tarih ON public.sinavlar(tarih);
CREATE INDEX IF NOT EXISTS idx_dersler_user_id ON public.dersler(user_id);
CREATE INDEX IF NOT EXISTS idx_notlar_user_id ON public.notlar(user_id);
CREATE INDEX IF NOT EXISTS idx_odevler_user_id ON public.odevler(user_id);
CREATE INDEX IF NOT EXISTS idx_odevler_teslim_tarihi ON public.odevler(teslim_tarihi);
CREATE INDEX IF NOT EXISTS idx_gozlemler_user_id ON public.gozlemler(user_id);
CREATE INDEX IF NOT EXISTS idx_mesajlar_gonderen_id ON public.mesajlar(gonderen_id);
CREATE INDEX IF NOT EXISTS idx_mesajlar_alici_id ON public.mesajlar(alici_id);
CREATE INDEX IF NOT EXISTS idx_calisma_oturumlari_user_id ON public.calisma_oturumlari(user_id);
CREATE INDEX IF NOT EXISTS idx_ajanda_etkinlikleri_user_id ON public.ajanda_etkinlikleri(user_id);
CREATE INDEX IF NOT EXISTS idx_devamsizlik_user_id ON public.devamsizlik(user_id);

-- Row Level Security (RLS) etkinleştirme
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.sinavlar ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.dersler ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notlar ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.odevler ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.gozlemler ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.mesajlar ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.calisma_oturumlari ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.ajanda_etkinlikleri ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.devamsizlik ENABLE ROW LEVEL SECURITY;

-- RLS Politikaları

-- Profiles politikaları
CREATE POLICY "Kullanıcılar kendi profillerini görebilir" ON public.profiles
    FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Kullanıcılar kendi profillerini güncelleyebilir" ON public.profiles
    FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Kullanıcılar kendi profillerini oluşturabilir" ON public.profiles
    FOR INSERT WITH CHECK (auth.uid() = id);

-- Sınavlar politikaları
CREATE POLICY "Kullanıcılar kendi sınavlarını görebilir" ON public.sinavlar
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Kullanıcılar kendi sınavlarını ekleyebilir" ON public.sinavlar
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Kullanıcılar kendi sınavlarını güncelleyebilir" ON public.sinavlar
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Kullanıcılar kendi sınavlarını silebilir" ON public.sinavlar
    FOR DELETE USING (auth.uid() = user_id);

-- Dersler politikaları
CREATE POLICY "Kullanıcılar kendi derslerini görebilir" ON public.dersler
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Kullanıcılar kendi derslerini ekleyebilir" ON public.dersler
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Kullanıcılar kendi derslerini güncelleyebilir" ON public.dersler
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Kullanıcılar kendi derslerini silebilir" ON public.dersler
    FOR DELETE USING (auth.uid() = user_id);

-- Notlar politikaları
CREATE POLICY "Kullanıcılar kendi notlarını görebilir" ON public.notlar
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Kullanıcılar kendi notlarını ekleyebilir" ON public.notlar
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Kullanıcılar kendi notlarını güncelleyebilir" ON public.notlar
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Kullanıcılar kendi notlarını silebilir" ON public.notlar
    FOR DELETE USING (auth.uid() = user_id);

-- Ödevler politikaları
CREATE POLICY "Kullanıcılar kendi ödevlerini görebilir" ON public.odevler
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Kullanıcılar kendi ödevlerini ekleyebilir" ON public.odevler
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Kullanıcılar kendi ödevlerini güncelleyebilir" ON public.odevler
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Kullanıcılar kendi ödevlerini silebilir" ON public.odevler
    FOR DELETE USING (auth.uid() = user_id);

-- Gözlemler politikaları
CREATE POLICY "Kullanıcılar kendi gözlemlerini görebilir" ON public.gozlemler
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Kullanıcılar kendi gözlemlerini ekleyebilir" ON public.gozlemler
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Kullanıcılar kendi gözlemlerini güncelleyebilir" ON public.gozlemler
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Kullanıcılar kendi gözlemlerini silebilir" ON public.gozlemler
    FOR DELETE USING (auth.uid() = user_id);

-- Mesajlar politikaları
CREATE POLICY "Kullanıcılar kendi mesajlarını görebilir" ON public.mesajlar
    FOR SELECT USING (auth.uid() = gonderen_id OR auth.uid() = alici_id);

CREATE POLICY "Kullanıcılar mesaj gönderebilir" ON public.mesajlar
    FOR INSERT WITH CHECK (auth.uid() = gonderen_id);

CREATE POLICY "Kullanıcılar kendi mesajlarını güncelleyebilir" ON public.mesajlar
    FOR UPDATE USING (auth.uid() = gonderen_id);

CREATE POLICY "Kullanıcılar kendi mesajlarını silebilir" ON public.mesajlar
    FOR DELETE USING (auth.uid() = gonderen_id);

-- Çalışma oturumları politikaları
CREATE POLICY "Kullanıcılar kendi çalışma oturumlarını görebilir" ON public.calisma_oturumlari
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Kullanıcılar kendi çalışma oturumlarını ekleyebilir" ON public.calisma_oturumlari
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Kullanıcılar kendi çalışma oturumlarını güncelleyebilir" ON public.calisma_oturumlari
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Kullanıcılar kendi çalışma oturumlarını silebilir" ON public.calisma_oturumlari
    FOR DELETE USING (auth.uid() = user_id);

-- Ajanda etkinlikleri politikaları
CREATE POLICY "Kullanıcılar kendi etkinliklerini görebilir" ON public.ajanda_etkinlikleri
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Kullanıcılar kendi etkinliklerini ekleyebilir" ON public.ajanda_etkinlikleri
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Kullanıcılar kendi etkinliklerini güncelleyebilir" ON public.ajanda_etkinlikleri
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Kullanıcılar kendi etkinliklerini silebilir" ON public.ajanda_etkinlikleri
    FOR DELETE USING (auth.uid() = user_id);

-- Devamsızlık politikaları
CREATE POLICY "Kullanıcılar kendi devamsızlık kayıtlarını görebilir" ON public.devamsizlik
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Kullanıcılar kendi devamsızlık kayıtlarını ekleyebilir" ON public.devamsizlik
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Kullanıcılar kendi devamsızlık kayıtlarını güncelleyebilir" ON public.devamsizlik
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Kullanıcılar kendi devamsızlık kayıtlarını silebilir" ON public.devamsizlik
    FOR DELETE USING (auth.uid() = user_id);

-- Trigger fonksiyonları
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger'ları oluştur
CREATE TRIGGER update_profiles_updated_at BEFORE UPDATE ON public.profiles FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_sinavlar_updated_at BEFORE UPDATE ON public.sinavlar FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_dersler_updated_at BEFORE UPDATE ON public.dersler FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_notlar_updated_at BEFORE UPDATE ON public.notlar FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_odevler_updated_at BEFORE UPDATE ON public.odevler FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_gozlemler_updated_at BEFORE UPDATE ON public.gozlemler FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_ajanda_etkinlikleri_updated_at BEFORE UPDATE ON public.ajanda_etkinlikleri FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Test kullanıcısı için profil oluşturma fonksiyonu
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.profiles (id, username, full_name)
    VALUES (NEW.id, NEW.email, NEW.raw_user_meta_data->>'full_name');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Yeni kullanıcı kaydı için trigger
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- Örnek veriler (isteğe bağlı)
INSERT INTO public.dersler (user_id, ad, aciklama, renk) VALUES 
('00000000-0000-0000-0000-000000000000', 'Matematik', 'Matematik dersi', '#FF6B35'),
('00000000-0000-0000-0000-000000000000', 'Fizik', 'Fizik dersi', '#4A90E2'),
('00000000-0000-0000-0000-000000000000', 'Kimya', 'Kimya dersi', '#32CD32'),
('00000000-0000-0000-0000-000000000000', 'Biyoloji', 'Biyoloji dersi', '#9370DB'),
('00000000-0000-0000-0000-000000000000', 'Türkçe', 'Türkçe dersi', '#FF69B4'),
('00000000-0000-0000-0000-000000000000', 'İngilizce', 'İngilizce dersi', '#FFD93D'),
('00000000-0000-0000-0000-000000000000', 'Tarih', 'Tarih dersi', '#8B4513'),
('00000000-0000-0000-0000-000000000000', 'Coğrafya', 'Coğrafya dersi', '#32CD32'); 