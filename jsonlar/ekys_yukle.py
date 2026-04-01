"""
EKYS İçerik Yükleyici
======================
Kullanım:
  pip install supabase
  python ekys_yukle.py

.env veya environment variable olarak ayarla:
  SUPABASE_URL=https://xxxxx.supabase.co
  SUPABASE_SERVICE_KEY=eyJhbGc...   (service_role key - Settings > API)
"""

import json
import os
import re
import sys
import ssl
import httpx
from supabase import create_client, Client

# ─── AYARLAR ─────────────────────────────────────────────────────────────────
SUPABASE_URL = os.environ.get("SUPABASE_URL", "https://oeuetjyczxqbotyuicoi.supabase.co")
SUPABASE_KEY = os.environ.get("SUPABASE_SERVICE_KEY", "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9ldWV0anljenhxYm90eXVpY29pIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3NDUzNzM3MiwiZXhwIjoyMDkwMTEzMzcyfQ.xtRESHL5anSBdt2mlAb33I_d9Gk9SsuIDhdeFdJscqs")


# JSON dosyalarının yolu ve slug/title bilgileri
FILES = [
    {
        "path": "EKYS_TYMM_01_Vizyon_Felsefe.json",
        "slug": "tymm_vizyon_felsefe",
        "title": "TYMM — Vizyon, Felsefe ve Bütünsel Eğitim Yaklaşımı",
    },
    {
        "path": "EKYS_TYMM_02_EDE_10_Kok_Deger.json",
        "slug": "tymm_ede_kok_deger",
        "title": "TYMM — Erdem-Değer-Eylem Çerçevesi (10 Kök Değer)",
    },
    {
        "path": "EKYS_TYMM_03_Beceriler_Cercevesi.json",
        "slug": "tymm_beceriler_cercevesi",
        "title": "TYMM — Beceriler Çerçevesi ve Öğrenme Alanları",
    },
]

# Ana konu bilgisi
TYMM_TOPIC = {
    "title": "Türkiye Yüzyılı Maarif Modeli",
    "description": "EKYS sınavının %30 ağırlığını oluşturan, yeni müfredatın temel konu alanı.",
    "icon": "📚",
    "order_index": 1,
}


# ─── YARDIMCI FONKSİYONLAR ───────────────────────────────────────────────────

def fix_and_parse(path: str) -> dict:
    """JSON içindeki tırnak hatalarını düzeltip parse et."""
    with open(path, encoding="utf-8") as f:
        raw = f.read().replace("\r\n", "\n").replace("\r", "")
    lines = raw.split("\n")
    fixed = []
    for line in lines:
        m = re.match(r'^(\s*"[^"]+"\s*:\s*)"(.*)"(,?)$', line)
        if m:
            val = (
                m.group(2)
                .replace('\\"', "__ESC__")
                .replace('"', "'")
                .replace("__ESC__", '\\"')
            )
            fixed.append(f'{m.group(1)}"{val}"{m.group(3)}')
        else:
            fixed.append(line)
    return json.loads("\n".join(fixed))


def get_or_create_topic(sb, topic_data: dict) -> str:
    """Ana konuyu bul ya da oluştur, ID döndür."""
    res = (
        sb.table("topics")
        .select("id")
        .eq("title", topic_data["title"])
        .execute()
    )
    if res.data:
        topic_id = res.data[0]["id"]
        print(f"  → Mevcut topic bulundu: {topic_id}")
        return topic_id

    res = sb.table("topics").insert(topic_data).execute()
    topic_id = res.data[0]["id"]
    print(f"  → Yeni topic oluşturuldu: {topic_id}")
    return topic_id


def get_or_create_subtopic(sb, topic_id: str, slug: str, title: str, order_index: int) -> str:
    """Alt konuyu bul ya da oluştur, ID döndür."""
    res = sb.table("subtopics").select("id").eq("slug", slug).execute()
    if res.data:
        sub_id = res.data[0]["id"]
        print(f"  → Mevcut subtopic bulundu: {slug} ({sub_id})")
        return sub_id

    res = sb.table("subtopics").insert({
        "topic_id": topic_id,
        "title": title,
        "slug": slug,
        "order_index": order_index,
    }).execute()
    sub_id = res.data[0]["id"]
    print(f"  → Yeni subtopic oluşturuldu: {slug} ({sub_id})")
    return sub_id


def upload_summary(sb, subtopic_id: str, data: dict):
    """Özeti yükle."""
    summary = data.get("summary", {})

    # Önce mevcut özeti sil (temiz yükleme için)
    sb.table("content_items").delete().eq("subtopic_id", subtopic_id).eq("type", "summary").execute()

    sb.table("content_items").insert({
        "subtopic_id": subtopic_id,
        "type": "summary",
        "title": summary.get("title", data["subtopic_title"]),
        "body_md": summary.get("body_md", ""),
        "audio_url": data.get("audio_url"),
        "order_index": 0,
    }).execute()
    print(f"  ✓ Özet yüklendi ({len(summary.get('body_md',''))} karakter)")


def upload_flashcards(sb, subtopic_id: str, flashcards: list):
    """Flashcard'ları yükle."""
    # Önce eskiyi temizle
    sb.table("content_items").delete().eq("subtopic_id", subtopic_id).eq("type", "flashcard").execute()

    if not flashcards:
        print("  ⚠ Flashcard bulunamadı, atlandı.")
        return

    rows = []
    for i, fc in enumerate(flashcards):
        rows.append({
            "subtopic_id": subtopic_id,
            "type": "flashcard",
            "title": fc["front_text"][:100],
            "front_text": fc["front_text"],
            "body_md": fc["body_md"],
            "difficulty": fc.get("difficulty", 1),
            "order_index": fc.get("order_index", i),
        })

    # Supabase batch insert (max 1000 satır)
    sb.table("content_items").insert(rows).execute()
    print(f"  ✓ {len(rows)} flashcard yüklendi")


