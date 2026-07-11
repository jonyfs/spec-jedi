<!-- i18n-sync: source=CONTRIBUTING.md@01f83f5 lang=id -->
> 🌐 Dokumen ini adalah terjemahan berbantuan AI. **Bahasa Inggris adalah
> sumber kanonis** ([Principle I](../../../.specify/memory/constitution.md));
> jika ada perbedaan, bahasa Inggris yang berlaku. Lihat bahasa lain:
> [English](../../../CONTRIBUTING.md) · [中文](../zh/CONTRIBUTING.md) ·
> [हिन्दी](../hi/CONTRIBUTING.md) · [Español](../es/CONTRIBUTING.md) ·
> [Français](../fr/CONTRIBUTING.md) · [العربية](../ar/CONTRIBUTING.md) ·
> [বাংলা](../bn/CONTRIBUTING.md) · [Português](../pt/CONTRIBUTING.md) ·
> [Русский](../ru/CONTRIBUTING.md) · [اردو](../ur/CONTRIBUTING.md) ·
> [Bahasa Indonesia](../id/CONTRIBUTING.md)

# Berkontribusi pada Spec Jedi

Spec Jedi dibangun di bawah [constitution](../../../.specify/memory/constitution.md)
miliknya sendiri — sekumpulan aturan tak-terganggu-gugat yang diberi
versi yang menjadi acuan verifikasi setiap perubahan, termasuk ini.
Dokumen ini adalah pendamping praktis untuk "bagaimana saya benar-benar
berkontribusi"; constitution adalah pernyataan definitif tentang
*mengapa* setiap aturan ada.

## Sebelum menulis apa pun

1. **Baca constitution.** Minimal, telusuri sekilas
   [Core Principles](../../../.specify/memory/constitution.md) I-XX —
   sebagian besar pertanyaan kontribusi ("apakah saya perlu test?",
   "bagaimana ini seharusnya dinamai?", "apakah ini perlu riset dulu?")
   sudah dijawab di sana.