def upload_questions(sb, subtopic_id: str, questions: list):
    """Soruları yükle."""
    # Önce eskiyi temizle
    sb.table("questions").delete().eq("subtopic_id", subtopic_id).execute()

    if not questions:
        print("  ⚠ Soru bulunamadı, atlandı.")
        return

    rows = []
    for q in questions:
        rows.append({
            "subtopic_id": subtopic_id,
            "question_type": "multiple_choice",
            "question_text": q["question_text"],
            "options": q["options"],
            "correct_index": q["correct_index"],
            "explanation": q.get("explanation", ""),
            "difficulty": q.get("difficulty", 1),
        })

    sb.table("questions").insert(rows).execute()

    # Zorluk dağılımı
    z = {1: 0, 2: 0, 3: 0}
    for q in questions:
        z[q.get("difficulty", 1)] += 1
    print(f"  ✓ {len(rows)} soru yüklendi (kolay={z[1]}, orta={z[2]}, zor={z[3]})")


# ─── ANA FONKSİYON ───────────────────────────────────────────────────────────

def main():
    # Credential kontrolü
    if not SUPABASE_URL or not SUPABASE_KEY:
        print("❌ HATA: SUPABASE_URL ve SUPABASE_SERVICE_KEY env değişkenleri gerekli!")
        print()
        print("Şöyle ayarla:")
        print("  Windows (PowerShell):")
        print('    $env:SUPABASE_URL="https://xxxxx.supabase.co"')
        print('    $env:SUPABASE_SERVICE_KEY="eyJhbGc..."')
        print()
        print("  Mac/Linux:")
        print('    export SUPABASE_URL="https://xxxxx.supabase.co"')
        print('    export SUPABASE_SERVICE_KEY="eyJhbGc..."')
        sys.exit(1)

    print("🔌 Supabase bağlantısı kuruluyor...")

    # SSL sertifika hatası için bypass (kurumsal ağ / VPN sorunu)
    import warnings, os
    warnings.filterwarnings("ignore")
    os.environ["PYTHONHTTPSVERIFY"] = "0"

    try:
        import urllib3
        urllib3.disable_warnings()
    except Exception:
        pass

    # SSL doğrulamayı global olarak kapat
    import ssl
    ssl._create_default_https_context = ssl._create_unverified_context

    # httpx client SSL bypass ile oluştur
    import httpx
    try:
        # Yeni supabase sürümleri için
        from supabase.client import ClientOptions
        sb = create_client(
            SUPABASE_URL,
            SUPABASE_KEY,
            options=ClientOptions(
                httpx_client_args={"verify": False}
            ),
        )
    except (ImportError, TypeError):
        # Eski sürümler için
        sb = create_client(SUPABASE_URL, SUPABASE_KEY)

    print("✅ Bağlantı başarılı!\n")

    # Ana konuyu oluştur/bul
    print("📁 Ana konu (topic) hazırlanıyor...")
    topic_id = get_or_create_topic(sb, TYMM_TOPIC)
    print()

    # Her dosyayı işle
    errors = []
    for i, file_info in enumerate(FILES, 1):
        path = file_info["path"]
        slug = file_info["slug"]
        title = file_info["title"]

        print(f"{'='*55}")
        print(f"[{i}/{len(FILES)}] {slug}")
        print(f"{'='*55}")

        # Dosya var mı?
        if not os.path.exists(path):
            msg = f"Dosya bulunamadı: {path}"
            print(f"  ❌ {msg}")
            errors.append(msg)
            print()
            continue

        # Parse et
        try:
            data = fix_and_parse(path)
        except json.JSONDecodeError as e:
            msg = f"JSON parse hatası ({path}): {e}"
            print(f"  ❌ {msg}")
            errors.append(msg)
            print()
            continue

        # Slug ve title'ı dosya config'inden al (JSON'daki [SLUG] yerine)
        data["subtopic_slug"] = slug
        data["subtopic_title"] = title

        # Subtopic oluştur/bul
        subtopic_id = get_or_create_subtopic(sb, topic_id, slug, title, i)

        # İçerikleri yükle
        try:
            upload_summary(sb, subtopic_id, data)
            upload_flashcards(sb, subtopic_id, data.get("flashcards", []))
            upload_questions(sb, subtopic_id, data.get("questions", []))
            print(f"\n✅ {slug} tamamlandı!\n")
        except Exception as e:
            msg = f"Yükleme hatası ({slug}): {e}"
            print(f"  ❌ {msg}")
            errors.append(msg)
            print()

    # Özet rapor
    print("=" * 55)
    print("📊 YÜKLEME RAPORU")
    print("=" * 55)
    basarili = len(FILES) - len(errors)
    print(f"  Toplam  : {len(FILES)} dosya")
    print(f"  Başarılı: {basarili}")
    print(f"  Hatalı  : {len(errors)}")
    if errors:
        print("\n  Hatalar:")
        for e in errors:
            print(f"    • {e}")
    print()

    if basarili == len(FILES):
        print("🎉 Tüm içerikler başarıyla Supabase'e yüklendi!")
        print()
        print("Sonraki adımlar:")
        print("  1. Supabase Dashboard > Table Editor > content_items kontrol et")
        print("  2. Supabase Dashboard > Table Editor > questions kontrol et")
        print("  3. Flutter uygulamayı çalıştır, konular görünüyor mu test et")
    else:
        print("⚠️  Bazı dosyalar yüklenemedi, yukarıdaki hataları kontrol et.")


if __name__ == "__main__":
    main()