2. **Riset kompetitif diperlukan untuk skill `specjedi-*` baru mana
   pun** (Principle II, tidak dapat dinegosiasikan). Sebelum
   mengusulkan skill baru, bandingkan dengan
   [github/spec-kit](https://github.com/github/spec-kit) dan setidaknya
   sepuluh alat SDD lain yang tersedia secara publik, dan sebutkan
   setidaknya satu kontribusi asli yang dibuat oleh usulan Anda di luar
   apa yang sudah ditawarkan oleh salah satunya. Tuliskan ini dalam
   `research.md` di samping spesifikasi fitur — lihat
   `specs/001-specjedi-pipeline/research.md` dan
   `specs/002-specjedi-onboard/research.md` untuk bentuk yang
   diharapkan.
3. **Periksa `references/skill-roadmap.md`** — ide Anda mungkin sudah
   dibatasi di sana dengan catatan prioritisasi; memperluas usulan yang
   sudah ada biasanya lebih baik daripada membuka yang bersaing.

## Bagaimana perubahan dikirim

Proyek ini berbasis trunk (Principle X):

- `main` adalah trunk. **Tidak ada commit yang pernah mendarat
  langsung di `main`.**
- Setiap perubahan keluar di branch berumur pendeknya sendiri sebagai
  pull request.
- CI (`ci-gate`) menjalankan seluruh baterai validasi — lint
  struktural, pemeriksaan lintas platform (Linux/macOS/Windows,
  Principle XIII) — pada setiap PR. Sebuah PR hanya digabungkan setelah
  setiap pemeriksaan yang diperlukan hijau; tidak ada override manual
  atau jalur "gabungkan saja".
- **Auto-merge yang hanya berdasarkan pemeriksaan adalah hak istimewa
  PR milik pemilik repositori sendiri.** Jika Anda kontributor
  eksternal, PR Anda memerlukan review APPROVED eksplisit dari pemilik
  selain `ci-gate` yang hijau sebelum digabungkan — lihat job
  `owner-gate` di `.github/workflows/validate.yml` untuk mekanisme
  yang tepat.

## Menambah atau mengubah skill `specjedi-*`

Skill baru dan perubahan substansial pada skill yang ada mengikuti
pipeline SDD proyek ini sendiri — sama seperti yang dikirimkan Spec
Jedi sebagai produk (bagian Development Workflow dari constitution):

1. **Riset** (Principle II) — lihat di atas.
2. **Spesifikasi** — sebuah `spec.md` dengan user story yang
   diprioritaskan, requirement fungsional, dan kriteria sukses yang
   terukur. Tandai ambiguitas asli dengan `NEEDS CLARIFICATION` alih-alih
   menebak (Principle V).
3. **Klarifikasi** — selesaikan ambiguitas yang ditandai sebelum
   merencanakan berdasarkan tebakan.
4. **Perencanaan** — sebuah `plan.md` dengan gate Constitution Check
   yang nyata: jika perubahan Anda akan melanggar sebuah principle,
   sederhanakan itu atau catat justifikasi secara eksplisit di
   Complexity Tracking, jangan pernah melewati gate secara diam-diam.
5. **Tugas** — sebuah `tasks.md` yang terurut berdasarkan dependensi,
   test-first di mana rencana memerlukan kode (Principle VI).
6. **Implementasi** — hanya melalui feature branch dan PR (lihat di
   atas), tidak pernah commit langsung ke trunk.

Setiap direktori `specs/NNN-feature/` yang dikirim di repositori ini
adalah contoh kerja dari bentuk ini — `specs/001-specjedi-pipeline/`
dan `specs/002-specjedi-onboard/` adalah referensi paling lengkap.

## Skill Authoring dan Prompt Engineering Standard

Setiap `SKILL.md` di repositori ini, baru atau dimodifikasi, HARUS
menyertakan (Principle XIX; detail lengkap di
[`references/skill-authoring-standard.md`](../../../references/skill-authoring-standard.md)):

- Persona yang jelas dan pernyataan tugas.
- Format output yang terdefinisi.
- Setidaknya satu contoh lengkap "input → output" yang dikerjakan.
- Instruksi chain-of-thought untuk keputusan penilaian non-deterministik
  apa pun.
- Guardrail **Always** / **Never** yang eksplisit.
- Kriteria sukses yang dapat diverifikasi — fakta yang dapat diperiksa,
  bukan perasaan.
- Kalibrasi audiens di mana narasi skill itu sendiri membutuhkannya
  (dari pemula hingga lanjutan, Principle I).

## Validasi sebelum meminta review

Jalankan lint struktural secara lokal sebelum membuka PR:

```bash
bash scripts/validate.sh      # macOS/Linux
pwsh scripts/validate.ps1     # Windows
```

Keduanya harus lolos — proyek ini mendukung Linux, macOS, dan Windows
secara setara (Principle XIII); perubahan yang hanya berfungsi pada
satu platform belum selesai.

Jika skill Anda menghasilkan kode, itu juga memerlukan dry run
berbasis skenario yang mengonfirmasi bahwa pertanyaan elisitasi dan
logika percabangannya berperilaku seperti yang didokumentasikan
(Principle IX) — jelaskan apa yang Anda uji dalam deskripsi PR.

## Suara dan penamaan

- Skill produk dinamai `specjedi-*`, tidak pernah `speckit-*` — yang
  terakhir adalah tooling bootstrap internal yang didistribusikan
  (vendored) yang digunakan repositori ini untuk membangun dirinya
  sendiri, bukan sesuatu yang diinstal oleh pengguna akhir
  (Principle XV). Lihat bagian "Bagaimana Spec Jedi membangun dirinya
  sendiri" di README jika perbedaan ini tidak jelas.
- Narasi yang menghadap pengguna akhir (bukan konten literal dari
  field `spec.md`/`plan.md`/`tasks.md` yang dihasilkan) menggunakan
  suara bernuansa Star Wars khas Spec Jedi (Principle XII) — lihat
  `references/star-wars-lexicon.md` untuk leksikon referensi. *Konten*
  artefak yang dihasilkan tetap presisi dan sesuai dari segi
  jargon; suara berlaku untuk narasi skill itu sendiri di sekitarnya.

## Menjaga README tetap jujur

Jika perubahan Anda menambahkan skill yang dikirim, fakta baru yang
layak mendapat badge, atau dengan cara lain mengubah apa yang benar
tentang proyek ini, perbarui `README.md` dalam PR yang sama — tabel
"Apa yang Anda dapatkan hari ini", penomoran Quickstart, dan diagram
Mermaid pipeline semuanya perlu tetap sinkron (Principle XVI). Tinjau
baris badge sebelum membuka PR: konfirmasi bahwa setiap badge yang ada
masih terbaca dengan benar, dan tambahkan yang baru hanya jika
perubahan Anda adalah fakta yang benar-benar baru dan relevan yang
layak disinyalkan — jangan pernah nilai yang diketik manual yang bisa
menjadi usang (Distribution & Ecosystem Standards).

## Pertanyaan

Jika ada sesuatu dalam constitution yang tidak jelas, itu layak
diangkat sebagai issue tersendiri — aturan yang tidak dapat diikuti
siapa pun karena ambigu adalah cacat dalam constitution, bukan pada
Anda.
